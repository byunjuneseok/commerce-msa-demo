#!/bin/bash

# Exit on error
set -e

# Check if APP_NAME is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <app-name>"
    echo "Example: $0 order-api"
    exit 1
fi

# Check if GITHUB_TOKEN is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable is not set"
    echo "Please set your GitHub token: export GITHUB_TOKEN=your_token"
    exit 1
fi

APP_NAME=$1

# Determine version
ymd=$(git log -1 --date=format:'%y.%m.%d' --pretty=%ad)
hm=$(git log -1 --date=format:'%H%M' --pretty=%ad)
branch=$(git branch --show-current | tr -cd '[:alnum:].-')
SEMVER=$ymd-$branch.$hm
SHORT_SHA=$(git log -1 --pretty=%h)

# Set registry and image details
REGISTRY="ghcr.io"
REPO_OWNER=$(git config --get remote.origin.url | sed -E 's/.*github.com[:/]([^/]+)\/.*/\1/')
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
# Keep the original repository name format
IMAGE_NAME="${REPO_OWNER}/${REPO_NAME}-${APP_NAME}"
IMAGE_TAG="${SEMVER}-${SHORT_SHA}"

# Login to GitHub Container Registry
echo "Logging in to GitHub Container Registry..."
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$REPO_OWNER" --password-stdin > /dev/null 2>&1

# Build and push the image
echo "Building and pushing image..."
docker buildx build \
    --file Dockerfile.arm64 \
    --platform linux/arm64 \
    --tag "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}" \
    --tag "${REGISTRY}/${IMAGE_NAME}:latest" \
    --build-arg APP_NAME="${APP_NAME}" \
    --push \
    --load \
    .

echo "Build and push completed successfully!"
echo "Image: ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
echo "Latest: ${REGISTRY}/${IMAGE_NAME}:latest"
