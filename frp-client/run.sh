#!/usr/bin/env bashio
set -euo pipefail

readonly CONFIG_PATH="${FRPC_CONFIG_PATH:-/tmp/frpc.toml}"
readonly FRPC_BIN="${FRPC_BIN:-frpc}"

toml_string() {
    jq --compact-output --null-input --arg value "$1" '$value'
}

server_addr="$(toml_string "$(bashio::config 'serverAddr')")"
server_port="$(bashio::config 'serverPort')"
auth_token="$(toml_string "$(bashio::config 'authToken')")"
web_server_port="$(bashio::config 'webServerPort')"
web_server_user="$(toml_string "$(bashio::config 'webServerUser')")"
web_server_password="$(toml_string "$(bashio::config 'webServerPassword')")"
custom_domain="$(toml_string "$(bashio::config 'customDomain')")"
proxy_name="$(toml_string "$(bashio::config 'proxyName')")"
proxy_type="$(bashio::config 'proxyType')"
local_ip="$(bashio::config 'localIP')"
local_port="$(bashio::config 'localPort')"
certificate_file="$(bashio::config 'certificateFile')"
private_key_file="$(bashio::config 'privateKeyFile')"
host_header_rewrite="$(bashio::config 'hostHeaderRewrite')"

cat > "${CONFIG_PATH}" <<EOF
serverAddr = ${server_addr}
serverPort = ${server_port}
auth.method = "token"
auth.token = ${auth_token}

# Keep wire protocol v1 for compatibility with existing FRP servers.
transport.wireProtocol = "v1"
transport.tls.enable = true

log.to = "console"
log.level = "info"
log.maxDays = 3

webServer.addr = "0.0.0.0"
webServer.port = ${web_server_port}
webServer.user = ${web_server_user}
webServer.password = ${web_server_password}

EOF

case "${proxy_type}" in
    http)
        local_ip_toml="$(toml_string "${local_ip}")"
        cat >> "${CONFIG_PATH}" <<EOF
[[proxies]]
name = ${proxy_name}
type = "http"
customDomains = [${custom_domain}]
transport.useEncryption = true
transport.useCompression = true
localIP = ${local_ip_toml}
localPort = ${local_port}
EOF
        ;;
    https)
        if [[ ! -s "${certificate_file}" ]]; then
            bashio::log.fatal "HTTPS certificate file is missing or empty: ${certificate_file}"
            exit 1
        fi

        if [[ ! -s "${private_key_file}" ]]; then
            bashio::log.fatal "HTTPS private key file is missing or empty: ${private_key_file}"
            exit 1
        fi

        local_addr="$(toml_string "${local_ip}:${local_port}")"
        certificate_file_toml="$(toml_string "${certificate_file}")"
        private_key_file_toml="$(toml_string "${private_key_file}")"
        host_header_rewrite_toml="$(toml_string "${host_header_rewrite}")"

        cat >> "${CONFIG_PATH}" <<EOF
[[proxies]]
name = ${proxy_name}
type = "https"
customDomains = [${custom_domain}]
transport.useEncryption = true
transport.useCompression = true

[proxies.plugin]
type = "https2http"
localAddr = ${local_addr}
crtPath = ${certificate_file_toml}
keyPath = ${private_key_file_toml}
hostHeaderRewrite = ${host_header_rewrite_toml}
requestHeaders.set.x-forwarded-proto = "https"
EOF
        ;;
    *)
        bashio::log.fatal "Unsupported proxyType: ${proxy_type}. Use http or https."
        exit 1
        ;;
esac

chmod 0600 "${CONFIG_PATH}"

bashio::log.info "Starting FRP client $("${FRPC_BIN}" --version) with ${proxy_type^^} proxy"
exec "${FRPC_BIN}" -c "${CONFIG_PATH}"
