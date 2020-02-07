pipeline {


    triggers {
        pollSCM('* * * * *') //polling for changes, here once a minute
    }

    stages {
        stage('Checkout') {
            steps { //Checking out the repo
                checkout changelog: true, poll: true, scm: [$class: 'GitSCM', branches: [[name: '*/master']], browser: [$class: 'BitbucketWeb', repoUrl: 'https://web.com/blah'], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: 'ssh://git@https://github.com/ByteFiddler/HelloKubernetes.git']]]
            }
        }
        stage('Unit & Integration Tests') {
            steps {
                script {
                    try {
                        sh './gradlew clean test --no-daemon' //run a gradle task
                    } finally {
                        junit '**/build/test-results/test/*.xml' //make the junit test results available in any case (success & failure)
                    }
                }
            }
        }

        stage('Publish Artifact to Nexus') {
            steps {
                sh './gradlew publish --no-daemon'
            }
        }
    }
    post {
        always { //Send an email to the person that broke the build
            step([$class                  : 'Mailer',
                  notifyEveryUnstableBuild: true,
                  recipients              : [emailextrecipients([[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']])].join(' ')])
        }
    }
}
