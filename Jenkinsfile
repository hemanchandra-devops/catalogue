@Library('jenkins-shared-library') _

def configMap = [
    project: 'roboshop',
    component: 'catalogue'
]

if (env.BRANCH_NAME != 'main') {
    echo "Not main branch, continuing pipeline..."
    nodejsPipeline(configMap)
} else {
    echo "Main branch detected, stopping pipeline..."
    currentBuild.result = 'ABORTED'
    error("Pipeline stopped because branch is main")
}