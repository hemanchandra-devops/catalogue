pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }
    environment { 
        Course = 'Jenkins'
        appVersion = ""
        ACC_ID = "634758830486"
        PROJECT = "roboshop"
        COMPONENT = "catalogue"
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

        /* stage('SonarQube Analysis') {
            steps {
                // Requires the SonarQube Scanner plugin installed and configured in Jenkins Global Tool Configuration
                script {
                    def scannerHome = tool 'sonar-8.0' // Matches the name defined in Jenkins Global Tool Configuration
                    
                    // Requires a SonarQube server configured in Jenkins System Configuration
                    withSonarQubeEnv('sonar') { // Matches the SonarQube server configuration name
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    // Waits for SonarQube server to finish analysis and return status
                    waitForQualityGate abortPipeline: true
                }
            }
        } */

        /* stage('Check Dependabot Alerts') {
            environment {
                API_URL = 'https://api.github.com/repos/hemanchandra-devops/catalogue/dependabot/alerts?state=open&per_page=100'
            }

            steps {
                script {
                    withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                            set -e

                            echo "Checking Dependabot alerts..."

                            curl -sS \
                            -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                            -H "Accept: application/vnd.github+json" \
                            -H "X-GitHub-Api-Version: 2022-11-28" \
                            "${API_URL}" > dependabot-alerts.json

                            jq '.' dependabot-alerts.json

                            COUNT=$(jq '
                            map(
                                select(
                                .state == "open" and
                                (
                                    .security_advisory.severity == "high" or
                                    .security_advisory.severity == "critical"
                                )
                                )
                            ) | length
                            ' dependabot-alerts.json)

                            echo "Open High/Critical Dependabot alerts: ${COUNT}"

                            if [ "$COUNT" -gt 0 ]; then
                                echo "❌ Pipeline FAILED"
                                echo "Open High/Critical Dependabot vulnerabilities found."
                                exit 1
                            else
                                echo "✅ No Open High/Critical Dependabot alerts."
                                echo "Continuing pipeline..."
                            fi
                        '''
                        }
                    }
                }
            } */

        
        
        stage('Check Dependabot Alerts') {
            environment {
                REPO_OWNER = 'hemanchandra-devops'
                REPO_NAME  = 'catalogue'
                GITHUB_TOKEN = credentials('github-token')
            }
            steps {
                script {
                    echo "Checking Dependabot alerts for ${REPO_OWNER}/${REPO_NAME}..."

                    // Query GitHub API, filter for open high/critical alerts, save JSON output
                    def alertCount = sh(
                        script: '''
                            gh api repos/${REPO_OWNER}/${REPO_NAME}/dependabot/alerts \
                              --paginate \
                              --jq '[.[] | select(.state == "open" and (.security_vulnerability.severity == "high" or .security_vulnerability.severity == "critical"))]' > open_vulnerabilities.json

                            jq 'length' open_vulnerabilities.json
                        ''',
                        returnStdout: true
                    ).trim().toInteger()

                    // Display filtered JSON in build log
                    sh 'cat open_vulnerabilities.json | jq .'

                    // Fail pipeline if high or critical alerts exist
                    if (alertCount > 0) {
                        error("Pipeline failed: Found ${alertCount} open Dependabot alert(s) with High or Critical severity.")
                    } else {
                        echo "No open High or Critical Dependabot alerts found. Proceeding with pipeline."
                    }
                }
            }
        }


        stage('ECR') {
            steps {
                withAWS(region:'us-east-1',credentials:'aws') {
                    sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                        docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                        docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                    """
                }
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