ARG DIR=/app
ARG DEPENDENCY=build/dependency

FROM gradle AS builder
ARG DIR
ARG DEPENDENCY
COPY build.gradle $DIR/
COPY src $DIR/src
RUN cd $DIR && \
	gradle build && \
	mkdir -p build/dependency && \
	cd build/dependency && \
	jar -xf ../libs/*.jar

FROM openjdk:8-jdk-alpine
ARG DIR
ARG DEPENDENCY
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=builder $DIR/${DEPENDENCY}/BOOT-INF/lib $DIR/lib
COPY --from=builder $DIR/${DEPENDENCY}/META-INF $DIR/META-INF
COPY --from=builder $DIR/${DEPENDENCY}/BOOT-INF/classes $DIR
ENTRYPOINT ["java","-cp","app:app/lib/*","com.bytefiddler.demo.DemoApplication"]
