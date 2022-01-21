## Directions

Image name: public.ecr.aws/pocket/kinesis-agent

### Build Image with Configuration

Overwrite `/etc/aws-kinesis/agent.json` with configuration on run.

Example:
```json
command: ['-c', `echo ${kinesisConfig} | base64 -d - | tee /etc/kinesis-agent/agent.json`],
```

 
