#!/usr/bin/env bash
docker build -t intermodal/sync:0.1 .
dockr run -d --name=intermodal_sync_build_tmp intermodal/sync:0.1
docker