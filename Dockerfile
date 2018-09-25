FROM golang:1.10-stretch

ENV PACKAGES "unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg rsync make zip"
RUN apt-get update && apt-get install -y --no-install-recommends ${PACKAGES}
RUN curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.33.1" | tar -zx -C /usr/local/bin

RUN curl -L "https://github.com/mikefarah/yq/releases/download/1.15.0/yq_linux_amd64" -o yq && chmod +x yq && mv yq /usr/local/bin/yq
RUN ln -s /usr/local/bin/yq /usr/local/bin/yaml

RUN curl -L "https://github.com/geofffranks/spruce/releases/download/v1.10.0/spruce-linux-amd64" -o spruce && chmod +x spruce && mv spruce /usr/local/bin/spruce

RUN ln /usr/bin/uuidgen /usr/local/bin/uuid

RUN curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.34.1" | tar -zx -C /usr/local/bin
RUN cf install-plugin -r CF-Community -f "blue-green-deploy"
RUN cf install-plugin -r CF-Community -f "autopilot"

RUN curl -L "https://github.com/go-swagger/go-swagger/releases/download/0.13.0/swagger_linux_amd64" -o swagger && chmod +x swagger && mv swagger /usr/local/bin/swagger

RUN mkdir -p /root/.ssh

RUN git config --global user.email "git-ssh@governmentpaas.docker" && \
    git config --global user.name "Docker container git-ssh"

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*