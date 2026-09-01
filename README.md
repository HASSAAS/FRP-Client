[![Version](https://img.shields.io/badge/version-v2.1.1-blue.svg)](https://github.com/HASSAAS/FRP-Client/tree/v2.1.1)
[![FRP](https://img.shields.io/badge/FRP-v0.71.0-orange.svg)](https://github.com/fatedier/frp/releases/tag/v0.71.0)

# Hass Addon FRP Client
Home Assistant Community Add-on: FRP Client

You can use this add-on to expose Home Assistant through an FRP server with
either HTTP or HTTPS. HTTPS mode terminates TLS in the FRP client and forwards
requests to the local Home Assistant HTTP service.

## Bundled dependencies

- FRP client: `0.71.0`
- Home Assistant base image: `3.24` (Alpine Linux)
- Supported architectures: `amd64`, `aarch64`

FRP recommends upgrading `frps` before `frpc` in mixed-version deployments.
For this app release, upgrade the server to FRP `0.71.0` as well whenever
possible. Servers older than FRP `0.63.0` are outside the compatibility window
guaranteed for FRP `0.71.x`.

## Architecture
<img width="800" src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/58b8770e-dca5-4353-af27-e45494f78278">

## Installation
- Go to Settings -> Add-ons -> Add-on Store (bottom right)
- Click Repositories (top right)
<img width="600" src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/699fac45-2b53-4213-811e-5fd0c4362b3b">

- Add the current repository `https://github.com/HASSAAS/FRP-Client`
<img width="600" src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/91e886d5-dc3b-40a3-951a-9295687cf3f7">

- Wait and refresh the Add-on Store page, then you can see one new add-on `Frp Client`, click it and install
<img width="600" src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/0bad82a7-f535-46b1-acf6-1a4151fb6420">
<br />
<img width="600" src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/c0941c9e-6fff-40ad-8d7b-f89d4b937f92">
<br />
<img width="600" src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/bee156da-282a-4831-9803-8e45f4331c2c">

- Add the configuration shown below to `configuration.yaml` with the File Editor app
```
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
```

This app connects to Home Assistant through the host loopback interface, so
only `127.0.0.1` needs to be trusted. Do not use `0.0.0.0/0`, because that
would trust forwarded headers from every address.

<img width="600"  src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/47c4e863-1481-486a-9acb-41019c388fde">
<br />

## Client configuration

The Home Assistant app configuration supports the following values:

```yaml
serverAddr: "frps.example.com"
serverPort: 7000
authToken: "replace-with-a-strong-token"
webServerPort: 7500
webServerUser: "admin"
webServerPassword: "replace-with-a-strong-password"
customDomain: "ha.example.com"
proxyName: "homeassistant"
proxyType: "http"
localIP: "127.0.0.1"
localPort: 8123
certificateFile: "/ssl/fullchain.pem"
privateKeyFile: "/ssl/privkey.pem"
hostHeaderRewrite: "127.0.0.1"
```

Use `proxyType: "http"` for normal FRP HTTP virtual-host forwarding. The
certificate options are ignored in HTTP mode.

## HTTPS mode

HTTPS mode uses FRP's `https2http` plugin. It accepts HTTPS for
`customDomain`, terminates TLS with the configured certificate, and forwards
plain HTTP to `localIP:localPort`.

1. Point the DNS record for `customDomain` to the public FRP server.
2. Configure the FRP server and open TCP port 443:

   ```toml
   bindPort = 7000
   vhostHTTPPort = 8123
   vhostHTTPSPort = 443
   ```

3. Put a certificate that covers `customDomain` in Home Assistant's `/ssl`
   directory. The usual paths are `/ssl/fullchain.pem` and
   `/ssl/privkey.pem`.
4. Change the app configuration to `proxyType: "https"`, verify the
   certificate paths, save, and restart the app.
5. Open `https://ha.example.com`.

The existing `transport.tls.enable = true` setting encrypts the connection
between `frpc` and `frps`; HTTPS mode additionally encrypts the browser-facing
connection.

_Notes for Chinese Users: If the above steps fail, please try again as GitHub resource access may be unstable. If the issue persists, you can check the specific logs for troubleshooting by using the command `ha su logs`._

## Usage Tutorial
<a href="https://www.youtube.com/watch?v=1UTcnqsiDg8">
  <img width="800" src="https://github.com/huxiaoxu2019/hass-addon-frp-client/assets/5491423/d1f0820b-d0c4-450b-b476-cdae386b7e5d">
</a>

## Contribution
Welcome and appreciate contributions from the Home Assistant community. If you have ideas for improvements, bug fixes, or new features, feel free to contribute by submitting a pull request (PR). Before you start, please make sure to follow these guidelines:

### Bug Reports
If you encounter any bugs or have ideas for new features, please open an issue on the issue tracker.

### Pull Request
- Clearly describe the purpose of your changes in the pull request
- Provide step-by-step instructions for testing your changes
- Ensure that your changes do not introduce new issues

### Code of Conduct
Please note that this project follows [Home Assistant's Code of Conduct](https://www.home-assistant.io/code_of_conduct/). Be respectful and considerate in all interactions.

## Author
Original author: Xiaoxu Hu admin@ihuxu.com

Repository maintainer: HASSAAS 17paixie@gmail.com

Special thanks to: [@steplov](https://github.com/steplov) for the setup script
