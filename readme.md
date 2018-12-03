## Directions

### Build Image with Configuration

Overwrite `/etc/aws-kinesis/agent.json` with configuration and run.

Example:

```dockerfile
FROM pocket/kinesis-agent
COPY agent.json /etc/aws-kinesis/agent.json
```

```bash
$ docker build -n kinesis-agent . \
    && docker run kinesis-agent
```

### Mount Configuration as Volume

```bash
$ docker build -n kinesis-agent . \
    && docker run kinesis-agent -v /path/agent.json:/etc/aws-kinesis/agent.json kinesis-agent 
```

 
