#!/usr/bin/env bash
#
# Build psanchezg/nginx-php-fpm images for one or more PHP versions.
#
# Usage:
#   ./build.sh                     # build PHP 8.2, 8.4 and 8.5 for the native platform
#   ./build.sh 8.4                 # build a single version
#   PUSH=1 ./build.sh              # build multi-arch and push to Docker Hub
#
# Environment variables:
#   IMAGE      Image name                    (default: psanchezg/nginx-php-fpm)
#   VERSION    Release version               (default: 2.3.0)
#   PLATFORMS  Platforms for PUSH=1          (default: linux/amd64,linux/arm64)
#   PUSH       1 to push instead of loading  (default: 0)
#
set -euo pipefail

IMAGE="${IMAGE:-psanchezg/nginx-php-fpm}"
VERSION="${VERSION:-2.3.0}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
PUSH="${PUSH:-0}"
DISTRO_VER="3.24"

php_version_for() {
  case "$1" in
    8.2) echo "8.2.35" ;;
    8.4) echo "8.4.27" ;;
    8.5) echo "8.5.12" ;;
    *)   return 1 ;;
  esac
}

versions=("$@")
if [ ${#versions[@]} -eq 0 ]; then
  versions=(8.2 8.4 8.5)
fi

for php in "${versions[@]}"; do
  if ! php_version_for "${php}" >/dev/null; then
    echo "Unsupported PHP version: ${php} (available: 8.2, 8.4, 8.5)" >&2
    exit 1
  fi
done

case "$(uname -m)" in
  arm64|aarch64) native_platform="linux/arm64" ;;
  x86_64|amd64)  native_platform="linux/amd64" ;;
  *)             native_platform="linux/amd64" ;;
esac

if [ "${PUSH}" = "1" ]; then
  output=(--platform "${PLATFORMS}" --push)
else
  output=(--platform "${native_platform}" --load)
fi

for php in "${versions[@]}"; do
  php_version="$(php_version_for "${php}")"
  tags=(
    --tag "${IMAGE}:${VERSION}-php${php}"
    --tag "${IMAGE}:php${php}"
  )
  if [ "${php}" = "8.5" ]; then
    tags+=(--tag "${IMAGE}:latest")
  fi

  echo "==> Building ${IMAGE}:${VERSION}-php${php} (PHP ${php_version}, ${output[*]})"
  docker buildx build \
    "${output[@]}" \
    "${tags[@]}" \
    --build-arg "VER_PHP=${php_version}" \
    --build-arg "VER_DOCKER_IMAGE=${VERSION}-php${php}" \
    --build-arg "DISTRO_VER=${DISTRO_VER}" \
    --build-arg "BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --build-arg "VCS_REF=$(git rev-parse --short HEAD 2>/dev/null || echo unknown)" \
    .
done
