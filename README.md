# DevOps CI/CD Pipeline Project

## Overview

This project demonstrates a complete CI/CD pipeline using:

- Spring Boot
- Gradle
- Docker
- DockerHub
- Jenkins
- Kubernetes
- Minikube
- GitHub Webhooks

The application is a simple Spring Boot REST API deployed to a local Kubernetes cluster using Minikube. Jenkins automates the build, Docker image creation, image push, and Kubernetes deployment process.

---

# Architecture

```text
Developer
   ↓
GitHub Repository
   ↓
GitHub Webhook Trigger
   ↓
Jenkins CI/CD Pipeline
   ↓
Build Spring Boot JAR
   ↓
Build Docker Image
   ↓
Push Image to DockerHub
   ↓
Deploy to Kubernetes (Minikube)
   ↓
Application Running on K8s Pods
```

---

# Technologies Used

| Technology | Purpose |
|---|---|
| Java 17 | Backend development |
| Spring Boot | Web application |
| Gradle | Build tool |
| Docker | Containerization |
| DockerHub | Container registry |
| Jenkins | CI/CD automation |
| Kubernetes | Container orchestration |
| Minikube | Local Kubernetes cluster |
| GitHub | Source code management |

---

# Project Structure

```text
devops4/
│
├── src/
├── build.gradle
├── settings.gradle
├── Dockerfile
├── Jenkinsfile
├── gradlew
├── gradlew.bat
├── gradle/
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
└── README.md
```

---

# Application Endpoint

| Method | Endpoint | Description |
|---|---|---|
| GET | / | Returns hello message |

Example response:

```text
Hello from Kubernetes!
```

---

# Prerequisites

Install the following tools before running the project:

- Docker Desktop
- Java 17
- Gradle
- Minikube
- kubectl
- Jenkins

---

# Running Minikube

Start Minikube:

```bash
minikube start
```

Verify cluster:

```bash
kubectl get nodes
```

---

# Building the Application

Build the Spring Boot application:

```bash
./gradlew build
```

Generated JAR file:

```text
build/libs/
```

---

# Docker Configuration

## Dockerfile

```dockerfile
FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY build/libs/*.jar devops4.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "devops4.jar"]
```

---

# Build Docker Image

```bash
docker build -t YOUR_DOCKERHUB_USERNAME/devops4:latest .
```

---

# Push Image to DockerHub

Login:

```bash
docker login
```

Push image:

```bash
docker push YOUR_DOCKERHUB_USERNAME/devops4:latest
```

---

# Kubernetes Deployment

## deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: devops4

spec:
  replicas: 1

  selector:
    matchLabels:
      app: devops4

  template:
    metadata:
      labels:
        app: devops4

    spec:
      containers:
      - name: devops4
        image: YOUR_DOCKERHUB_USERNAME/devops4:latest

        ports:
        - containerPort: 8080
```

---

## service.yaml

```yaml
apiVersion: v1
kind: Service

metadata:
  name: devops4-service

spec:
  type: NodePort

  selector:
    app: devops4

  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30007
```

---

# Deploy to Kubernetes

Apply deployment:

```bash
kubectl apply -f k8s/deployment.yaml
```

Apply service:

```bash
kubectl apply -f k8s/service.yaml
```

Verify pods:

```bash
kubectl get pods
```

Verify services:

```bash
kubectl get svc
```

Open application:

```bash
minikube service devops4-service
```

---

# Jenkins CI/CD Pipeline

The Jenkins pipeline performs the following stages:

1. Clone project from GitHub
2. Build Spring Boot application
3. Build Docker image
4. Login to DockerHub
5. Push image to DockerHub
6. Deploy application to Kubernetes

---

# Jenkinsfile

```groovy
pipeline {

    agent any

    environment {
        IMAGE_NAME = "spring-devops4"
    }

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/hamza-nahhas/devops4'
            }
        }

        stage('Build Jar') {
            steps {
                sh 'chmod +x gradlew'
                sh './gradlew build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}
```

---

# GitHub Webhook

GitHub webhook automatically triggers Jenkins pipeline on:
- push
- merge

Webhook URL:

```text
http://YOUR_LOCAL_IP:9090/github-webhook/
```

---

# Scaling the Application

Scale deployment to 2 pods:

```bash
kubectl scale deployment devops4 --replicas=2
```

Verify:

```bash
kubectl get pods
```

Expected result:

```text
2 Running pods
```

---

# Useful Commands

## View pods

```bash
kubectl get pods
```

## View services

```bash
kubectl get svc
```

## View deployments

```bash
kubectl get deployments
```

## View Jenkins logs

```bash
docker logs -f jenkins
```

## Stop Jenkins

```bash
docker stop jenkins
```

## Start Jenkins

```bash
docker start jenkins
```

---

# CI/CD Pipeline Flow

```text
GitHub Push
    ↓
Jenkins Trigger
    ↓
Gradle Build
    ↓
Docker Build
    ↓
DockerHub Push
    ↓
Kubernetes Deployment
    ↓
Application Available on Minikube
```

---

# Expected Output

- Jenkins pipeline runs successfully
- Docker image pushed to DockerHub
- Kubernetes deployment created
- Application accessible through Minikube service
- Application scales successfully to 2 pods

---

# Author

Hamza Nahhas