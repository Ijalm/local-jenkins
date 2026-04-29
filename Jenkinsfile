pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'ijalm'
        IMAGE_NAME      = 'grocery-webapp'
        IMAGE_TAG       = "${env.BUILD_NUMBER}"
        FULL_IMAGE      = "${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
        CONTAINER_NAME  = 'grocery-webapp-container'
        APP_PORT        = '8080'
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

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing image to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${FULL_IMAGE}
                        docker logout
                    """
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                echo 'Deploying container...'
                sh """
                    # Stop and remove existing container if running
                    docker stop ${CONTAINER_NAME} || true
                    docker rm   ${CONTAINER_NAME} || true

                    # Run new container
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${APP_PORT}:80 \
                        --restart unless-stopped \
                        ${FULL_IMAGE}
                """
            }
        }
    }

    post {
        success {
            echo "Deployment successful! App running at http://<YOUR_SERVER_IP>:${APP_PORT}"
        }
        failure {
            echo 'Pipeline failed. Check the logs above.'
        }
        always {
            // Clean up dangling images to save disk space
            sh 'docker image prune -f || true'
        }
    }
}
