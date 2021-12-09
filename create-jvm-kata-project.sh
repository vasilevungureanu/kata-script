#!/usr/bin/env bash
#
# Creates a Kata project.

# If a command fails then do not proceed and fail this script too
set -o errexit
set -o pipefail

read -rp "Please enter the Kata project name: " NAME
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

echo "Creating Kata project in ${PWD}/${NAME}"

mkdir -p "${NAME}"/src/{main,test}/java

echo "plugins {
    id 'java'
    id 'idea'
}

sourceSets {
    test {
        java.srcDir file('src/test/java/')
    }
}

repositories {
    mavenCentral()
}

dependencies {
    def junitVersion = '5.8.2'

    testImplementation(
            platform(\"org.junit:junit-bom:\${junitVersion}\"),
            \"org.junit.jupiter:junit-jupiter:\${junitVersion}\",
            'org.assertj:assertj-core:3.21.0',
            'org.mockito:mockito-junit-jupiter:4.1.0'
    )
}

test {
    useJUnitPlatform()

    testLogging {
        events 'passed', 'skipped', 'failed'
    }
}" >"${NAME}"/build.gradle

echo "Created successfully! You can now import the project into your IDE."
