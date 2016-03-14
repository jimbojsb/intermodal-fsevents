#!/usr/bin/env bash
apk add --update alpine-sdk inotify-tools-dev
apk add ocaml --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
curl -O http://www.seas.upenn.edu/~bcpierce/unison//download/releases/unison-2.48.3/unison-2.48.3.tar.gz
tar xzf unison-2.48.3.tar.gz
cd unison-2.48.3
make GLIBC_SUPPORT_INOTIFY=true UISTYLE=text INSTALLDIR=/usr/bin NATIVE=true STATIC=true install
apk del ocaml inotify-tools-dev alpine-sdk
rm -rf /unison-2.48.3.tar.gz /unison-2.48.3 /var/cache/apk/*
