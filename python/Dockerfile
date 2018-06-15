FROM python:2.7

RUN pip install cx_Oracle==6.3.1 && \
    apt update && \
    apt-get -y install unzip && \
    mkdir -p /opt/oracle/ && \
    apt install libaio1

ADD instantclient-basic-linux.leppc64.c64-12.2.0.1.0.zip /opt/oracle/

RUN sh -c "echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf" && \
	ldconfig && \
	cd /opt/oracle/ && \
	unzip instantclient-basic-linux.leppc64.c64-12.2.0.1.0.zip

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2
