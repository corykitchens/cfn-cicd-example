pipeline {
    agent {
        docker {
            image 'python:latest'
        }
    }
    stages {
        stage('Install dependencies') {
            steps {
                withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh '''
                    pip3 install -r requirements.txt
                    export PATH=./.local/bin:$PATH
                    '''
                }
            }
            post {
                success {
                    echo "dependencies install successfully"
                }
                failure {
                    echo "pip install failure"
                    sh "cat pip.log"
                }
            }
        }
        stage('Lint CFN') {
            steps {
                withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh '''
                    #!/bin/bash
                    export PATH=./.local/bin:$PATH
                    taskcat lint
                    '''
                }
            }
            post {
                success {
                    echo "Lint complete"
                }
                failure {
                    echo "Failure linting template"
                }
            }
        }
        stage('Testing CFN') {
            steps {
                withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh '''
                    #!/bin/bash
                    export PATH=./.local/bin:$PATH
                    export AWS_REGION=us-west-2
                    taskcat test run
                    '''
                }
            }
            post {
                success {
                    echo "Test success"
                }
                failure {
                    echo "Test failure"
                }
            }
        }
        stage('Merge into local Dev branch') {
            steps {
                git branch: 'dev', credentialsId: 'github', url: 'https://github.com/corykitchens/cfn-cicd-example'
                sh "git merge ${env.BRANCH_NAME}"
                sh '''
                #!/bin/bash
                export PATH=./.local/bin:$PATH
                export AWS_REGION=us-west-2
                taskcat test run
                '''
                input('Merge changes upstream to Dev?')
                sh "git push origin dev"
            }
        }
        stage('Merge into master') {
            steps {
                git branch: 'master', credentialsId: 'github', url: 'https://github.com/corykitchens/cfn-cicd-example'
                sh "git merge dev"
                sh '''
                #!/bin/bash
                export PATH=./.local/bin:$PATH
                export AWS_REGION=us-west-2
                taskcat test run
                '''
                input('Merge changes upstream to Master?')
                sh "git push origin master"
            }
        }
        stage('Deploy from Master') {
            steps {
                input('Deploy to Production?')
                sh '''
                #!/bin/bash
                export PATH=./.local/bin:$PATH
                export AWS_REGION=us-west-2
                sam build
                sam deploy
                '''
            }
        }
    }
}