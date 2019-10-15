#!/usr/bin/env bash
#
# Create Java/JVM kata project.

# If a command fails then do not proceed and fail this script too
set -o errexit
set -o pipefail

read -rp "Please enter the kata project name: " NAME
echo
export NAME

if [[ -z "${NAME}" ]]; then
  echo 'Kata project name was not entered'
  exit 1
fi

if [[ -d "${NAME}" ]]; then
  echo 'Kata project with this name already exist'
  exit 1
fi

echo "Creating Java/JVM kata project in ${PWD}/${NAME}"

mkdir -p "${NAME}"/src/{main,test}/java

echo "plugins {
    id 'com.adarshr.test-logger' version '1.7.0'
    id 'com.github.ben-manes.versions' version '0.24.0'
    id 'java'
}

sourceCompatibility = 1.8

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'org.mockito:mockito-junit-jupiter:3.0.0'

    def junitVersion = '5.5.1'
    testImplementation \"org.junit.jupiter:junit-jupiter-api:\${junitVersion}\"
    testImplementation \"org.junit.jupiter:junit-jupiter-params:\${junitVersion}\"
    testRuntimeOnly \"org.junit.jupiter:junit-jupiter-engine:\${junitVersion}\"
    testRuntimeOnly \"org.junit.vintage:junit-vintage-engine:\${junitVersion}\"

    testImplementation 'org.assertj:assertj-core:3.13.2'

    // Additional test flavors
    /*
    testImplementation 'com.google.truth:truth:1.0'
    testImplementation 'junit:junit:4.12'
    testImplementation 'org.hamcrest:hamcrest-all:1.3'
    */
}

clean {
    doFirst {
        delete 'out'
    }
}

test {
    useJUnitPlatform()
    testLogging {
        exceptionFormat = 'full'
        events = ['passed', 'failed', 'skipped', 'standard_error', 'standard_out']
    }
}" >"${NAME}"/build.gradle

echo "Created successfully! You can now import the project into your IDE."
