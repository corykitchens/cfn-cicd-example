FROM python:latest
RUN pip3 install awscli
RUN curl https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip -o terraform.zip
RUN unzip terraform.zip -d /usr/bin/
RUN apt-get clean -y
RUN apt-get update -y
