pipeline {
    agent any
    stages {
        stage('Install dependencies') {
            steps {
                sh "pip3 install --user -r requirements.txt > pip.log"
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
        stage('Run build') {
            steps {
                echo "Do some building"
            }
            post {
                success {
                    echo "Build success"
                }
                failure {
                    echo "Build failure"
                }
            }
        }
        stage('Run some testing') {
            steps {
                echo "Do some testing"
            }
            post {
                success {
                    echo "Testing successful"
                }
                failure {
                    echo "Testing failed"
                }
            }
        }
        stage('Merge into dev') {
            steps {
                input('Merge into dev branch?')
                echo "Merge into dev"
            }
        }
        stage('Test dev branch') {
            steps {
                echo "Test dev branch"
            }
        }
        stage('Merge into master') {
            steps {
                input('Merge into Master?')
                echo "Merging into master branch"
            }
        }
        stage('Test master branch') {
            steps {
                echo "Testing master branch"
            }
        }
        stage('Deploy from Master') {
            steps {
                input('Deploy to Production?')
                echo "Deploying to production"
            }
        }
    }
}