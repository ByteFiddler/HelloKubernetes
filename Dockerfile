ARG DIR=/app
ARG DEPENDENCY=build/dependency

FROM gradle AS builder
ARG DIR
ARG DEPENDENCY
COPY build.gradle $DIR/
COPY src $DIR/src
# see https://spring.io/guides/gs/spring-boot-docker/#_containerize_it
# - gradle build
# - unpack the Spring Boot fat jar file
RUN cd $DIR && \
	gradle build && \
	mkdir -p build/dependency && \
	cd build/dependency && \
	jar -xf ../libs/*.jar

FROM openjdk:8-jdk-alpine
ARG DIR
ARG DEPENDENCY
# install curl for tests & add spring user
RUN apk --no-cache add curl && \
	addgroup -S spring && adduser -S spring -G spring
USER spring:spring
# BOOT-INF/lib with the dependency jars in it, and BOOT-INF/classes with the application classes
COPY --from=builder $DIR/${DEPENDENCY}/BOOT-INF/lib $DIR/lib
COPY --from=builder $DIR/${DEPENDENCY}/META-INF $DIR/META-INF
COPY --from=builder $DIR/${DEPENDENCY}/BOOT-INF/classes $DIR
# add test script
COPY scripts/docker/run_tests.sh /
ENTRYPOINT ["java","-cp","app:app/lib/*","com.bytefiddler.demo.DemoApplication"]
