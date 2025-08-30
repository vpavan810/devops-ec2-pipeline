pipeline {
  agent any
  environment {
    AWS_REGION = 'ap-south-1'
    ACCOUNT_ID = '<your_aws_account_id>'
    BRANCH_NAME = "${env.GIT_BRANCH}"
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
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan (on PRs)') {
      when {
        not {
          branch 'main'
        }
      }
      steps {
        dir('terraform') {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform Apply (only on main)') {
      when {
        branch 'main'
      }
      steps {
        dir('terraform') {
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t my-app:latest ./app'
      }
    }

    stage('Push to ECR') {
      steps {
        sh '''
          aws ecr get-login-password --region $AWS_REGION | \
          docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
          docker tag my-app:latest $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/my-app:latest
          docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/my-app:latest
        '''
      }
    }

    stage('Deploy to ECS') {
      when {
        branch 'main'
      }
      steps {
        sh '''
          aws ecs update-service \
            --cluster my-app \
            --service my-app \
            --force-new-deployment \
            --region $AWS_REGION
        '''
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