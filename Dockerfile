# ---------- Build stage ----------
FROM node:20-alpine AS build
WORKDIR /app
COPY . .
# If you have a build step:
# RUN npm ci && npm run build

# ---------- Runtime stage ----------
FROM nginx:1.27-alpine
RUN rm -rf /usr/share/nginx/html/*

# If your output is in a dist/ folder after build:
COPY --from=build /app/dist /usr/share/nginx/html

# If your static files are just at the project root (no build step):
# COPY --from=build /app /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1
CMD ["nginx", "-g", "daemon off;"]