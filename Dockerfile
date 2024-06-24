FROM alpine:latest AS base_image

FROM base_image AS build

ARG NGINX_VERSION=1.27.0
ARG VOD_MODULE_VERSION=1.33
ARG NGINX_CONFIG=""
ARG NGINX_DEPS=""

RUN apk add --no-cache curl build-base openssl openssl-dev zlib-dev linux-headers pcre-dev ffmpeg ffmpeg-dev ${NGINX_DEPS}

RUN mkdir nginx \
 && curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -C /nginx --strip 1 -xz

RUN mkdir nginx-vod-module-${VOD_MODULE_VERSION} \
 && curl -sL https://github.com/kaltura/nginx-vod-module/archive/refs/tags/${VOD_MODULE_VERSION}.tar.gz | tar -C /nginx-vod-module-${VOD_MODULE_VERSION} --strip 1 -xz

WORKDIR /nginx
RUN ./configure --prefix=/usr/local/nginx \
	--add-module=../nginx-vod-module-${VOD_MODULE_VERSION} \
	--with-http_ssl_module \
	--with-file-aio \
	--with-threads \
	--with-cc-opt="-O3" \
	${NGINX_CONFIG}
RUN make
RUN make install
RUN rm -rf /usr/local/nginx/html /usr/local/nginx/conf/*.default

FROM base_image
RUN apk add --no-cache ca-certificates openssl pcre zlib ffmpeg
COPY --from=build /usr/local/nginx /usr/local/nginx
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]
