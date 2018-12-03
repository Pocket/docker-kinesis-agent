FROM openjdk:8u171-jdk-alpine3.7

ENV AGENT_VERSION=1.1.4 \
    JAVA_START_HEAP=32m \
    JAVA_MAX_HEAP=512m \
    LOG_LEVEL=INFO

WORKDIR /app

RUN apk add --no-cache shadow curl bash apache-ant \
    && curl -LO https://github.com/awslabs/amazon-kinesis-agent/archive/${AGENT_VERSION}.tar.gz \
    && tar xvzf ${AGENT_VERSION}.tar.gz \
    && rm ${AGENT_VERSION}.tar.gz \
    && mv amazon-kinesis-agent-${AGENT_VERSION} amazon-kinesis-agent \
    && cd amazon-kinesis-agent \
    && ./setup --build

# Route aws-kinesis-agent.log to stdout
RUN mkdir -p /var/log/aws-kinesis-agent \
    && touch /var/log/aws-kinesis-agent/aws-kinesis-agent.log \
    && ln -sfT /dev/stdout /var/log/aws-kinesis-agent/aws-kinesis-agent.log

COPY agent.json /etc/aws-kinesis/agent.json
COPY start.sh .
CMD ["./start.sh"]
