# Stage 1: Build stage using Tomcat base to easily compile java files using servlet-api
FROM tomcat:9.0-jdk17 AS builder

WORKDIR /build

# Copy the entire workspace into /build
COPY . .

# Create the classes directory inside WEB-INF
RUN mkdir -p src/main/webapp/WEB-INF/classes

# Compile all Java files and copy resource files to WEB-INF/classes
RUN find src/main/java -name "*.java" > sources.txt && \
    javac -cp "/usr/local/tomcat/lib/*:src/main/webapp/WEB-INF/lib/*" -d src/main/webapp/WEB-INF/classes @sources.txt && \
    (cd src/main/java && find . -type f -not -name "*.java" -exec sh -c 'for f; do mkdir -p "../webapp/WEB-INF/classes/$(dirname "$f")" && cp "$f" "../webapp/WEB-INF/classes/$f"; done' _ {} +)

# Package the webapp directory into a ROOT.war file
RUN jar -cvf ROOT.war -C src/main/webapp .

# Stage 2: Production stage
FROM tomcat:9.0-jdk17

# Maintainer info
LABEL maintainer="testbotpranav@gmail.com"

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated WAR file from builder
COPY --from=builder /build/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
