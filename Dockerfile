FROM 1mill/terraform-sops:2020-07-02_03-40-45

RUN apt-get update && apt-get install --yes \
	unzip \
	wget

ARG APP_REPO=node-js-getting-started
ARG APP_VERSION=2020-07-04T04-28-31
RUN wget -O /tmp/code.zip https://github.com/1Mill/node-js-getting-started/archive/${APP_VERSION}.zip
RUN unzip /tmp/code.zip -d /tmp
RUN mv /tmp/*-${APP_VERSION}/*.tf* /app
RUN rm -rf /tmp/*-${APP_VERSION}
RUN rm /tmp/code.zip

CMD [ "terraform", "--version" ]
