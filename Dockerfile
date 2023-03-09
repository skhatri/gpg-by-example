FROM ubuntu:latest

RUN apt-get update 
RUN echo y | apt-get install gnupg jq curl unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip
RUN ./aws/install

RUN mkdir -p /opt/app /home/app

RUN groupadd --system --gid=1000 app && \
    useradd --system --no-log-init --gid=1000 --uid=1000 app

USER app

WORKDIR "/opt/app"

COPY --chown=app:app gpg-operation.sh /opt/app/gpg-operation.sh
COPY --chown=app:app download-encrypt-upload.sh /opt/app/
COPY --chown=app:app download-decrypt-upload.sh /opt/app/
COPY --chown=app:app download-upload-config.sh /opt/app/
COPY --chown=app:app s3.sh /opt/app/
COPY --chown=app:app crypto.sh /opt/app/crypto.sh
COPY --chown=app:app handler.sh /opt/app/handler.sh

ENTRYPOINT [ "/opt/app/gpg-operation.sh" ]
CMD ["encrypt"]



