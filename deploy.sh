#!/bin/sh

cd /ws2/idserver.ui
mvn clean
mvn install

cd /pipeline/vfb-curation-ui-docker/
sh copy_new_version.sh 
make docker-publish

cd /pipeline/vfb-curation-api 
make docker-publish


