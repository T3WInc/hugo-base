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
				sh 'curl -X PURGE https://camo.githubusercontent.com/143dbf056f2ee748c70d1e3a62028ef7d2c0f8eac35cd98ad163e1010edb8498/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e734275696c642e737667'
				sh 'curl -X PURGE https://camo.githubusercontent.com/d3e8c60aeb32254131ff914530f28ac2aefec203743ecc20a478a4a0a2b0269d/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e734465762e737667'
				sh 'curl -X PURGE https://camo.githubusercontent.com/28263c5e270b89eb06c97f58e482f8103be16983bf82136a8b55a712c6e270c1/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e7350726f642e737667'
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
						token: '143dbf056f2ee748c70d1e3a62028ef7d2c0f8eac35cd98ad163e1010edb8498/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e734275696c642e737667'
					)
        		}
        		failure {
          			createFailureBadge(
						imageName: 'hugoBuild.svg',
						prodName: 'Hugo',
						semver: "${semver}",
						token: '143dbf056f2ee748c70d1e3a62028ef7d2c0f8eac35cd98ad163e1010edb8498/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e734275696c642e737667'
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
                        token: 'd3e8c60aeb32254131ff914530f28ac2aefec203743ecc20a478a4a0a2b0269d/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e734465762e737667'
                    )
                }
                failure {
                    createFailureBadge(
                        imageName: 'hugoDev.svg',
                        prodName: 'Hugo',
                        semver: "${semver}",
                        token: 'd3e8c60aeb32254131ff914530f28ac2aefec203743ecc20a478a4a0a2b0269d/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e734465762e737667'
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
                        token: '28263c5e270b89eb06c97f58e482f8103be16983bf82136a8b55a712c6e270c1/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e7350726f642e737667'
                    )
                }
                failure {
                    createFailureBadge(
                        imageName: 'hugoProd.svg',
                        prodName: 'Hugo',
                        semver: "${semver}",
                        token: '28263c5e270b89eb06c97f58e482f8103be16983bf82136a8b55a712c6e270c1/68747470733a2f2f62616467652e743377696e632e636f6d2f696d616765732f6a656e6b696e7350726f642e737667'
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
