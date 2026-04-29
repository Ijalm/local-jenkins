pipeline {
    agent any

    environment {
        IMAGE_NAME     = 'grocery-webapp'
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
        FULL_IMAGE     = "${IMAGE_NAME}:${IMAGE_TAG}"
        CONTAINER_NAME = 'grocery-webapp-container'
        APP_PORT       = '8000'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${FULL_IMAGE}"
                sh "docker build -t ${FULL_IMAGE} ."
            }
        }

        stage('Deploy Locally') {
            steps {
                echo 'Deploying container locally...'
                sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm   ${CONTAINER_NAME} || true

                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${APP_PORT}:8000 \
                        --restart unless-stopped \
                        ${FULL_IMAGE}
                """
            }
        }
    }

    post {
        success {
            echo "Deployment successful! App running at http://localhost:${APP_PORT}"
        }
        failure {
            echo 'Pipeline failed. Check the logs above.'
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}
