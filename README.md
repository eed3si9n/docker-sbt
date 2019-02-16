sbt Docker image
================

This is for running sbt in Docker.

### base Docker image

- [adoptopenjdk/openjdk8](https://hub.docker.com/r/adoptopenjdk/openjdk8)
- [adoptopenjdk/openjdk11](https://hub.docker.com/r/adoptopenjdk/openjdk11)

I am using the alpine variants of the AdoptOpenJDK OpenJDK images.

## usage

For AdoptOpenJDK JDK 8

```
docker pull eed3si9n/sbt
docker run -it --mount src="$(pwd)",target=/opt/workspace,type=bind eed3si9n/sbt
```

For AdoptOpenJDK JDK 11

```
docker pull eed3si9n/sbt:jdk11-alpine
docker run -it --mount src="$(pwd)",target=/opt/workspace,type=bind eed3si9n/sbt:jdk11-alpine
```
