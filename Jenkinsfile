@Library('jenkins-shared-library') _

if (env.BRANCH_NAME == 'new-feature') {
    nodejs([
        project: 'roboshop',
        component: 'catalogue'
    ])
} else {
    echo "Skipping execution for branch: ${env.BRANCH_NAME}"
}