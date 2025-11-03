#!/bin/bash
set -e

echo "Installing SBOM Workshop Tools..."

# Install syft (SBOM generation tool)
echo "Installing Syft..."
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo sh -s -- -b /usr/local/bin

# Install grype (vulnerability scanner)
echo "Installing Grype..."
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin

# Install cdxgen (CycloneDX SBOM generator)
echo "Installing cdxgen..."
sudo npm install -g @cyclonedx/cdxgen

# Verify installations
echo ""
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
echo "All tools installed successfully!"
echo ""
echo "Available commands:"
echo "  - syft: Generate SBOMs from container images and filesystems"
echo "  - grype: Scan for vulnerabilities in container images and filesystems"
echo "  - cdxgen: Generate CycloneDX SBOMs"
