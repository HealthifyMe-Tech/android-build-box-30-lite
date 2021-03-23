# Docker Android Build Box

## Introduction

A **docker** image build with **Android** build environment.


## What Is Inside

Lite and stripped version of https://github.com/mingchen/docker-android-build-box

It includes the following components:

* Ubuntu 20.10
* Android SDK 30
* Android build tools 30.0.0
* Open JDK8, git, curl, wget, unzip, 
* Python 2.7, Pip 2


## Usage

### Use the image to build an Android project

You can use this docker image to build your Android project with a single docker command:

    cd <android project directory>  # change working directory to your project root directory.
    docker run --rm -v `pwd`:/project sreejithhme/android-build-lite bash -c 'cd /project; ./gradlew build'


## Docker Build Image

If you want to build the docker image by yourself, you can use following command.
The image will take itself more than 1 GB, check your free disk space before building it.

    docker build -t android-build-lite .


## References

* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
* [Build your own image](https://docs.docker.com/engine/getstarted/step_four/)
* [uber android build environment](https://hub.docker.com/r/uber/android-build-environment/)
* [Refactoring a Dockerfile for image size](https://blog.replicated.com/2016/02/05/refactoring-a-dockerfile-for-image-size/)
