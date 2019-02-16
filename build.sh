#!/bin/bash

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

eval $(parse_yaml ./data.yml)
set -x
mustache -version
docker version

sbt_version_u="${sbt_version//./_}"

echo sbt $sbt_version_u

mustache data.yml jdk11/alpine/Dockerfile.mustache > jdk11/alpine/Dockerfile
mustache data.yml jdk8/alpine/Dockerfile.mustache > jdk8/alpine/Dockerfile

docker build jdk11/alpine -t sbt:jdk11-alpine -t "sbt:sbt${sbt_version_u}-jdk11-alpine"
docker build jdk8/alpine  -t sbt:jdk8-alpine  -t "sbt:sbt${sbt_version_u}-jdk8-alpine"

docker tag "sbt:sbt${sbt_version_u}-jdk11-alpine" "eed3si9n/sbt:sbt${sbt_version_u}-jdk11-alpine"
docker push                                       "eed3si9n/sbt:sbt${sbt_version_u}-jdk11-alpine"
docker tag "sbt:sbt${sbt_version_u}-jdk11-alpine" "eed3si9n/sbt:jdk11-alpine"
docker push                                       "eed3si9n/sbt:jdk11-alpine"
docker tag "sbt:sbt${sbt_version_u}-jdk8-alpine"  "eed3si9n/sbt:sbt${sbt_version_u}-jdk8-alpine"
docker push                                       "eed3si9n/sbt:sbt${sbt_version_u}-jdk8-alpine"
docker tag "sbt:sbt${sbt_version_u}-jdk8-alpine"  "eed3si9n/sbt:jdk8-alpine"
docker push                                       "eed3si9n/sbt:jdk8-alpine"
docker tag "sbt:sbt${sbt_version_u}-jdk8-alpine"  "eed3si9n/sbt:latest"
docker push                                       "eed3si9n/sbt:latest"
