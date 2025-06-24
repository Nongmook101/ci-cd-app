pipeline {
    agent any

    environment {
        IMAGE_NAME = "siriwan101/springboot-ci-cd-demo"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/siriwan101/springboot-ci-cd-demo.git'
            }
        }

        stage('Build & Unit Test') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Quality Scan - SonarQube') {
            environment {
                SONAR_SCANNER_HOME = tool 'SonarScanner'
            }
            steps {
                withSonarQubeEnv('MySonarServer') {
                    sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    """
                }
            }
        }

        // Optional
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploy to Kubernetes cluster here (e.g., kubectl apply -f k8s.yaml)'
            }
        }
    }
}
