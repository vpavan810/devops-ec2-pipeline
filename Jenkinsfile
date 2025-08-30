pipeline {
  agent any

  parameters {
    booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Check to destroy infrastructure instead of deploying')
  }

  environment {
    AWS_REGION   = 'ap-south-1'
    ACCOUNT_ID   = '851725564646'   // Replace with your actual AWS account ID
    BRANCH_NAME  = "${env.BRANCH_NAME}"      // Works in multibranch pipelines
    ECR_REPO     = 'my-app1'
    ECS_CLUSTER  = 'my-app'
    ECS_SERVICE  = 'my-app'
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        dir('terraform') {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
            sh 'terraform init'
          }
        }
      }
    }

    stage('Terraform Plan (on PRs)') {
      when {
        allOf {
          not { branch 'main' }
          expression { return !params.DESTROY_INFRA }
        }
      }
      steps {
        dir('terraform') {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
            sh 'terraform plan'
          }
        }
      }
    }

    stage('Terraform Apply (only on main)') {
      when {
        allOf {
          branch 'main'
          expression { return !params.DESTROY_INFRA }
        }
      }
      steps {
        dir('terraform') {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }

    stage('Terraform Destroy (manual trigger)') {
      when {
        expression { return params.DESTROY_INFRA }
      }
      steps {
        dir('terraform') {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
            sh 'terraform destroy -auto-approve'
          }
        }
      }
    }

    stage('Build Docker Image') {
      when {
        expression { return !params.DESTROY_INFRA }
      }
      steps {
        sh 'docker build -t $ECR_REPO:latest ./app'
      }
    }

    stage('Push to ECR') {
      when {
        expression { return !params.DESTROY_INFRA }
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
          sh '''
            aws ecr get-login-password --region $AWS_REGION | \
            docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
            docker tag $ECR_REPO:latest $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
            docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
          '''
        }
      }
    }

    stage('Deploy to ECS') {
      when {
        allOf {
          branch 'main'
          expression { return !params.DESTROY_INFRA }
        }
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
          sh '''
            aws ecs update-service \
              --cluster $ECS_CLUSTER \
              --service $ECS_SERVICE \
              --force-new-deployment \
              --region $AWS_REGION
          '''
        }
      }
    }
  }

  post {
    success {
      sh '''
        curl -X POST -H 'Content-type: application/json' \
        --data '{"text":"✅ Jenkins pipeline succeeded for branch: $BRANCH_NAME"}' \
        https://hooks.slack.com/services/your/webhook/url
      '''
    }
    failure {
      sh '''
        curl -X POST -H 'Content-type: application/json' \
        --data '{"text":"❌ Jenkins pipeline failed for branch: $BRANCH_NAME"}' \
        https://hooks.slack.com/services/your/webhook/url
      '''
    }
  }
}
