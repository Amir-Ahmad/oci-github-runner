#!/bin/bash
set -euxo pipefail

# Install common tools
dnf install -y dnf-utils jq curl zip unzip

# Install docker
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce --nobest
systemctl enable docker.service
systemctl start docker.service

mkdir -p /opt/github-runner && cd /opt/github-runner

# Download latest github runner
url=$(curl -fsS https://api.github.com/repos/actions/runner/releases/latest \
    | jq -r '.assets[] | 
        select(.name | match("actions-runner-linux-arm64-[0-9.]*\\.tar\\.gz")) | 
        .browser_download_url')
curl -fsSL "$url" | tar xz

# Configure github runner
RUNNER_ALLOW_RUNASROOT=true ./config.sh --url "${GITHUB_RUNNER_URL}" \
    --token "${GITHUB_RUNNER_TOKEN}" \
    --labels "${GITHUB_RUNNER_LABELS}" \
    --unattended --work work

# Install as service and start
./svc.sh install
./svc.sh start
