def img
pipeline {
    environment {
        AWS_ACCOUNT_ID="account id"
        AWS_DEFAULT_REGION="us-east-1" 
        IMAGE_REPO_NAME="demo"
        REGISTRY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    agent any
    
    stages{


         stage('build checkout gitlab'){
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git-cred',url: 'https://gitlab.com/hameed/beta-demo-cicd']])
            }
        }
  
        stage('build docker image'){
            steps{
                script{
                     sh"docker build -t ${REPOSITORY_URI} ."
                     sh"docker tag ${REPOSITORY_URI} ${REPOSITORY_URI}:latest"
                     sh"docker tag ${REPOSITORY_URI} ${REPOSITORY_URI}:${env.BUILD_ID}"
            }
          }
        }
        stage('Login and Push images to ECR'){
	       steps{
		       script{
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'Aws-Cred', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    def ecrAuth = sh(script: "aws ecr get-login-password --region ${AWS_DEFAULT_REGION}", returnStdout: true).trim()
                    sh("docker login -u AWS -p ${ecrAuth} ${REGISTRY_URI}")

                    // Push the Docker image to AWS ECR
                    sh("docker push ${REPOSITORY_URI}:${env.BUILD_ID}")
                    sh("docker push ${REPOSITORY_URI}:latest")
                
                }
            
	    	  }
	        }
          }
           
        

        stage('SSH to Beta'){
            steps{
                script{
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: "demoec2",#name on publish over ssh
                                verbose: true,
                                transfers: [
                                    // sshTransfer(
                                    //     execCommand: 'pwd',
                                    //     execTimeout: 120000,                           
                                    // ),

                                    // sshTransfer(
                                    //     execCommand: 'ls -l',
                                    //     execTimeout: 120000,    
                                    // ),
                                    sshTransfer(
                                        execCommand: "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REGISTRY_URI",
                                        execTimeout: 180000,                          
                                    ),
                                    sshTransfer(
                                        execCommand: 'docker ps',
                                        execTimeout: 120000,                          
                                    ),
                                    sshTransfer(
                                        execCommand: 'docker images',
                                        execTimeout: 120000,
                                    ),
                                    sshTransfer(
                                        execCommand: "docker stop demo",
                                        execTimeout: 120000,
                                    ),
                                    sshTransfer(
                                        execCommand: "docker rm demo",
                                        execTimeout: 180000,
                                    ),
                                    sshTransfer(
                                        execCommand: 'docker rmi -f $(docker images -q)',
                                        execTimeout: 180000,    
                                    ),
                                    sshTransfer(
                                        execCommand: 'docker ps',
                                        execTimeout: 120000,
                                    ),
                                    sshTransfer(
                                        execCommand: "docker pull ${REPOSITORY_URI}:${env.BUILD_ID}",
                                        execTimeout: 120000,                                       
                                    ),
                                    sshTransfer(
                                        execCommand: "docker run -d -p 3000:80 --name=demo ${REPOSITORY_URI}:${env.BUILD_ID}",
                                        execTimeout: 120000,
                                    ),
                                    sshTransfer(
                                        execCommand: 'docker ps',
                                        execTimeout: 120000,
                                    ),
                                    sshTransfer(
                                        execCommand: 'docker images',
                                        execTimeout: 120000,
                                    )
                                    ],
                                    usePromotionTimestamp: false, 
                                    useWorkspaceInPromotion: false, 
                         

                        )
                      ]
                    )
 
                }
            }
        }
        
        stage('Clean resources'){
            steps{
                script{
                      sh "docker images"
                      sh "docker image prune -f"
                      sh 'docker rmi -f $(docker images -q)'
                      sh "docker images ps -a" 
                      sh "docker ps"
                }
            }
        }    
    }
 }
    
