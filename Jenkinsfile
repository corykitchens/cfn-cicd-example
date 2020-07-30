pipeline {
  agent {
    dockerfile true
  }

  parameters {
    string(name: 'name', defaultValue: '')
  }

  environment {
    TF_VAR_bucket_name = "${params.name}"
  }

  stages {
    stage('Build') {
      steps {
        echo "====++++Verify access to bucket for Terraform state files++++===="
        sh '''
          terraform init
          terraform plan
        '''
      }
    }
  }

}
