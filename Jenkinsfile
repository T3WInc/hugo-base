@Library('pipeline-library') _

pipeline {

	agent any

	environment {
    	DOCKER_TOKEN = credentials('docker_token')
    	NEWPATH = pwd().replace('/var/', '/docker/')
    	semver = gitVersion(newpath: pwd().replace('/var/', '/docker/')).replace('-', '_')
  	}

  	stages {
		stage('Initialization') {
			steps {
				sh 'curl -X PURGE https://camo.githubusercontent.com/8a04455e32a428eb65810ff3fb7c854ef0bf666dac6a3b8877881c9b2b12d852/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f4465762e737667'
				sh 'curl -X PURGE https://camo.githubusercontent.com/cc1d2c75e38b69699bf059d62b759048c215f7b6a815342d5073583aed9c40b3/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f4275696c642e737667'
				sh 'curl -X PURGE https://camo.githubusercontent.com/fab7a8041244c02a6ab505708d1e8c20a649d36fa995c1181b4371ace5cc254a/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f50726f642e737667'
				sh 'docker version && docker-compose version'
			}
		}

		stage('Build') {
			steps {
				sh 'docker login -u schulzdl -p $DOCKER_TOKEN'
				sh 'docker image build --no-cache --rm -t hugo-base .'
			}
		}

    	stage('Test-Image') {
      		steps {
          		script {
              		try {
            			def status = 0
            			status = sh(returnStdout: true, script: "container-structure-test test --image 'hugo' --config './test/DockerTest/unit-test.yaml' --verbosity 'debug' --json | jq .Fail") as Integer
            			echo "$status"
            			if (status != 0) {
              				error 'Image Test has failed'
            			}
              		} catch (err) {
            			error 'Test-Image ERROR: The execution of the container structure tests failed, see the log for details.'
            			echo err
              		}
          		}
      		}
			post {
				success {
          			createSuccessBadge(
						imageName: 'hugoBuild.svg',
						prodName: 'Hugo',
						semver: "${semver}",
						token: 'cc1d2c75e38b69699bf059d62b759048c215f7b6a815342d5073583aed9c40b3/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f4275696c642e737667'
					)
        		}
        		failure {
          			createFailureBadge(
						imageName: 'hugoBuild.svg',
						prodName: 'Hugo',
						semver: "${semver}",
						token: 'cc1d2c75e38b69699bf059d62b759048c215f7b6a815342d5073583aed9c40b3/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f4275696c642e737667'
					)
        		}      		
			}
		}

		stage('Publish-Topic') {
			when {
				not {
					branch 'pull/*'
				}
			}
			steps {
				sh 'docker login -u schulzdl -p $DOCKER_TOKEN'
				sh "docker tag hugo-base schulzdl/hugo-base:v${semver}"
				sh "docker push schulzdl/hugo-base:v${semver}"
			}
            post {
                success {
                    createSuccessBadge(
                        imageName: 'hugoDev.svg',
                        prodName: 'Hugo',
                        semver: "${semver}",
                        token: '8a04455e32a428eb65810ff3fb7c854ef0bf666dac6a3b8877881c9b2b12d852/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f4465762e737667'
                    )
                }
                failure {
                    createFailureBadge(
                        imageName: 'hugoDev.svg',
                        prodName: 'Hugo',
                        semver: "${semver}",
                        token: '8a04455e32a428eb65810ff3fb7c854ef0bf666dac6a3b8877881c9b2b12d852/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f4465762e737667'
                    )          
                }
            }			
		}

		stage('Publish-Master') {
			when {
				branch 'master'
			}
			steps {
				sh 'docker login -u schulzdl -p $DOCKER_TOKEN'
				sh "docker tag schulzdl/hugo-base:v${semver} schulzdl/hugo-base:latest"
				sh "docker push schulzdl/hugo-base:latest"
			}
            post {
                success {
                    createSuccessBadge(
                        imageName: 'hugoProd.svg',
                        prodName: 'Hugo',
                        semver: "${semver}",
                        token: 'fab7a8041244c02a6ab505708d1e8c20a649d36fa995c1181b4371ace5cc254a/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f50726f642e737667'
                    )
                }
                failure {
                    createFailureBadge(
                        imageName: 'hugoProd.svg',
                        prodName: 'Hugo',
                        semver: "${semver}",
                        token: 'fab7a8041244c02a6ab505708d1e8c20a649d36fa995c1181b4371ace5cc254a/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6875676f50726f642e737667'
                    )
                }
            }			
		}
  	}

	post {
		always {
			cleanWs()
		}
	}
}
