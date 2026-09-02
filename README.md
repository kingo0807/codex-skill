# codex-skill

由 `kingo0807` 维护的可复用 Codex Skill 集合。

## Sipeed 中转生图配置

`sipeed-imagegen-config` 用于在 Windows 上通过 `https://ai.corp.sipeed.com/v1` 这个 OpenAI 兼容中转，配置并验证 Codex 的内置图像生成功能。

### 安装

在 Codex 中发送下面这句话：

```text
请用 $skill-installer 从 https://github.com/kingo0807/codex-skill/tree/main/skills/sipeed-imagegen-config 安装这个 skill。
```

安装完成后，Skill 通常会在下一轮对话中可用；如果没有出现，请重启 Codex。

### 使用（不需要编程基础）

安装完成后，直接对 Codex 说一句话即可：

```text
帮我配置 Sipeed 生图，直接自动完成，不要向我索取密钥或命令。
```

也可以明确调用：

```text
$sipeed-imagegen-config 请直接自动配置并验证 Sipeed 生图，不要让我输入密钥。
```

要实现真正的“一句话、零输入”，电脑必须已经由管理员、安装包或系统策略预先配置好 `OPENAI_API_KEY`，并设置非秘密标记 `SIPEED_RELAY_READY=1`，表示该密钥允许用于 Sipeed 中转。公开 GitHub 仓库不会内置共享密钥。

Skill 会自动检查 Codex、备份并修改用户配置，然后验证生图功能。它绝不会弹出密钥输入框、要求你打开 PowerShell、让你编辑 TOML，或要求你把密钥发到聊天中。

如果电脑没有预先配置密钥和标记，Skill 会直接停止并提示“未检测到管理员预置的 Sipeed 中转凭据，无法继续”，不会尝试猜测、复制或索取密钥。这个标记可以防止电脑里原本用于 OpenAI 官方服务的同名密钥被误发给其他域名。

### 重要边界

- Skill 固定使用 `OPENAI_API_KEY` 作为提供商凭据环境变量。
- Skill 绝不会把凭据写入 `config.toml`、脚本、日志、提示词或仓库文件。
- Skill 不会把对话主模型设置为 `gpt-image-2`；Codex 的图像生成路径会单独选择图像模型。
- actor-authorization 标记属于实现级兼容路径；只有根据当前安装的 Codex 版本验证通过后，Skill 才会报告成功。
- 配置修改仍受用户本机 Codex 的权限和审批策略约束。

官方参考：[创建 Skill](https://learn.chatgpt.com/docs/build-skills)、[高级配置](https://learn.chatgpt.com/docs/config-file/config-advanced) 和 [图像生成](https://learn.chatgpt.com/docs/image-generation)。
