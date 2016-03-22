FROM alpine:3.3
RUN apk add --update bash rsync inotify-tools go
ADD rsyncd.conf /etc/rsyncd.conf
ADD . /src/inotifystream
ADD inotifystream.sh /usr/bin
ADD rsyncd.sh /usr/bin
RUN cd /src/inotifystream && GOPATH=/src/inotifystream go build src/inotifystream.go
RUN cp /src/inotifystream/inotifystream /usr/bin