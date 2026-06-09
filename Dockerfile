# Static API documentation site (Scalar) — portable: runs identically on
# OVH docker-compose and GCP Cloud Run. Listens on :8080.
FROM nginx:1.27-alpine

# Drop the default server config; use ours.
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Site assets.
COPY index.html       /usr/share/nginx/html/index.html
COPY openapi.yaml      /usr/share/nginx/html/openapi.yaml
COPY img               /usr/share/nginx/html/img

# --- Optional: fully self-host the Scalar bundle (no jsDelivr at runtime) ---
# Uncomment, and change index.html's <script src> to "./scalar.standalone.js".
# ADD https://cdn.jsdelivr.net/npm/@scalar/api-reference /usr/share/nginx/html/scalar.standalone.js

EXPOSE 8080

# nginx:alpine already runs as a non-privileged-friendly image; pid/logs go to /tmp + stdio.
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
