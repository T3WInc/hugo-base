pipeline {
  agent any
  
  parameters {
    string( name: 'semver', defaultValue: '1.0.0',
           description: 'the resulting semver version number after running gitversion on the source at GitHub')
    string( name: 'branchname', defaultValue: 'master',
           description: 'the actual branch name that triggered the build as precurred from gitVersion')
  }
  
  environment {
    BRANCH_NAME="${params.branchname}"
  }
  
  stages {
    stage('Initialization') {
      steps {
        buildName "${params.semver}"
        buildDescription "${params.branchname}"
      }      
    }
    
    stage('Build') {
      steps {
        sh 'docker build --force-rm --no-cache -t hugo . ' 
      }
    }

    stage('Test-Image'){
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
                  error "Test-Image ERROR: The execution of the container structure tests failed, see the log for details."
                  echo err
              } 
          }
      }
    }  
    
    stage('Publish-Topic') {
      steps {
        sh 'chmod +x ./ci/publish-topic.sh'
        sh "./ci/publish-topic.sh ${params.semver}"
      }
    }

    stage('Publish-Master'){
      when {
        environment name: 'BRANCH_NAME', value: 'master'
      }
      steps {
        sh 'chmod +x ./ci/publish-master.sh'
        sh "./ci/publish-master.sh ${params.semver}"
      }
    }
  }
}
