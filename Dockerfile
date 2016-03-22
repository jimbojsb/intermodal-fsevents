FROM alpine:3.3
ADD rsyncd.conf /etc/rsyncd.conf
ADD . /src/inotifystream
ADD inotifystream.sh /usr/bin
ADD rsyncd.sh /usr/bin
RUN apk add --update bash rsync inotify-tools go \
    && cd /src/inotifystream && GOPATH=/src/inotifystream go build src/inotifystream.go \
    && cp /src/inotifystream/inotifystream /usr/bin \
    && apk del go