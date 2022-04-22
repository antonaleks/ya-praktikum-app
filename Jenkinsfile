pipeline {
    agent any // Выбираем Jenkins агента, на котором будет происходить сборка: нам нужен любой

    triggers {
        pollSCM('H/5 * * * *') // Запускать будем автоматически по крону примерно раз в 5 минут
    }

    tools {
        maven 'maven-3.8.1' // Для сборки бэкенда нужен Maven
        jdk 'JDK16' // И Java Developer Kit нужной версии
        nodejs 'nodejs16' // А NodeJS нужен для фронта
    }

    stages {
        stage('Build & Test backend') {
            steps {
                dir("backend") { // Переходим в папку backend
                    sh 'mvn package' // Собираем мавеном бэкенд
                }
            }

            post {
                success {
                    junit 'backend/target/surefire-reports/**/*.xml' // Передадим результаты тестов в Jenkins
                }
            }
        }

        stage('Build frontend') {
            steps {
                dir("frontend") {
                    sh 'npm install' // Для фронта сначала загрузим все сторонние зависимости
                    sh 'npm run build' // Запустим сборку
                }
            }
        }

        stage('Save artifacts') {
            steps {
                archiveArtifacts(artifacts: 'backend/target/sausage-store-0.0.1-SNAPSHOT.jar')
                archiveArtifacts(artifacts: 'frontend/dist/frontend/*')
            }
        }

        stage('Notify slack'){
            steps{
                script{
                    sh(script: "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"**Антон Алексеев** собрал приложение.\"}' https://hooks.slack.com/services/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")
                }
            }
        }
    }
}