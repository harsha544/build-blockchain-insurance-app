FROM node:8.11.2

RUN mkdir -p /opt/webservice/

COPY js/ /opt/webservice/

WORKDIR /opt/webservice 

RUN npm install 

EXPOSE 8081

CMD ["node", "web_service.js"]
