# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:0-buster

LABEL project="nodeManager"
LABEL maintainer="CryptoKasm"
LABEL github="https://github.com/CryptoKasm/9c-nodemanager"
LABEL discord="https://discord.gg/CYaSzs4CSk"

ARG WORKDIRP="/9c-node"
WORKDIR ${WORKDIRP}

COPY . .

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby CLI instead of the licensed Docker CLI
ARG USE_MOBY="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && /bin/bash ${WORKDIRP}/.devcontainer/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Use Docker script from script library to set things up
    && /bin/bash ${WORKDIRP}/.devcontainer/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* ${WORKDIRP}/.devcontainer/library-scripts/

ENTRYPOINT ["./nodeManager.sh"]
CMD ["--demo"]