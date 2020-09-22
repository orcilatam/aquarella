@Library('sharedlib')
import static com.orcilatam.devops.Const.*
import static com.orcilatam.devops.Stage.*

pipeline {
  agent any

  stages {
    stage('Compilación') {
      steps {
        script {
          buildMaven(this)
        }
      }
    }

    stage('Tests unitarios') {
      steps {
        script {
          testJUnit(this)
        }
      }
    }

  }
}
