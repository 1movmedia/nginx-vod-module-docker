nginx-vod-module-docker
=======================

This repository contains a Dockerfile for building nginx with [Kaltura's
vod-module](https://github.com/kaltura/nginx-vod-module).

Building locally
----------------

This repository uses Docker's multi-stage builds, therefore building this image
requires Docker 17.05 or higher. Given that you have all the required
dependencies, building the image is as simple as running a ``docker build``:

```
# Default build
docker build -t 1movmedia/nginx-vod-module .

# Build with extra modules
docker build --build-arg NGINX_DEPS_RUNTIME="geoip" --build-arg NGINX_DEPS="geoip-dev" --build-arg NGINX_CONFIG="--with-http_ssl_module --with-file-aio --with-threads --with-cc-opt=-O3 --with-http_v2_module --with-http_v3_module --with-http_realip_module --with-http_geoip_module --with-http_secure_link_module"  -t 1movmedia/nginx-vod-module:custom .

# Run
docker run --rm -p 8765:80 1movmedia/nginx-vod-module:custom
```
