FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# SBOM Workshop Development Container
# Includes: Node.js, Docker CLI, Syft, Grype, cdxgen, CycloneDX CLI, sbomqs

# Install Node.js (LTS)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl ca-certificates gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends nodejs \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Docker CLI and Docker Compose
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get -y install --no-install-recommends docker-ce-cli docker-compose-plugin \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Syft (SBOM generation tool)
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# Install Grype (vulnerability scanner)
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Install cdxgen (CycloneDX SBOM generator)
RUN npm install -g @cyclonedx/cdxgen

# Install CycloneDX CLI (prebuilt Linux binary)
RUN curl -sSfL "https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.29.1/cyclonedx-linux-x64" -o /usr/local/bin/cyclonedx \
    && chmod +x /usr/local/bin/cyclonedx

# Install sbomqs (.deb package)
RUN SBOMQS_URL="https://github.com/interlynk-io/sbomqs/releases/download/v1.3.0/sbomqs_1.3.0_amd64.deb" \
    && TMP_DEB="/tmp/sbomqs_1.3.0_amd64.deb" \
    && curl -sSfL "$SBOMQS_URL" -o "$TMP_DEB" \
    && (dpkg -i "$TMP_DEB" || (apt-get update && apt-get install -f -y)) \
    && rm -f "$TMP_DEB" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Verify installations (this will be logged during build)
RUN echo "=== Verifying installations ===" \
    && echo "Syft version:" && syft version \
    && echo "Grype version:" && grype version \
    && echo "cdxgen version:" && cdxgen --version \
    && echo "cyclonedx version:" && cyclonedx --version \
    && echo "sbomqs version:" && sbomqs --version

# Set the default user back to vscode
USER vscode
WORKDIR /workspaces
