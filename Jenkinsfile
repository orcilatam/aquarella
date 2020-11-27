@Library('sharedlib')
import static com.orcilatam.devops.Const.*
import static com.orcilatam.devops.Stage.*

def sonarqube = 'sonarqube:9000'

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

  }
}
