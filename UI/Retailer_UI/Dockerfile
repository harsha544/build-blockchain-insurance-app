FROM node:8.11.2

RUN mkdir -p /opt/Retailer-UI/ && \
	apt update && \
	apt install -y unzip libaio1 

ADD instantclient-basic-linux.leppc64.c64-12.2.0.1.0.zip /opt/Retailer-UI/

ADD retailer_ui.tar /opt/Retailer-UI/

WORKDIR /opt/Retailer-UI

RUN unzip instantclient-basic-linux.leppc64.c64-12.2.0.1.0.zip && \
	npm install oracle/node-oracledb#v2.2.0 && \
	npm install

ENV LD_LIBRARY_PATH=/opt/Retailer-UI/instantclient_12_2

EXPOSE 8080

CMD ["node", "server.js"]
