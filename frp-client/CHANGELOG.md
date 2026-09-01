# Changelog

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
