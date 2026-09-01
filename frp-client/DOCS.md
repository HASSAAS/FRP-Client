# FRP Client 配置说明

本插件把本机 Home Assistant 的 `127.0.0.1:8123` 通过 FRP 服务器发布到
公网，支持 HTTP 和 HTTPS 两种模式。

## Home Assistant 设置

在 Home Assistant 的 `configuration.yaml` 中加入：

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
```

保存后重启 Home Assistant。

## HTTP 配置

```yaml
serverAddr: "frps.example.com"
serverPort: 7000
authToken: "替换成服务端使用的强密码"
webServerPort: 7500
webServerUser: "admin"
webServerPassword: "替换成管理页面强密码"
customDomain: "ha.example.com"
proxyName: "homeassistant"
proxyType: "http"
localIP: "127.0.0.1"
localPort: 8123
certificateFile: "/ssl/fullchain.pem"
privateKeyFile: "/ssl/privkey.pem"
hostHeaderRewrite: "127.0.0.1"
```

HTTP 模式不会读取证书选项。FRP 服务端至少需要：

```toml
bindPort = 7000
vhostHTTPPort = 8123
```

访问地址示例：`http://ha.example.com:8123`。

## HTTPS 配置

HTTPS 模式使用 FRP 的 `https2http` 插件：外部浏览器使用 HTTPS，插件
解密后把 HTTP 请求转发到本地 Home Assistant。

FRP 服务端配置：

```toml
bindPort = 7000
vhostHTTPSPort = 443
```

请确保服务器防火墙和云安全组允许 TCP 443，并将 `customDomain` 的 DNS
记录解析到 FRP 服务器。

把域名证书放入 Home Assistant 的 `/ssl` 目录，然后把客户端配置中的：

```yaml
proxyType: "https"
certificateFile: "/ssl/fullchain.pem"
privateKeyFile: "/ssl/privkey.pem"
```

保存并重启插件，即可通过 `https://ha.example.com` 访问。

证书必须覆盖 `customDomain`，私钥必须与证书匹配。证书或私钥不存在时，
插件会停止启动并在日志中给出缺失文件路径。

## 配置项

- `serverAddr`：FRP 服务端地址。
- `serverPort`：FRP 服务端绑定端口，默认 `7000`。
- `authToken`：必须与服务端 `auth.token` 一致。
- `webServerPort`：frpc 管理页面端口。
- `webServerUser`、`webServerPassword`：frpc 管理页面账号和密码。
- `customDomain`：访问 Home Assistant 使用的完整域名。
- `proxyName`：FRP 代理名称。
- `proxyType`：`http` 或 `https`。
- `localIP`、`localPort`：本地 Home Assistant 地址和端口。
- `certificateFile`：HTTPS 证书链路径。
- `privateKeyFile`：HTTPS 私钥路径。
- `hostHeaderRewrite`：转发给 Home Assistant 的 Host 请求头。

`transport.tls.enable = true` 只负责加密 frpc 与 frps 之间的连接；
`proxyType: "https"` 才负责浏览器到 FRP 服务端的 HTTPS 访问。
