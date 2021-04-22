FROM node:12

RUN npm install -g truffle

COPY . .
RUN npm install \
    && npm config set bin-links false \
    && truffle compile 

ARG RPC_ENDPOINT
ARG RPC_PORT

ENV RPC_ENDPOINT $RPC_ENDPOINT
ENV RPC_PORT $RPC_PORT