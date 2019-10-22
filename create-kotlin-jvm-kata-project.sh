#!/usr/bin/env bash
#
# Creates a Kotlin/JVM kata project.

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

echo "Creating Kotlin/JVM kata project in ${PWD}/${NAME}"

mkdir -p "${NAME}"/src/{main,test}/kotlin

# shellcheck disable=SC2016
echo 'import org.gradle.api.tasks.testing.logging.TestExceptionFormat.FULL
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.adarshr.test-logger") version "1.7.0"
    id("com.github.ben-manes.versions") version "0.24.0"
    id("com.vanniktech.code.quality.tools") version "0.19.0"
    id("java")
    id("org.jetbrains.kotlin.jvm") version "1.3.50"
}

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

repositories {
    google()
    gradlePluginPortal()
    mavenCentral()
}

dependencies {
    testImplementation("io.mockk:mockk:1.9.3")
    testImplementation("org.assertj:assertj-core:3.13.2")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    val junitVersion = "5.5.1"
    testImplementation("org.junit.jupiter:junit-jupiter-api:$junitVersion")
    testImplementation("org.junit.jupiter:junit-jupiter-params:$junitVersion")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:$junitVersion")
    testRuntimeOnly("org.junit.vintage:junit-vintage-engine:$junitVersion")

    // Additional test flavors
    /*
    testImplementation("com.google.truth:truth:1.0")
    testImplementation("com.nhaarman.mockitokotlin2:mockito-kotlin:2.1.0")
    testImplementation("com.willowtreeapps.assertk:assertk-jvm:0.19")
    testImplementation("junit:junit:4.12")
    val kotlinTestVersion = "3.4.0"
    testImplementation("io.kotlintest:kotlintest-assertions:$kotlinTestVersion")
    testImplementation("io.kotlintest:kotlintest-core:$kotlinTestVersion")
    testImplementation("io.kotlintest:kotlintest-runner-junit5:$kotlinTestVersion")
    testImplementation("io.strikt:strikt-core:0.21.1")
    testImplementation("org.amshove.kluent:kluent:1.453")
    testImplementation("org.hamcrest:hamcrest-all:1.3")
    testImplementation("org.mockito:mockito-junit-jupiter:3.0.0")
    val kotlinDotTestVersion = "1.3.50"
    testImplementation("org.jetbrains.kotlin:kotlin-test:$kotlinDotTestVersion")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlinDotTestVersion")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5:$kotlinDotTestVersion")
    val spekVersion = "2.0.6"
    testImplementation("org.spekframework.spek2:spek-dsl-jvm:$spekVersion")
    testRuntimeOnly("org.spekframework.spek2:spek-runner-junit5:$spekVersion")
    */
}

tasks.clean {
    doFirst {
        delete("out")
    }
}

tasks.test {
    useJUnitPlatform()
    testLogging {
        exceptionFormat = FULL
        events("passed", "skipped", "failed", "standard_error", "standard_out")
    }
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = JavaVersion.VERSION_1_8.toString()
}' >"${NAME}"/build.gradle.kts

echo "Created successfully! You can now import the project into your IDE."
