ARG VARIANT="14-buster"
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}
RUN apt-get update

# install terraform
RUN wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip -O /tmp/terraform.zip && \
      (cd /tmp && unzip terraform.zip) && \
      rm /tmp/terraform.zip && \
      mv /tmp/terraform /usr/bin/

# install jq
RUN apt-get install -y jq

# install aws-cli
RUN apt-get install -y python3-pip && \
      pip3 install awscli