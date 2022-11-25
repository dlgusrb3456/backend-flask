node {
     stage('Clone repository') {
         checkout scm
     }
     
     stage('make code directory'){
          sh("""
               mkdir myflask
               mv __init__.py myflask
               mv entities myflask
               mv main.py myflask
               """)
     }

     stage('Build image') {
         app = docker.build("685766701737.dkr.ecr.ap-northeast-1.amazonaws.com/test")
     }

     stage('Push image') {
         sh 'rm  ~/.dockercfg || true'
         sh 'rm ~/.docker/config.json || true'
          
         docker.withRegistry('https://685766701737.dkr.ecr.ap-northeast-1.amazonaws.com', 'ecr:ap-northeast-1:ecr_credential') {
             app.push("be_${env.BUILD_NUMBER}")
             app.push("latest")
     }
  }
     
     stage('Deploy Repo2'){
          checkout([$class: 'GitSCM',
                        branches: [[name: '*/main' ]],
                        extensions: scm.extensions,
                        userRemoteConfigs: [[
                            url: 'git@github.com:dlgusrb3456/ArgoCD.git',
                            credentialsId: 'jenkins-ssh-private',
                        ]]
                ])
          sshagent(credentials: ['jenkins-ssh-private']){
               sh("""
                        #!/usr/bin/env bash
                        set +x
                        export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no"
                        git config --global user.email "dlgusrb3456@naver.com"
                        git config --global user.name "dlgusrb3456"
                        git checkout main
                        git pull origin main
                        cd overlay/dev && kustomize edit set image 685766701737.dkr.ecr.ap-northeast-1.amazonaws.com/test:be_${env.BUILD_NUMBER}
                        git commit -a -m "updated the image tag ${env.BUILD_NUMBER}"
                        git push
                    """)
          }
          
     }
     
     
}
