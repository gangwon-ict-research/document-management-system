# syntax=docker/dockerfile:1.6
#
# OpenKM WAR build (JDK 8 + Maven, includes GWT compile)
#
#   docker build --target artifact --output type=local,dest=./dist .
#     -> ./dist/OpenKM.war
#
# .git is not copied into the build context, so the build number comes from GIT_SHA.

ARG MAVEN_IMAGE=maven:3.8.8-eclipse-temurin-8

FROM ${MAVEN_IMAGE} AS build
WORKDIR /src

ARG GIT_SHA=unknown
ENV MAVEN_OPTS="-Xmx3g"
ENV MVN_ARGS="-B -ntp -Dmaven.test.skip=true -Dmaven.buildNumber.revisionOnScmFailure=${GIT_SHA}"

# Resolve dependencies first so this layer is reused when only sources change
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 \
    mvn ${MVN_ARGS} dependency:go-offline || true

COPY src ./src
RUN --mount=type=cache,target=/root/.m2 \
    mvn ${MVN_ARGS} package \
 && cp target/OpenKM.war /OpenKM.war

# Export stage: only the WAR (used with --output)
FROM scratch AS artifact
COPY --from=build /OpenKM.war /OpenKM.war
