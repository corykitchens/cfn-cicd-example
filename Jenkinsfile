pipeline {
    agent any
    stages {
        stage('Install dependencies') {
            steps {
                sh "pip3 install -r requirements.txt > pip.log"
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
    }
}