FROM debian:bullseye@sha256:a4c378901a2ba14fd331e96a49101556e91ed592d5fd68ba7405fdbf9b969e61

ENV AGENT_VERSION=2.0.5 \
    JAVA_START_HEAP=32m \
    JAVA_MAX_HEAP=512m \
    LOG_LEVEL=INFO

WORKDIR /app

# Setup and install Java 1.8
# kinesis agent checks for this specifically
RUN apt-get update && apt-get install -y software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main'

RUN apt-get update && apt-get install --no-install-recommends -y curl ant openjdk-8-jdk \
    && update-alternatives --set "java" /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/awslabs/amazon-kinesis-agent/archive/${AGENT_VERSION}.tar.gz \
    && tar xvzf ${AGENT_VERSION}.tar.gz \
    && rm ${AGENT_VERSION}.tar.gz \
    && mv amazon-kinesis-agent-${AGENT_VERSION} amazon-kinesis-agent \
    && cd amazon-kinesis-agent \
    && ./setup --build

# Route aws-kinesis-agent.log to stdout
RUN mkdir -p /var/log/aws-kinesis-agent \
    && touch /var/log/aws-kinesis-agent/aws-kinesis-agent.log \
    && ln -sfT /dev/stdout /var/log/aws-kinesis-agent/aws-kinesis-agent.log

RUN mv amazon-kinesis-agent/support/log4j.xml amazon-kinesis-agent/log4j2.xml

COPY agent.json /etc/aws-kinesis/agent.json
COPY start.sh .
CMD ["./start.sh"]
