# codex-skill

Reusable Codex skills maintained by `kingo0807`.

## Sipeed ImageGen Config

`sipeed-imagegen-config` configures and verifies Codex built-in image generation on Windows through the OpenAI-compatible relay at `https://ai.corp.sipeed.com/v1`.

### Install

Send this prompt to Codex:

```text
请用 $skill-installer 从 https://github.com/kingo0807/codex-skill/tree/main/skills/sipeed-imagegen-config 安装这个 skill。
```

The installed skill is normally available on the next turn. If it does not appear, restart Codex.

### Use

```text
$sipeed-imagegen-config 请在这台 Windows 设备上安全配置并验证 Sipeed 中转生图。
```

If the Windows User-scope `OPENAI_API_KEY` is absent, the skill pauses and asks the user to enter the relay key locally through a secure PowerShell prompt. The key must never be pasted into chat or committed to this repository.

### Important boundaries

- The skill keeps `OPENAI_API_KEY` as the provider credential environment variable.
- It never places credentials in `config.toml`, scripts, logs, prompts, or repository files.
- It does not set the conversational model to `gpt-image-2`; Codex image generation selects the image model separately.
- The actor-authorization marker is an implementation-level compatibility path and is verified against the installed Codex version before success is reported.
- Configuration changes remain subject to the user's local Codex permissions and approval policy.

Official references: [Build skills](https://learn.chatgpt.com/docs/build-skills), [advanced configuration](https://learn.chatgpt.com/docs/config-file/config-advanced), and [image generation](https://learn.chatgpt.com/docs/image-generation).
