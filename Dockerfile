FROM ubuntu:20.10

LABEL maintainer="Sreejith B Naick"

ENV ANDROID_HOME="/opt/android-sdk" \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_TOOLS_VERSION="6858069"

# Set locale
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM=dumb \
    DEBIAN_FRONTEND=noninteractive

ENV REPO_OS_OVERRIDE="linux"

# Variables must be references after they are created
ENV ANDROID_SDK_HOME="$ANDROID_HOME"

ENV PATH="$PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools"

COPY README.md /README.md

WORKDIR /tmp

# Installing packages
RUN apt-get update -qq > /dev/null && \
    apt-get install software-properties-common -qq > /dev/null && \
    add-apt-repository universe > /dev/null && \
    apt-get update -qq > /dev/null && \
    apt-get install -qq locales > /dev/null && \
    locale-gen "$LANG" > /dev/null && \
    apt-get install -qq --no-install-recommends \
    python2 \
	openjdk-8-jdk \
        git \
        curl \
        unzip \
        wget \
        zip \
        zlib1g-dev > /dev/null

RUN curl --silent https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py > /dev/null && \
    python2 get-pip.py && \
    pip --version

# Install Android SDK
# https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
RUN echo "installing sdk tools" && \
    wget --quiet --output-document=sdk-tools.zip \
        "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip" && \
    mkdir --parents "$ANDROID_HOME" && \
    unzip -q sdk-tools.zip -d "$ANDROID_HOME/" && \
    mv "$ANDROID_HOME/cmdline-tools" "$ANDROID_HOME/tools" && \
    mkdir --parents "$ANDROID_HOME/cmdline-tools/" && \
    mv "$ANDROID_HOME/tools" "$ANDROID_HOME/cmdline-tools/" && \
    rm --force sdk-tools.zip

ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/cmdline-tools/tools/bin

# Install SDKs
# Please keep these in descending order!
# The `yes` is for accepting all non-standard tool licenses.
RUN mkdir --parents "$HOME/.android/" && \
    echo '### User Sources for Android SDK Manager' > \
        "$HOME/.android/repositories.cfg" && \
    yes | sdkmanager --licenses > /dev/null && \
    echo "installing platforms" && \
    yes | sdkmanager "platforms;android-30" && \
    echo "installing platform tools " && \
    yes | sdkmanager "platform-tools" && \
    echo "installing build tools " && \
    yes | sdkmanager "build-tools;30.0.0"

# Copy sdk license agreement files.
RUN mkdir -p $ANDROID_HOME/licenses
COPY sdk/licenses/* $ANDROID_HOME/licenses/
