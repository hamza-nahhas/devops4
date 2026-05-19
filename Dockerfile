# Use an official OpenJDK runtime as a parent image
FROM eclipse-temurin:25-jdk-jammy

# # Set the working directory
# WORKDIR /app

# Copy the fat jar into the container
COPY build/libs/*.jar devops4.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java","-jar","devops4.jar"]
