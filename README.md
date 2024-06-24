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
```

Running locally
---------------
You can run example locally with Docker

```
# Run
docker run --rm -p 3030:80 -v ./examples/videos:/opt/static/videos -v ./examples/nginx.conf:/usr/local/nginx/conf/nginx.conf 1movmedia/nginx-vod-module:custom
```

After running this command, you should be able to play the following URLs:

- HLS: http://localhost:3030/hls/devito,360p.mp4,480p.mp4,720p.mp4,.en_US.vtt,.urlset/master.m3u8
- Dash: http://localhost:3030/dash/devito,360p.mp4,480p.mp4,720p.mp4,.en_US.vtt,.urlset/manifest.mpd
- Thumbnail: http://localhost:3030/thumb/devito360p.mp4/thumb-1000.jpg
