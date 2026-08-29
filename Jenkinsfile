pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }
    environment { 
        Course = 'Jenkins'
    }
    options {
        timeout(time: 10, unit: 'MINUTES') 
        disableConcurrentBuilds()
    }
    
    stages {
        stage('NPM Install') {
            steps {
                script {
                    sh """
                        npm install
                    """
                }
            }
        }
        stage('Test') {
            steps {
                echo "Testing"
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploying"
            }
        }
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