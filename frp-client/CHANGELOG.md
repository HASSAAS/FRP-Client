# Changelog

## 2.1.1

- Read app settings directly from `/data/options.json` instead of requiring
  access to the Supervisor API.
- Fix `403 Forbidden` configuration errors on startup.
- Use HTTP-compatible defaults when upgrading an existing installation that
  does not yet contain the options introduced in 2.1.0.
- Keep clear validation errors for missing required settings and HTTPS files.

## 2.1.0

- Add selectable `http` and `https` proxy modes.
- Add FRP `https2http` support for exposing local Home Assistant HTTP over HTTPS.
- Mount Home Assistant's `/ssl` directory read-only for certificate access.
- Add configurable local address, local port, certificate, private key, and host header values.
- Validate that HTTPS certificate and private key files exist before starting FRP.
- Update the repository links and FRP client/server examples.

## 2.0.0

- Upgrade FRP client from 0.53.0 to 0.71.0.
- Upgrade the Home Assistant base image from Alpine 3.10 to 3.24.
- Migrate away from the removed legacy `build.json` build configuration.
- Verify downloaded FRP release archives with pinned SHA-256 checksums.
- Stop printing authentication credentials in app logs.
- Explicitly enable TLS for the FRP client transport.
- Run `frpc` in the foreground and send FRP logs to the Home Assistant log.
- Update the bundled `frps.toml` example for the FRP 0.71 configuration schema.
- Require users to set server, token, dashboard password, and domain values.
- Support the current Home Assistant architectures: amd64 and aarch64.

This is a breaking release because current Home Assistant base images no longer
support armhf, armv7, or i386.
