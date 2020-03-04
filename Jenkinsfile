pipeline {
    agent {
        docker {
            image 'python:latest'
        }
    }
    parameters {
        string(name: 'bucket_name', defaultValue: 'mybucket', description: 'The name of the bucket to create')
        string(name: 'id', description: 'The Unique ID')
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
                echo "${params.bucket_name}"
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
                    # taskcat test run
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
        stage('Merge Feature Branch into Dev') {
            when {
                not {
                    anyOf {
                        branch 'master'
                        branch 'dev'
                    }
                }
            }
            steps {
                input('Merge feature branch into dev?')
                git branch: 'dev', credentialsId: 'github', url: 'https://github.com/corykitchens/cfn-cicd-example'
                sh "git merge ${env.BRANCH_NAME}"
                withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/corykitchens/cfn-cicd-example')
                }
            }
        }
        stage('Merge Dev into Master') {
            when {
                branch 'dev'
            }
            steps {
                input('Merge dev into master?')
                git branch: 'dev', credentialsId: 'github', url: 'https://github.com/corykitchens/cfn-cicd-example'
                sh "git merge ${env.BRANCH_NAME}"
                withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/corykitchens/cfn-cicd-example')
                }
            }
        }
        stage('Deploy from Master') {
            when {
                branch 'master'
            }
            steps {
                input('Deploy to Production?')
                withEnv(["HOME=${env.WORKSPACE}"]) {
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
}