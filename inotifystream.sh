#!/bin/bash
sysctl -w fs.inotify.max_user_watches=200000
/usr/bin/inotifystream