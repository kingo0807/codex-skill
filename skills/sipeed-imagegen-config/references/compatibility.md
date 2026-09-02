# 兼容性约定

在编辑提供商配置或诊断工具可见性之前，立即读取本文件。

## 已知兼容的结构

新建提供商时使用 `sipeed` 作为 ID。如果当前已选的自定义提供商已经指向同一个中转，则保留原 ID，只更新原表。

```toml
model_provider = "sipeed"

[model_providers.sipeed]
name = "OpenAI"
wire_api = "responses"
requires_openai_auth = false
base_url = "https://ai.corp.sipeed.com/v1"
env_key = "OPENAI_API_KEY"
http_headers = { "x-openai-actor-authorization" = "local-relay" }

[features]
image_generation = true
```

actor-authorization 的值是固定的非秘密客户端能力标记，不替代 Bearer 鉴权。中转应忽略或剥离该 Header，并使用 `OPENAI_API_KEY` 提供的 Bearer Token 对请求进行鉴权。

不要将 `[model_providers.<id>.auth]` 与 `env_key` 或 `requires_openai_auth` 同时使用。只删除目标提供商的命令鉴权表及其鉴权辅助程序引用。

## 与版本有关的行为

actor-authorized 图像路径属于实现级兼容机制，并不代表每个 OpenAI 兼容提供商都支持 Codex 内置图像生成。必须在当前安装版本上逐项验证：

- 自定义提供商被接受，且其 Responses 端点正常工作。
- `requires_openai_auth` 为 false 时，静态 actor 标记非空。
- 已启用图像生成功能，且没有重复的 `[features]` 表。
- 所选对话模型支持工具调用和当前门控要求的模态。
- `codex.exe exec` 实际暴露了内置图像生成工具。
- 中转接受图像生成请求，并返回由 Codex 保存到本地的 PNG。

App、扩展和 CLI 版本可能表现不同。CLI 成功不能证明当前运行中的 App 进程继承了新创建的 User 环境变量。配置后必须完全重启 App 并新建任务。

## 端点拼接

配置的基础地址已经以 `/v1` 结尾。应探测：

```text
https://ai.corp.sipeed.com/v1/models
https://ai.corp.sipeed.com/v1/responses
```

绝不能拼出 `/v1/v1/models` 或 `/v1/v1/responses`。

## 失败边界

如果当前安装版本在此配置下不暴露内置工具，报告实际版本、观察到的门控和已经完成的端点检查。不要修改二进制、切换官方提供商，也不要静默实现 Python、Node 或 MCP 备选方案。

官方参考：

- https://learn.chatgpt.com/docs/config-file/config-advanced
- https://learn.chatgpt.com/docs/config-file/config-reference
- https://learn.chatgpt.com/docs/image-generation
