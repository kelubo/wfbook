## REST API



Ollama has a REST API for running and managing models.
Ollama 有一个用于运行和管理模型的 REST API。

### Generate a response 生成响应



```
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt":"Why is the sky blue?"
}'
```

​    

### Chat with a model 与模型聊天



```
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    { "role": "user", "content": "why is the sky blue?" }
  ]
}'
```

​    

See the [API documentation](https://github.com/ollama/ollama/blob/main/docs/api.md) for all endpoints.
请参阅所有端点的 [API 文档](https://github.com/ollama/ollama/blob/main/docs/api.md)。