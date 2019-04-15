FROM openjdk:8-jdk-alpine

ENV SONAR_SCANNER_VERSION 3.3.0.1492

COPY sonar-scanner-run.sh /usr/bin

ADD https://bintray.com/sonarsource/SonarQube/download_file?file_path=org%2Fsonarsource%2Fscanner%2Fcli%2Fsonar-scanner-cli%2F${SONAR_SCANNER_VERSION}%2Fsonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip /tmp/sonar-scanner.zip

WORKDIR /tmp

RUN \
    unzip /tmp/sonar-scanner.zip && \
    mv -fv /tmp/sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner /usr/bin && \
    mv -fv /tmp/sonar-scanner-${SONAR_SCANNER_VERSION}/lib/* /usr/lib

RUN \
    apk add --no-cache nodejs && \
    ls -lha /usr/bin/sonar* && \
    ln -s /usr/bin/sonar-scanner-run.sh /usr/bin/gitlab-sonar-scanner

FROM python:3.7-alpine

RUN \
    apk add --no-cache -u \
    bash \
    gcc \
    make \
    libffi-dev \
    musl-dev \
    musl-utils \
    jpeg-dev \
    freetype \
    git \
    openssh-client \
    freetype-dev && \
    python3 -m pip install -U \
        dumb-init \
        pip \
        pytest \
        pytest-cov \
        pylint \
        flake8


WORKDIR /usr/bin
