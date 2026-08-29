pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }
    environment { 
        Course = 'Jenkins'
        appVersion = ""
    }
    options {
        timeout(time: 10, unit: 'MINUTES') 
        disableConcurrentBuilds()
    }
    
    stages {
        stage('App Version') {
            steps {
                script {
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "AppVersion: ${appVersion}"
                }
            }
        }
        stage('npm Install') {
            steps {
                script {
                    sh """
                        npm install
                    """
                }
            }
        }
        stage('Unit Test') {
            steps {
                script {
                    sh """
                        npm test
                    """
                }
            }
        }
//         stage('Deploy') {
//             steps {
//                 withAWS(region:'eu-central-1',credentials:'nameOfSystemCredentials',federatedUserId:"${submitter}@${releaseVersion}", duration: 3600) {
//     // do something
// }
//             }
//         }
    }



    post { 
        always { 
            echo 'I will always say Hello again!'
            cleanWs()

        }
        success {
            echo 'I will run if pipeline sucess'
        }
        failure {
            echo 'I will run if pipeline failed'
        }
        aborted {
            echo 'pipeline is aborted'
        }
    }
}