#!/usr/bin/env bashio
set -euo pipefail

readonly CONFIG_PATH="/tmp/frpc.toml"

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

[[proxies]]
name = ${proxy_name}
type = "http"
customDomains = [${custom_domain}]
transport.useEncryption = true
transport.useCompression = true
localPort = 8123
localIP = "127.0.0.1"
EOF

chmod 0600 "${CONFIG_PATH}"

bashio::log.info "Starting FRP client $(frpc --version)"
exec frpc -c "${CONFIG_PATH}"
