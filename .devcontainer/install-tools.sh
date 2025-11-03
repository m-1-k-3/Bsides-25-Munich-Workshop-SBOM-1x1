#!/bin/bash
set -e

echo "Installing SBOM Workshop Tools..."

# Install syft (SBOM generation tool)
# Using official Anchore installation method: https://github.com/anchore/syft#installation
echo "Installing Syft..."
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo sh -s -- -b /usr/local/bin

# Install grype (vulnerability scanner)
# Using official Anchore installation method: https://github.com/anchore/grype#installation
echo "Installing Grype..."
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin

# Install cdxgen (CycloneDX SBOM generator)
echo "Installing cdxgen..."
npm install -g @cyclonedx/cdxgen

# Install CycloneDX CLI (prebuilt Linux binary) so it's available as `cyclonedx`
echo "Installing CycloneDX CLI (binary)..."
sudo curl -sSfL "https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.29.1/cyclonedx-linux-x64" -o /usr/local/bin/cyclonedx
sudo chmod +x /usr/local/bin/cyclonedx

# Install sbomqs (.deb package)
echo "Installing sbomqs (.deb package)..."
SBOMQS_URL="https://github.com/interlynk-io/sbomqs/releases/download/v1.3.0/sbomqs_1.3.0_amd64.deb"
TMP_DEB="/tmp/sbomqs_1.3.0_amd64.deb"
sudo curl -sSfL "$SBOMQS_URL" -o "$TMP_DEB"
# Try to install; if dependencies are missing, fix them via apt
sudo dpkg -i "$TMP_DEB" || sudo apt-get update && sudo apt-get install -f -y

cd ..
git clone "https://github.com/keycloak/keycloak.git"
cd keycloak
git checkout "26.3.3"

# Verify installations
echo "Verifying installations..."
echo "Syft version:"
syft version

echo ""
echo "Grype version:"
grype version

echo ""
echo "cdxgen version:"
cdxgen --version

echo ""
echo "cyclonedx (binary) version:"
cyclonedx --version

echo ""
echo "sbomqs version:"
sbomqs --version
