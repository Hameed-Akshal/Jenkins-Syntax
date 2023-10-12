def img
pipeline {
    environment {
        registry = "Repo Name"
        docker_CREDENTIALS= 'Access of Docker'
        registryUrl = 'Docker Repo URL'
        repoReg = 'Registry Name'
        dockerImage = ''
        dusername = 'docker username '
        dpassword = 'docker password'
        
        
      
    }
    agent any
    
    stages{


         stage('build checkout git'){
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Git cred in jenkins',url: 'Git Repo Url']])
            }
        }
  
        stage('build image'){
            steps{
                script{
                     img = registry + ":${env.BUILD_ID}"
                     println ("${img}")
                     dockerImage = docker.build img
            }
          }
        }
        
        stage('Login and Push image to ACR'){
	       steps{
		       script{
		         docker.withRegistry(registryUrl,ACR_CREDENTIALS) {
             dockerImage.push()
              }
            
	    	  }
	      }
	    }

        stage('SSH'){
            steps{
                script{
                  
                     sshPublisher(
                      publishers: [
                       sshPublisherDesc(
                         configName: 'SSH server name on manage Jenkins',
                         verbose: true,
                         transfers: [
                           sshTransfer(
                            execCommand: 'pwd',
                            execTimeout: 120000,
                            
                          ),
                          sshTransfer(
                            execCommand: 'ls -l',
                            execTimeout: 120000,
                            
                          ),
                          sshTransfer(
                            execCommand: 'docker stop test',
                            execTimeout: 180000,
                            
                          ),
                          sshTransfer(
                            execCommand: 'docker ps',
                            execTimeout: 120000,
                            
                          ),
                          sshTransfer(
                            execCommand: 'docker rm test',
                            execTimeout: 180000,
                            
                          ),
                          sshTransfer(
                            execCommand: 'ls',
                            execTimeout: 180000,
                            
                          ),
                          sshTransfer(
                            execCommand: 'docker images',
                            execTimeout: 120000,
                            
                          ),
                          sshTransfer(
                            execCommand: 'docker ps',
                            execTimeout: 120000,
                            
                          ),
                          sshTransfer(
                            execCommand: "cat ~/ACR_password.txt | docker login $repoReg --username $dusername  --password-stdin",
                            execTimeout: 120000,
                        
                          ),
                          sshTransfer(
                            execCommand: "docker pull $repoReg/$registry:${env.BUILD_ID}",
                            execTimeout: 120000, 
                            
                          ),
                          sshTransfer(
                            execCommand: "docker run -d -p 80:80 --name=test $repoReg/$registry:${env.BUILD_ID}",
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
        
        stage('Clean resource'){
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
