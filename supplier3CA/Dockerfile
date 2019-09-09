FROM hyperledger/fabric-ca:s390x-1.1.0

RUN mkdir /ca
COPY fabric-ca-server-config.yaml /ca
COPY tls /ca/tls
COPY ca /ca/ca
