FROM alpine:3.3
EXPOSE 2873
RUN apk add --update bash rsync lsyncd
ADD rsyncd.conf /etc/rsyncd.conf
ADD sync.sh /usr/bin
ADD syncback.sh /usr/bin
WORKDIR /sync