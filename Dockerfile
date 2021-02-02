FROM fusionauth/fusionauth-app:latest

COPY ./start.sh /usr/local

CMD chmod a+x /usr/local/start.sh && \
    /usr/local/start.sh