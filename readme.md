# AEI Smart Contract
[![CodeQL](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/codeql-analysis.yml)
[![publish Package](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/publish-npm.yml/badge.svg)](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/publish-npm.yml)
[![Solium Security](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/solium.yml/badge.svg)](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/solium.yml)
[![Build and Test](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/test-build-deploy.yml/badge.svg)](https://github.com/FIWARE-Blockchain/AEIContract/actions/workflows/test-build-deploy.yml)
[![NPM Version](https://badge.fury.io/js/aeicontract.svg)](https://badge.fury.io/js/aeicontract)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

AEI Smart Contract is written in Solidity using ERC721 standard (NFT) and can be use with Ethereum Clients. It is compatible with FIWARE-Canis Major Adaptor to store the data in blockchain.
AEI, asset, events (metadata), relationship, is designed to store the NGSI-LD model with the help of Canis Major Adaptor.

# AEI Model Architecture
![AEI Model Architecture](https://github.com/FIWARE-Blockchain/AEIContract/blob/master/docs/images/1.png)

1. Entity/Asset with a unique identity will be a new asset (1:1 mapping of asset to an identity).
2. Event or Metadata of the asset/entity has a 1:n mapping.
3. An Asset can have a 1:n relationship with any other asset.

#### Example
![Example](https://github.com/FIWARE-Blockchain/AEIContract/blob/master/docs/images/2.png)

To Store the NGSI-LD model there are few possibilities with the help of some supported storage type:

1. IPFS
2. IOTA MaM
3. MerkleRoot

![Example](https://github.com/FIWARE-Blockchain/AEIContract/blob/master/docs/images/3.png)

### Methods
```
- createAsset(bytes32 uuid, string memory _newHash)
- getAsset(bytes32 uuid)
- updateAsset(bytes32 uuid, string memory _newHash)
- removeAsset (bytes32 uuid)
- isValidAsset(bytes32 uuid, bytes32[] memory _proof, bytes32 _leaf)
- isValidAssetEthMessage(bytes32 uuid, bytes32 _messageHash, bytes memory _signature)
- addRelation(bytes32 uuid, bytes32 reluuid)
- getRelations(bytes32 uuid)
- removeRelation(bytes32 uuid, uint index)
- isValidRelation(bytes32 uuid, uint index, bytes32[] memory _proof, bytes32 _leaf)
- addMetadata(bytes32 uuid, string memory _metadatahash)
- getMetadatas(bytes32 uuid) public view returns (string[] memory)
- removeMetadata(bytes32 uuid, uint index)
- isValidMetadata(bytes32 uuid, uint index, bytes32[] memory _proof, bytes32 _leaf)
```
Apart from that ERC721, Ownable, MerkleProof, ECDSA methods are supported.

### Dependencies
_This project uses:_
 - truffle
 - NodeJS
 - Ganache-CLI (testrpc)
 - OpenZeppelin

## License

AEI Contract is licensed under the [MIT](LICENSE) License.

© 2021 FIWARE Foundation e.V.