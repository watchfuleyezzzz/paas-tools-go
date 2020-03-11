FROM golang:1.14-buster
ENV CF_CLI_VERSION="6.49.0"
ENV YQ_VERSION="3.2.1"
ENV SPRUCE_VERION="1.25.2"
ENV SWAGGER_VERION="0.13.0"
ENV CF_MGMT_VERSION="v1.0.43"
ENV BOSH_VERSION="6.2.1"
ENV GOVC_VERSION="0.22.1"
ENV PACKAGES "awscli unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg rsync make zip"
RUN apt-get update
RUN apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -L "https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v${CF_CLI_VERSION}/cf-cli_${CF_CLI_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin && \
    curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    ln -s /usr/local/bin/yq /usr/local/bin/yaml && \
    curl -L "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERION}/spruce-linux-amd64" -o /usr/local/bin/spruce && \
    curl -L "https://github.com/go-swagger/go-swagger/releases/download/${SWAGGER_VERION}/swagger_linux_amd64" -o /usr/local/bin/swagger && \
    curl -L "https://github.com/pivotalservices/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-linux" -o /usr/local/bin/cf-mgmt && \
    curl -L "https://github.com/pivotalservices/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-config-linux" -o /usr/local/bin/cf-mgmt-config && \
    curl -L "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh && \
    curl -L "https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_linux_amd64.gz" | gunzip > /usr/local/bin/govc && \
    chmod +x /usr/local/bin/*
RUN ln /usr/bin/uuidgen /usr/local/bin/uuid && \
    cf install-plugin -r CF-Community -f "blue-green-deploy" && \
    curl -L "https://github.com/contraband/autopilot/releases/download/0.0.8/autopilot-linux" -o /tmp/autopilot-linux && \
    cf install-plugin /tmp/autopilot-linux -f && \
    mkdir -p /root/.ssh && \
    git config --global user.email "git-ssh@example.com" && \
    git config --global user.name "Docker container git-ssh" && \
    go get -v github.com/onsi/ginkgo/ginkgo && \
    go get -v github.com/onsi/gomega/... && \
    go get -v github.com/EngineerBetter/stopover && \
    rm -rf /tmp/autopilot-linux $GOPATH/src
