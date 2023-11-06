pipeline {
  agent any

  stages {
    stage('Terraform') {
      steps {
        dir('/opt/terraform') {
          sh 'sudo terraform init'
          sh 'sudo terraform plan'
          sh 'sudo terraform apply -auto-approve'
          sh 'sleep 60'
        }
      }
    }

    stage('Ansible') {
      steps {
        dir('/opt/ansible') {
          sh 'cd /opt/ansible'
          sh 'sudo ansible-playbook -i inventory boxfuse.yml'
        }
      }
    }
  }
}