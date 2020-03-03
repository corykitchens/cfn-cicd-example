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
                    # taskcat lint
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
                git branch: 'dev', credentialsId: 'github', url: 'git@github.com:corykitchens/cfn-cicd-example'
                echo "git branch"
                echo "git remote -v"
                sh "git merge ${env.BRANCH_NAME}"
                sshagent (credentials: ['github']) {
                    sh('git push git@github.com:corykitchens/cfn-cicd-example')
                }
            }
        }
        // stage('Merge Dev into Master') {
        //     when {
        //         branch 'dev'
        //     }
        //     steps {
        //         input('Merge dev into master?')
        //         git branch: 'master', credentialsId: 'github', url: 'https://github.com/<USER_NAME>/<REPO_NAME>'
        //         sh "git merge ${env.BRANCH_NAME}"
                
        //         sh "git push "
        //     }
        // }
        // stage('Deploy from Master') {
        //     when {
        //         branch 'master'
        //     }
        //     steps {
        //         input('Deploy to Production?')
        //         withEnv(["HOME=${env.WORKSPACE}"]) {
        //             sh '''
        //             #!/bin/bash
        //             export PATH=./.local/bin:$PATH
        //             export AWS_REGION=us-west-2
        //             sam build
        //             sam deploy
        //             '''
        //         }
        //     }
        // }
    }
}