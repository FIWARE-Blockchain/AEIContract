// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/cryptography/ECDSA.sol";

contract Assets is ERC721Full, Ownable {
    constructor() public ERC721Full("NGSIASSET", "NGA") {}

    struct Asset {
        address owner;
        string _hash;
        Relationship[] relation;
        Metadata[] meta;
    }

    struct Relationship {
        bytes32 _reluuid;
    }

    struct Metadata {
        string _metainfo;
    }

    function kill() public onlyOwner {
        selfdestruct(msg.sender);
    }

    mapping(bytes32 => Asset) private payloadHash;

    event AssetCreated(
        address owner,
        bytes32 uuid,
        uint256 timestamp,
        string filehash
    );
    event AssetUpdated(
        address owner,
        bytes32 uuid,
        uint256 timestamp,
        string filehash
    );
    event AssetRemoved(address owner, bytes32 uuid, uint256 timestamp);
    event RelationAdded(
        address owner,
        bytes32 uuid,
        uint256 timestamp,
        bytes32 _reluuid
    );
    event RelationRemoved(
        address owner,
        bytes32 uuid,
        uint256 timestamp,
        uint256 index
    );
    event MetadataAdded(
        address owner,
        bytes32 uuid,
        uint256 timestamp,
        string metadatahash
    );
    event MetadataRemoved(
        address owner,
        bytes32 uuid,
        uint256 timestamp,
        uint256 index
    );

    function createAsset(bytes32 uuid, string memory _newHash) public {
        if (payloadHash[uuid].owner == msg.sender) {
            revert("Asset exists");
        }
        payloadHash[uuid].owner = msg.sender;
        payloadHash[uuid]._hash = _newHash;
        // solium-disable-next-line
        emit AssetCreated(msg.sender, uuid, block.timestamp, _newHash);
    }

    function getAsset(bytes32 uuid) public view returns (string memory) {
        return payloadHash[uuid]._hash;
    }

    function updateAsset(bytes32 uuid, string memory _newHash) public {
        if (payloadHash[uuid].owner != msg.sender) {
            revert("Asset doesn't exists");
        }
        payloadHash[uuid]._hash = _newHash;
        // solium-disable-next-line
        emit AssetUpdated(msg.sender, uuid, block.timestamp, _newHash);
    }

    function removeAsset(bytes32 uuid) public {
        if (payloadHash[uuid].owner != msg.sender) {
            revert("you are not the owner of the asset");
        }
        delete payloadHash[uuid];
        // solium-disable-next-line
        emit AssetRemoved(msg.sender, uuid, block.timestamp);
    }

    // function isValidAsset(
    //     bytes32 uuid,
    //     bytes32[] memory _proof,
    //     bytes32 _leaf
    // ) public view returns (bool) {
    //     return
    //         MerkleProof.verify(
    //             _proof,
    //             stringToBytes32(payloadHash[uuid]._hash),
    //             _leaf
    //         );
    // }

    // /**
    //  * @notice Validate authenticity of message signed by Etherium private key.
    //  * On-chain validation is available only for Ethereum signed messages.
    //  * @param _messageHash Hash of sent message.
    //  * @param _signature Signature generated using web3.eth.sign().
    //  * @return Boolean status.
    //  */
    function isValidAssetEthMessage(
        bytes32 uuid,
        bytes32 _messageHash,
        bytes memory _signature
    ) public view returns (bool) {
        return
            ECDSA.recover(_messageHash, _signature) == payloadHash[uuid].owner;
    }

    function addRelation(bytes32 uuid, bytes32 reluuid) public {
        //check either uuid exist or not
        Relationship memory rel = Relationship(reluuid);
        payloadHash[uuid].relation.push(rel);
        // solium-disable-next-line
        emit RelationAdded(msg.sender, uuid, block.timestamp, reluuid);
    }

    function getRelations(bytes32 uuid) public view returns (bytes32[] memory) {
        bytes32[] memory metadataHash = new bytes32[](
            payloadHash[uuid].relation.length
        );

        for (uint256 i = 0; i < payloadHash[uuid].relation.length; i++) {
            Relationship storage relation = payloadHash[uuid].relation[i];
            metadataHash[i] = relation._reluuid;
        }
        return (metadataHash);
    }

    function removeRelation(bytes32 uuid, uint256 index) public {
        if (payloadHash[uuid].owner != msg.sender) {
            revert("you are not the owner of the asset");
        }
        delete payloadHash[uuid].relation[index];
        // solium-disable-next-line
        emit RelationRemoved(msg.sender, uuid, block.timestamp, index);
    }

    function isValidRelation(
        bytes32 uuid,
        uint256 index,
        bytes32[] memory _proof,
        bytes32 _leaf
    ) public view returns (bool) {
        return
            MerkleProof.verify(
                _proof,
                payloadHash[uuid].relation[index]._reluuid,
                _leaf
            );
    }

    function addMetadata(bytes32 uuid, string memory _metadatahash) public {
        //check either uuid exist or not
        Metadata memory meta = Metadata(_metadatahash);
        payloadHash[uuid].meta.push(meta);
        // solium-disable-next-line
        emit MetadataAdded(msg.sender, uuid, block.timestamp, _metadatahash);
    }

    function getMetadatas(bytes32 uuid) public view returns (string[] memory) {
        string[] memory metadataHash = new string[](
            payloadHash[uuid].meta.length
        );

        for (uint256 i = 0; i < payloadHash[uuid].meta.length; i++) {
            Metadata storage meta = payloadHash[uuid].meta[i];
            metadataHash[i] = meta._metainfo;
        }
        return (metadataHash);
    }

    function removeMetadata(bytes32 uuid, uint256 index) public {
        if (payloadHash[uuid].owner != msg.sender) {
            revert("you are not the owner of the asset");
        }
        delete payloadHash[uuid].meta[index];
        // solium-disable-next-line
        emit MetadataRemoved(msg.sender, uuid, block.timestamp, index);
    }

    // function isValidMetadata(
    //     bytes32 uuid,
    //     uint256 index,
    //     bytes32[] memory _proof,
    //     bytes32 _leaf
    // ) public view returns (bool) {
    //     return
    //         MerkleProof.verify(
    //             _proof,
    //             stringToBytes32(payloadHash[uuid].meta[index]._metainfo),
    //             _leaf
    //         );
    // }

    // function stringToBytes32(string memory source)
    //     public
    //     pure
    //     returns (bytes32 result)
    // {
    //     bytes memory tempEmptyStringTest = bytes(source);
    //     if (tempEmptyStringTest.length == 0) {
    //         return 0x0;
    //     }

    //     assembly {
    //         result := mload(add(source, 32))
    //     }
    // }
}
