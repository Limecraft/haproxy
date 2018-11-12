#!groovy

@Library('LimecraftSharedLibrary') import com.limecraft.Utilities
def utils = new Utilities(this)
def err = null

currentBuild.result = "SUCCESS"

properties([
     parameters([
       booleanParam(
        defaultValue: false,
        description: 'Push to docker hub',
        name: 'PUSH_HUB'
       )
     ])
   ])

boolean push_hub = params.PUSH_HUB

try {
    node () {
        def v

        stage ('Checkout') {
            checkout scm
            v = utils.version()
            if (v) {
                echo "Building version ${v}"
            }
        }

        def newApp
        stage('Package') {
            newApp = docker.build "limecraft/haproxy:${env.BRANCH_NAME}"
        }

        stage('Publish') {
            if (push_hub || env.BRANCH_NAME == 'development') {
                newApp.push()
            }
            if (env.BRANCH_NAME == 'master') {
                newApp.push "${v}"
                newApp.push 'latest'
            }
            slackSend color: 'good', message: "Build ${env.JOB_NAME}#${env.BUILD_NUMBER} is available (<${env.BUILD_URL}|Open>)"
        }
    }
}
catch (caughtError) {
    err = caughtError
    currentBuild.result = "FAILURE"
    slackSend color: 'danger', message: "Build ${env.JOB_NAME}#${env.BUILD_NUMBER} failed: ${err} (<${env.BUILD_URL}|Open>)"
}
finally {
    /* Must re-throw exception to propagate error */
    if (err) {
        throw err
    }
}