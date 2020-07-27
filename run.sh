#!/usr/bin/env bash
set -e
sh build.sh
docker run -p 8080:8080 vui
