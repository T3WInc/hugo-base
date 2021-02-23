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
        sh "docker build --force-rm --no-cache -t t3winc/hugo:"${params.semver}" . " 
      }
    }
    
    stage('Publish') {
      steps {
        sh "cat /var/jenkins_home/my_password.txt | docker login -u schulzdl --password-stdin"
        sh "docker push t3winc/hugo:"${params.semver}"
      }
    }
  }
}
