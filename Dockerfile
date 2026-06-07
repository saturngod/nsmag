# ---------- Build stage ----------
FROM node:20-alpine AS build
WORKDIR /app
COPY . .

# ---------- Runtime stage ----------
FROM nginx:1.27-alpine
RUN rm -rf /usr/share/nginx/html/*

# Copy from project root, not /app/dist
COPY --from=build /app /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]