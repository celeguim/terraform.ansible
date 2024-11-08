node {
    environment {
        REM_USER = 'ec2-user'
        REM_HOST = '34.227.56.244'
    }
    
    stage ('Git Checkout') {
        git branch: 'main', url: 'https://github.com/celeguim/kubernetes_projects.git'
    }
    
    stage ('Sending docker file to Ansible Server over ssh') {
       sshagent(['ansible-server']) {
           sh "ssh -o StrictHostKeyChecking=no ec2-user@34.227.56.244"
           sh "scp /var/lib/jenkins/workspace/pipeline_demo/Dockerfile ec2-user@34.227.56.244:"
        }
    }
    
    stage ('Docker Build Image') {
        sshagent(['ansible-server']) {
           sh "ssh -o StrictHostKeyChecking=no ec2-user@34.227.56.244"
           sh "ssh -o StrictHostKeyChecking=no ec2-user@34.227.56.244 sudo docker image build -t $JOB_NAME:v1.$BUILD_ID -f /home/${USER}/Dockerfile ."
        }
    }
}
