@Library('jenkins-lib') _
 
import ca.ssq.aws.Terraform
import ca.ssq.documentation.DocController
import ca.ssq.aws.AwsController
import ca.ssq.jenkins.JenkinsEnv
import ca.ssq.common.Template
import ca.ssq.aws.AwsWorkload
 
pipeline {
  agent { label 'agent-RHEL8' }

  options {
    // pour laisser le contrôle du checkout au pipeline
    skipDefaultCheckout()
    // garder seulement les 3 dernières exécutions
    buildDiscarder(logRotator(numToKeepStr: '3'))
    // toujours imprimer le temps d'exécution sur le log
    timestamps()
    // timout d'exécution globale de 2 heures
    timeout(time: 2, unit: 'HOURS')
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  environment {
    terraformMap = null
    DocController docController = null
    AwsController awsCtrl = null
    String TERRAFORM_VERSION = "2.1.21_0.13.6_1.16.13_3.5.0_2.1.1_01"
    JenkinsEnv jnk = null
    String releaseInput = null
    Template tpl = null
  }

  stages {
    stage('Init') {
      steps {
        cleanWs()
        checkout scm
        script {
          terraformMap = [:]
          tpl = new Template()
          jnk = new JenkinsEnv()
          awsCtrl = new AwsController(this, TERRAFORM_VERSION, AwsWorkload.LAB.getAccount())
          docController = new DocController(this)
          dir("provisioning"){
          }
        }
      }
    }

    stage('Validation pour le Release') {
      agent none
      // l'utilisateur a appuyé sur le button 'Build' dans Jenkins (i.e. pas de l'intégration continue)
      when { expression { jnk.isBuildedManually() == true } }
      steps {
        script {
          releaseInput = tpl.releaseValidation()
        }
      }
    }

    stage('Terraform - init') {
      steps {
        script {
            curTerraform = new Terraform(awsCtrl, "/provisioning")
            curTerraform.init()       
        }
      }
    }

    stage('Terraform - validate') {
      steps {
        script {
            curTerraform.validate()
        }
      }
    } 
    
    stage('Terraform - plan') {
      steps {
        script {

          sh "git diff --name-only HEAD develop -- provisioning || echo changed"
            curTerraform.plan()
        }
      }
    }
/*      
    stage('Terraform - apply') {
      when {
        beforeAgent true
          anyOf {
            branch 'develop'
            expression { JOB_NAME.startsWith('PR-') }
          }
      }
      steps {
        script {
          try {
              curTerraform.apply()
          } catch (err) {
              echo "Caught: ${err}"
              currentBuild.result = 'FAILURE'
          }
        }
      }
    }

    stage('Terraform - destroy') {
      when {
        beforeAgent true
          anyOf {
            branch 'develop'
            expression { JOB_NAME.startsWith('PR-') }
          }
      }
      steps {
        script {
            curTerraform.destroy()
        }
      }
    }

    stage('Build documentation') {
      steps {
        script {
          dir("doc") {
            //Generate sphinx doc in the folder doc
            docController.generateSphinxDoc()
          }
        }
      }
    }

    stage('Push documentation') {
      when { anyOf { branch 'master'; branch 'develop' } }
      steps {
        script {
          dir("doc/_build/html") {
            docController.pushDocS3("scs-aws-s3-doc-dev-003")
          }
        }
      }
    }

    stage('Inform Teams documentation') {
      when { anyOf { branch 'master'; branch 'develop' } }
      steps {
        script {
          def url = docController.getS3Url("scs-aws-s3-doc-dev-003")
          office365ConnectorSend webhookUrl: "https://outlook.office.com/webhook/7ec65696-8f12-4ea8-8128-18eb48fac796@5ad62f8a-da9a-4f5e-b9c1-649756c550ca/JenkinsCI/682f0d4a2df5448b952e15fb12593dcd/2e85ff26-4216-40ed-8e3d-a542c8d4db9c", message: "Nouvelle doc pour l'infra terraform : ${url}"
        }
      }
    }

    stage('Release') {
      when {
        expression { releaseInput == "Oui" || params.release == true }
        // on ne release pas Master (master est un pointeur vers le dernier tag de PRO)
        not { branch 'master' }
      }
      steps {
        cleanWs()
        // création du tag et changement de version
        script { tpl.release() }
      }
    }
  }
*/
  post {
    aborted {
      script { currentBuild.result = 'SUCCESS' }
    }
    always {
        //Always clean workspace to destroy password
          cleanWs()
    }
    unsuccessful {
      script { tpl.postUnsuccessful() } // avertissements via courriel en cas de problèmes
    }
  }
}
 