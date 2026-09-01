#!/usr/bin/env bash
set -euo pipefail

readonly BUILD_ARCH="${1:?Build architecture is required}"
readonly FRP_VERSION="${2:?FRP version is required}"
readonly FRP_SHA256_AMD64="${3:?FRP amd64 checksum is required}"
readonly FRP_SHA256_AARCH64="${4:?FRP aarch64 checksum is required}"
readonly INSTALL_DIR="${5:-/usr/local/bin}"
readonly FRP_RELEASE_URL="https://github.com/fatedier/frp/releases/download"

case "${BUILD_ARCH}" in
    amd64)
        machine="amd64"
        expected_sha256="${FRP_SHA256_AMD64}"
        ;;
    aarch64)
        machine="arm64"
        expected_sha256="${FRP_SHA256_AARCH64}"
        ;;
    *)
        printf 'Unsupported Home Assistant architecture: %s\n' "${BUILD_ARCH}" >&2
        exit 1
        ;;
esac

readonly machine
readonly expected_sha256
readonly file_name="frp_${FRP_VERSION}_linux_${machine}.tar.gz"
readonly file_dir="${file_name%.tar.gz}"
readonly file_url="${FRP_RELEASE_URL}/v${FRP_VERSION}/${file_name}"

temp_dir="$(mktemp -d)"
readonly temp_dir
trap 'rm -rf "${temp_dir}"' EXIT

printf 'Downloading frpc %s for %s\n' "${FRP_VERSION}" "${BUILD_ARCH}"
curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --retry 3 \
    --output "${temp_dir}/${file_name}" \
    "${file_url}"

printf '%s  %s\n' \
    "${expected_sha256}" \
    "${temp_dir}/${file_name}" \
    | sha256sum -c -

tar --no-same-owner -xzf "${temp_dir}/${file_name}" -C "${temp_dir}"
mkdir -p "${INSTALL_DIR}"
cp "${temp_dir}/${file_dir}/frpc" "${INSTALL_DIR}/frpc"
chmod 0755 "${INSTALL_DIR}/frpc"

printf 'Installed frpc %s to %s\n' "${FRP_VERSION}" "${INSTALL_DIR}/frpc"
