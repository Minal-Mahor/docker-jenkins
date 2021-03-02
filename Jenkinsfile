pipeline {
  environment {
  IBM_CLOUD_REGION = 'eu-de'
  REGISTRY_HOSTNAME = 'de.icr.io'
  IKS_CLUSTER = 'c0rj4r1d0huad5id0ut0'
  DEPLOYMENT_NAME = 'iks-test'
  PORT = '5000'
  registry = "minalmahor/myapp"
  registryCredential = 'dockerHub'
  dockerImage = ''
  }
  agent any 
  stages {
    stage('Install IBM Cloud CLI') {
      steps { 
        bat ''' 
            ibmcloud --version
            ibmcloud config --check-version=false
            ibmcloud plugin install -f kubernetes-service
            ibmcloud plugin install -f container-registry
            '''
      }
    }
    stage('Authenticate with IBM Cloud CLI') {
      steps {
        bat '''
            ibmcloud login --apikey Vbm-YT7nOx5vONApyYx0wdycgVn9_hxRd5a4GHvDqnop  -r us-south -g Default
            ibmcloud ks cluster config --cluster ${IKS_CLUSTER}
            '''
      }
    }
    stage('Build with Docker') {
      steps {
        script {
        dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push the image to ICR') {
      steps {
        script {
          docker.withRegistry( '', registryCredential ) {
          dockerImage.push()
          }
        }
      }
    }
    stage('Deploy to IKS') {
      steps {
        bat '''
            ibmcloud ks cluster config --cluster ${IKS_CLUSTER}
            kubectl config current-context
            kubectl create deployment ${DEPLOYMENT_NAME} --image=minalmahor/myapp --dry-run -o yaml > deployment.yaml
            kubectl apply -f deployment.yaml
            kubectl rollout status deployment/${DEPLOYMENT_NAME}
            kubectl create service loadbalancer ${DEPLOYMENT_NAME} --tcp=80:${PORT} --dry-run -o yaml > service.yaml
            kubectl apply -f service.yaml
            kubectl get services -o wide
            '''
      }
    }
  }
}
