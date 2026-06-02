## Proxy

Proxy settings are read from `/etc/proxy` (KEY=VALUE format). The nix daemon receives it via `EnvironmentFile=-/etc/proxy`, and zsh sources the same file at shell init. If `/etc/proxy` does not exist, proxy is not configured.

Example `/etc/proxy`:

```sh
http_proxy=http://<gateway>:<port>
https_proxy=http://<gateway>:<port>
no_proxy=localhost,127.0.0.1,<internal-domain>
```
