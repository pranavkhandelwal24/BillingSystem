# Use official Tomcat base image
FROM tomcat:9.0-jdk17

# Maintainer info (optional)
LABEL maintainer="testbotpranav@gmail.com"

# Remove default webapps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into the webapps directory
# Make sure you have Tally_Syatem.war built before this step
COPY Tally_Syatem.war /usr/local/tomcat/webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
