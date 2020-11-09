#!groovy
// SPDX-FileCopyrightText: © 2020 Alias Developers
// SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
//
// SPDX-License-Identifier: MIT

pipeline {
    agent any
    options {
        timestamps()
        timeout(time: 2, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '5'))
        disableConcurrentBuilds()
    }
    environment {
        // In case another branch beside master or develop should be deployed, enter it here
        BRANCH_TO_DEPLOY = 'xyz'
        // This version will be used for the image tags if the branch is merged to master
        BASE_IMAGE_VERSION = '1.6'
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
    }
    stages {
        stage('Notification') {
            steps {
                // Using result state 'ABORTED' to mark the message on discord with a white border.
                // Makes it easier to distinguish job-start from job-finished
                discordSend(
                        description: "Started build #$env.BUILD_NUMBER",
                        image: '',
                        //link: "$env.BUILD_URL",
                        successful: true,
                        result: "ABORTED",
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        stage('Build image') {
            when {
                not {
                    anyOf { branch 'develop'; branch 'master'; branch "${BRANCH_TO_DEPLOY}" }
                }
            }
            //noinspection GroovyAssignabilityCheck
            parallel {
                stage('Debian Stretch') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Debian/Dockerfile_Stretch Dockerfile"
                            docker.build("aliascash/alias-base-debian-stretch", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Debian Buster') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Debian/Dockerfile_Buster Dockerfile"
                            docker.build("aliascash/alias-base-debian-buster", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('CentOS') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./CentOS/Dockerfile ."
                            docker.build("aliascash/alias-base-centos", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Fedora') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Fedora/Dockerfile ."
                            docker.build("aliascash/alias-base-fedora", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Raspberry Pi Stretch') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./RaspberryPi/Dockerfile_Stretch Dockerfile"
                            docker.build("aliascash/alias-base-raspi-stretch", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Raspberry Pi Buster') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./RaspberryPi/Dockerfile_Buster Dockerfile"
                            docker.build("aliascash/alias-base-raspi-buster", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Ubuntu 18.04') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Ubuntu/Dockerfile_18_04 Dockerfile"
                            docker.build("aliascash/alias-base-ubuntu-18-04", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Ubuntu 19.04') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Ubuntu/Dockerfile_19_04 Dockerfile"
                            docker.build("aliascash/alias-base-ubuntu-19-04", "--rm .")
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
            }
        }
        stage('Build and upload image') {
            when {
                anyOf { branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            //noinspection GroovyAssignabilityCheck
            parallel {
                stage('Debian Stretch') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Debian/Dockerfile_Stretch Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-debian-stretch", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Debian Buster') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Debian/Dockerfile_Buster Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-debian-buster", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('CentOS') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./CentOS/Dockerfile ."
                            def spectre_base_image = docker.build("aliascash/alias-base-centos", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Fedora') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Fedora/Dockerfile ."
                            def spectre_base_image = docker.build("aliascash/alias-base-fedora", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Raspberry Pi Stretch') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./RaspberryPi/Dockerfile_Stretch Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-raspi-stretch", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Raspberry Pi Buster') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./RaspberryPi/Dockerfile_Buster Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-raspi-buster", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Ubuntu 18.04') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Ubuntu/Dockerfile_18_04 Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-ubuntu-18-04", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Ubuntu 19.04') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Ubuntu/Dockerfile_19_04 Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-ubuntu-19-04", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("latest")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
            }
        }
        stage('Release and upload image') {
            when {
                branch 'master'
            }
            //noinspection GroovyAssignabilityCheck
            parallel {
                stage('Debian Stretch') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Debian/Dockerfile_Stretch Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-debian-stretch", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Debian Buster') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Debian/Dockerfile_Buster Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-debian-buster", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('CentOS') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./CentOS/Dockerfile ."
                            def spectre_base_image = docker.build("aliascash/alias-base-centos", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Fedora') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Fedora/Dockerfile ."
                            def spectre_base_image = docker.build("aliascash/alias-base-fedora", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Raspberry Pi Stretch') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./RaspberryPi/Dockerfile_Stretch Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-raspi-stretch", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Raspberry Pi Buster') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./RaspberryPi/Dockerfile_Buster Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-raspi-buster", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Ubuntu 18.04') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Ubuntu/Dockerfile_18_04 Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-ubuntu-18-04", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
                stage('Ubuntu 19.04') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            // Copy step on Dockerfile is not working if Dockerfile is not located on root dir!
                            // So copy required Dockerfile to root dir for each build
                            sh "cp ./Ubuntu/Dockerfile_19_04 Dockerfile"
                            def spectre_base_image = docker.build("aliascash/alias-base-ubuntu-19-04", "--rm .")
                            docker.withRegistry('https://registry.hub.docker.com', 'DockerHub-Login') {
                                spectre_base_image.push("${BASE_IMAGE_VERSION}")
                            }
                            sh "rm Dockerfile"
                        }
                    }
                    post {
                        always {
                            sh "docker system prune --all --force"
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            script {
                if (!hudson.model.Result.SUCCESS.equals(currentBuild.getPreviousBuild()?.getResult())) {
                    emailext(
                            subject: "GREEN: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                            body: '${JELLY_SCRIPT,template="html"}',
                            recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                            to: "to@be.defined",
//                            replyTo: "to@be.defined"
                    )
                }
                discordSend(
                        description: "Build #$env.BUILD_NUMBER finished successfully",
                        image: '',
                        //link: "$env.BUILD_URL",
                        successful: true,
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        unstable {
            emailext(
                    subject: "YELLOW: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                    body: '${JELLY_SCRIPT,template="html"}',
                    recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                    to: "to@be.defined",
//                    replyTo: "to@be.defined"
            )
            discordSend(
                    description: "Build #$env.BUILD_NUMBER finished unstable",
                    image: '',
                    //link: "$env.BUILD_URL",
                    successful: true,
                    result: "UNSTABLE",
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
        failure {
            emailext(
                    subject: "RED: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                    body: '${JELLY_SCRIPT,template="html"}',
                    recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                    to: "to@be.defined",
//                    replyTo: "to@be.defined"
            )
            discordSend(
                    description: "Build #$env.BUILD_NUMBER failed!",
                    image: '',
                    //link: "$env.BUILD_URL",
                    successful: false,
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
    }
}
