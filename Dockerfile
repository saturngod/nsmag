# ---------- Build stage ----------
FROM node:20-alpine AS build

WORKDIR /app

# Copy the static site into a `dist/` folder
COPY . ./dist

# (Optional) If you ever add a build step, run it here, e.g.:
# RUN npm ci && npm run build
# For now, `dist/` is just the static files.

# ---------- Runtime stage ----------
FROM nginx:1.27-alpine

# Clean default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy static site from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Basic nginx config tuned for static hosting
RUN printf '%s' \
'worker_processes  auto;\n\
events { worker_connections 1024; }\n\
http {\n\
  include       /etc/nginx/mime.types;\n\
  default_type  application/octet-stream;\n\
  sendfile      on;\n\
  server_tokens off;\n\
  gzip on;\n\
  gzip_types text/plain text/css application/javascript application/json image/svg+xml;\n\
  server {\n\
    listen 80;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location / {\n\
      try_files $uri $uri/ $uri.html /index.html;\n\
    }\n\
    location ~* \.(?:css|js|jpg|jpeg|png|gif|ico|svg|woff2?)$ {\n\
      expires 30d;\n\
      access_log off;\n\
      add_header Cache-Control "public";\n\
    }\n\
  }\n\
}\n' > /etc/nginx/nginx.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
