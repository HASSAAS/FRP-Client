# FRP Client

Expose a local Home Assistant instance through an FRP server using HTTP or
HTTPS virtual-host forwarding.

- HTTP mode forwards requests directly to Home Assistant.
- HTTPS mode uses FRP's `https2http` plugin and certificates from Home
  Assistant's `/ssl` directory.
- The FRP client-to-server connection uses TLS.

See the Documentation tab after installation for configuration examples.
