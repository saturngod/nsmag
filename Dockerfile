# ---------- Build stage ----------
FROM node:20-alpine AS build

WORKDIR /app

# Copy the static site into a `dist/` folder
COPY . ./dist

# (Optional) If you ever add a build step, run it here, e.g.:
# RUN npm ci && npm run build

# ---------- Runtime stage ----------
FROM nginx:1.27-alpine

# Clean default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy static site from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Replace default nginx config (the one shipped in the image is /etc/nginx/nginx.conf)
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
