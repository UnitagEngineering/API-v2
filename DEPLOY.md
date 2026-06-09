# Serving the API docs

The public API reference is **spec-first**: [`openapi.yaml`](./openapi.yaml) is the single
source of truth, rendered by [Scalar](https://github.com/scalar/scalar) via
[`index.html`](./index.html). Everything is static — one HTML page, one YAML spec, and the
`img/` assets — so it can be served by any web server or CDN.

## What's in the repo
| File | Purpose |
| --- | --- |
| `openapi.yaml` | OpenAPI 3.1 spec — the source of truth (lint with `npx @redocly/cli lint openapi.yaml`). |
| `index.html` | Scalar reference page; loads `./openapi.yaml`. |
| `nginx.conf` / `Dockerfile` | Portable static container, listens on **:8080**. |
| `img/` | Eye/module preview images referenced by the spec descriptions. |

## Local preview
```bash
# Quick (no Docker) — any static server:
python3 -m http.server 8089        # → http://127.0.0.1:8089

# Production-equivalent (Docker):
docker build -t unitag-apidocs .
docker run --rm -p 8080:8080 unitag-apidocs   # → http://127.0.0.1:8080
```

## Hosting
The container is a plain static site listening on `:8080` with a `/healthz` endpoint, so it
runs behind any HTTPS ingress / load balancer / CDN. Point your docs hostname at it and
terminate TLS at the edge. Deployment manifests and CI for our own hosted instance live in
our internal infrastructure config (not in this public repo).

## CI: keep the docs honest
Add a lint gate so a malformed spec can't merge:
```yaml
# .github/workflows/lint-openapi.yml (sketch)
- run: npx @redocly/cli@latest lint openapi.yaml
```

## Pinning / fully self-hosting the renderer
`index.html` loads the Scalar bundle from jsDelivr by default. For production:
- **Pin a version** (avoid surprise breakage): change the script src to
  `https://cdn.jsdelivr.net/npm/@scalar/api-reference@<version>`.
- **Vendor it** (zero external runtime dependency): uncomment the `ADD` line in the
  `Dockerfile` and point `index.html`'s `<script src>` at `./scalar.standalone.js`.

## Keeping the spec in sync
The legacy hand-written `README.md` stays as a human-readable mirror, but **`openapi.yaml`
is now the source of truth** — update it when endpoints change, and the rendered site +
any generated SDKs/Postman collection follow automatically
(`npx @redocly/cli bundle` / `openapi-generator` / `npx @scalar/cli`).
