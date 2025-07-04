pipeline {
    agent any

    tools {
        jdk 'JDK-17'
        maven 'Maven'
    }

    environment {
        DOCKER_IMAGE = "siriwan101/springboot-ci-demo"
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
//         IMAGE_TAG = "v2"
//         DOCKER_IMAGE = "siriwan101/springboot-ci-demo:${IMAGE_TAG}"
    }


    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Nongmook101/ci-cd-app'
            }
        }


        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

//         stage('SonarQube Scan') {
//             environment {
//                 SONAR_SCANNER_HOME = tool 'SonarQubeScanner'
//             }
//             steps {
//                 withSonarQubeEnv('MySonarQubeServer') {
//                     sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner"
//                 }
//             }
//         }

        stage('Dependency Check') {
            steps {
                sh 'mvn org.owasp:dependency-check-maven:check'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        docker build -t $DOCKER_IMAGE .
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }
         stage('Install Helm') {
             steps {
                 sh '''
                 curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
                 '''
             }
         }

         stage('Helm Deploy') {
             steps {
                 withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG'),
                                  usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                     sh '''
                     wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
                     chmod +x /usr/local/bin/yq

                     yq eval '.image.tag = "${IMAGE_TAG}"' -i helm/values.yaml

                     git config user.email "jenkins@ci.com"
                     git config user.name "jenkins-bot"

                     git add helm/values.yaml
                     git commit -m "Jenkins updated tag to ${IMAGE_TAG}" || echo "No changes to commit"
                     git push https://${GIT_USER}:${GIT_PASS}@github.com/Nongmook101/ci-cd-app.git
                     '''
                 }
             }
         }


//          stage('Helm Deploy') {
//                       steps {
//                           withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
//                               sh '''
//                               helm upgrade --install springboot-ci-demo ./helm \
//                                  --set image.repository=$DOCKER_IMAGE \
//                                  --set image.tag=latest
//                                  --set image.repository=siriwan101/springboot-ci-demo \
//                                  --set image.tag=$IMAGE_TAG
//                               '''
//                           }
//                       }
//                   }

//          stage('Update Helm values.yaml and Commit') {
//              steps {
//                  withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
//                      sh '''
//                          git config --global user.email "ci@example.com"
//                          git config --global user.name "jenkins-bot"
//
//                          git clone https://$GIT_USER:$GIT_PASS@github.com/Nongmook101/ci-cd-app.git
//                          cd ci-cd-app
//
//                          sed -i 's/tag: .*/tag: v2/' helm/values.yaml
//
//                          git add helm/values.yaml
//                          git commit -m "Jenkins updated tag to v2"
//                          git push
//                      '''
//                  }
//              }
//          }


//         stage('Install kubectl') {
//             steps {
//                 sh '''
//                 curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
//                 chmod +x kubectl
//                 mv kubectl /usr/local/bin/
//                 '''
//             }
//         }
//
//         stage('Deploy to Kubernetes') {
//             steps {
//                 withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
//                     sh 'kubectl apply -f k8s/'
//                 }
//             }
//         }
//
//   }
// }
