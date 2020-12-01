@Library('sharedlib')
import static com.orcilatam.devops.Const.*
import static com.orcilatam.devops.Stage.*

def sonarqube = 'sonarqube:9000'
def registry = 'artifactory:8082/docker-local'
def registryId = 'registry-push-user'

pipeline {
  agent any

  stages {
    stage('Compilación') {
      steps {
        script {
          buildMaven(this)  /* mvn clean compile */
        }
      }
    }

    stage('Tests unitarios') {
      steps {
        script {
          testJUnit(this)   /* mvn test */
        }
      }
    }

    stage('Calidad de código') {
      steps {
        script {
          runSonarQube(this, sonarqube)
        }
      }
    }

    stage('Creación de artefacto') {
      steps {
        script {
          packageArtifact(this)
        }
      }
    }

    stage('Construcción de imagen Docker') {
      steps {
        script {
          buildDockerImage(this, registry)
        }
      }
    }

    stage('Subida a Artifactory') {
      steps {
        script {
          pushImageToArtifactory(this, registry, registryId)
        }
      }
    }

  }
}
