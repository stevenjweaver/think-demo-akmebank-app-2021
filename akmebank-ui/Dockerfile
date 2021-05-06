FROM registry.access.redhat.com/ubi8/nodejs-14:1-17

USER root
WORKDIR "/app"
ADD . /app
RUN  npm install
ENV PATH="/app:${PATH}"

ENTRYPOINT ["npm","start"]

