FROM alpine:3.3

#unison build
ENV UNISON_VERSION=2.48.3
RUN apk add --update alpine-sdk inotify-tools-dev && \
  apk add ocaml --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
  curl -O http://www.seas.upenn.edu/~bcpierce/unison//download/releases/unison-$UNISON_VERSION/unison-$UNISON_VERSION.tar.gz && \
  tar xzf unison-$UNISON_VERSION.tar.gz && \
  cd unison-$UNISON_VERSION && \
  make GLIBC_SUPPORT_INOTIFY=true UISTYLE=text INSTALLDIR=/bin NATIVE=true STATIC=true install && \
  apk del ocaml inotify-tools-dev alpine-sdk && \
  rm -rf /unison-$UNISON_VERSION.tar.gz /unison-$UNISON_VERSION /binunison* /var/cache/apk/*

#inotifystream build
ADD ./inotifystream /src/inotifystream
RUN apk add --update inotify-tools go && \
    cd /src/inotifystream && GOPATH=/src/inotifystream go build src/inotifystream.go && \
    cp /src/inotifystream/inotifystream /usr/bin && \
    apk del go && \
    rm -rf /var/cache/apk/*

# Startup Scripts & Misc
RUN apk add --update bash && rm -rf /var/cache/apk
ADD unison.sh /usr/bin
ADD inotifystream.sh /usr/bin