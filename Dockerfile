FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY inclusive_move/pubspec.yaml inclusive_move/pubspec.lock ./inclusive_move/
WORKDIR /app/inclusive_move
RUN flutter pub get

COPY inclusive_move/ ./
RUN test -d web || flutter create --platforms web .
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /app/inclusive_move/build/web /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD wget --no-verbose --tries=1 --spider http://127.0.0.1/ || exit 1
CMD ["nginx", "-g", "daemon off;"]
