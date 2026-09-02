---
name: sipeed-imagegen-config
description: Configure and verify Codex built-in image generation through the Sipeed OpenAI-compatible relay on Windows. Use when the user asks to set up, repair, or validate Sipeed relay image generation in Codex; do not use for ordinary image generation requests.
---

# Sipeed ImageGen Config

Configure the current Windows device so Codex can use its built-in image-generation path through the Sipeed relay while preserving unrelated user settings.

## Fixed contract

- Relay base URL: `https://ai.corp.sipeed.com/v1`
- Credential environment variable: `OPENAI_API_KEY`
- Actor-authorization marker: `local-relay`
- Image model: `gpt-image-2`, selected by the image-generation path rather than as the conversational model

## Safety boundaries

- Never print, echo, log, record, or return the API key. Report only whether it exists.
- Never place the API key in TOML, a script, a command line, a prompt, a repository, or an HTTP header shown to the user.
- Do not automatically copy a credential from `auth.json` for use with a different network domain. If the Windows User-scope variable is absent, follow [the local secure-input procedure](references/windows-key-setup.md).
- Do not use Node, Python, or another credential helper for provider authentication.
- Do not modify a Codex binary, switch to an official provider as a workaround, or install an unrelated plugin or skill.
- Re-read every file immediately before editing it. Preserve unrelated settings and avoid duplicate TOML tables.
- Keep provider and authentication settings in the user-level Codex configuration. Do not put them in repository-local `.codex/config.toml`.
- Create a timestamped backup beside the user configuration before editing. Do not copy that backup into a repository or display its contents.
- Obey local filesystem, network, and approval boundaries. If permission is denied, report the exact blocked step rather than bypassing it.

## Configure and verify

1. Confirm the operating system is Windows. Locate the native `codex.exe`, report its version, and inspect its current CLI help or feature listing when needed.
2. Resolve `CODEX_HOME`; when unset, use the normal user Codex directory. Locate the user-level `config.toml` without assuming it already exists.
3. Check `OPENAI_API_KEY` in Process, User, and Machine scopes. Output only `true` or `false` for each scope. Never read the value into displayed output.
4. If the User-scope variable is missing, read [references/windows-key-setup.md](references/windows-key-setup.md), present that local PowerShell procedure, and wait for the user to confirm `OPENAI_API_KEY(User)=OK`. A running Codex process normally will not inherit the newly written value.
5. Load the User-scope key into memory without displaying it and probe the relay's `/models` and `/responses` endpoints. Do not enable verbose HTTP logging. Confirm that `/models` includes `gpt-image-2` and that `/responses` accepts a minimal request using a conversational model exposed by the relay.
6. Read the current user configuration and identify the selected `model_provider` and its exact table ID. If the selected custom provider already targets the Sipeed relay, minimally update that table. Otherwise create a `sipeed` provider and select it only after the endpoint probes succeed.
7. Read [references/compatibility.md](references/compatibility.md), then apply the known-compatible provider shape for the installed Codex version:
   - Use the exact base URL above; never append another `/v1`.
   - Set `wire_api = "responses"`, `requires_openai_auth = false`, and `env_key = "OPENAI_API_KEY"`.
   - Add only the fixed non-secret actor marker `x-openai-actor-authorization = "local-relay"`.
   - Remove command-backed `auth` from this provider because it conflicts with `env_key` and `requires_openai_auth`.
   - Merge `image_generation = true` into the existing `[features]` table or create that table once.
   - Preserve the user's conversational model when the relay exposes it. For validation, prefer `gpt-5.4` when the relay lists it; otherwise use another listed model that supports tool calls. Never set the conversational model to `gpt-image-2`.
8. Re-read the edited file and produce a redacted diff. Confirm that the TOML has no duplicate tables, no credential literals, no command auth for the target provider, and no Node-helper reference.
9. Locate the native executable rather than an npm or other wrapper. Start a fresh PowerShell child process, load the key from Windows User scope into that child without displaying it, and run `codex.exe exec` with the configured custom provider and the selected conversational model.
10. Give the diagnostic task this invariant: call the built-in image-generation tool exactly once to generate a white image with one centered blue circle; do not use shell, Python, SVG, Canvas, an MCP wrapper, or an external image tool as a substitute.
11. Treat validation as successful only when the built-in image-generation tool is visible, the call completes, a local PNG path is produced, and no command or Node authentication helper participates in the provider chain.
12. If the provider previously referenced `custom-provider-auth.cjs`, confirm all references are gone. Delete only that exact authentication-only helper, only when it is inside the resolved Codex user directory and no reference remains. Report the deletion.
13. If the installed Codex version no longer supports the actor-authorized image path, stop after reporting the observed gate difference. Describe a local MCP image wrapper only as an unimplemented fallback; do not install it without a new user request.

## Final report

Report only:

- Codex version and native executable path.
- Whether the User-scope variable exists and whether the current App process inherited it.
- The selected provider ID and whether `env_key` is active.
- Whether command auth and Node references are absent.
- Results for `/models`, `/responses`, built-in image generation, and the diagnostic PNG path.
- Files modified, backed up, or deleted.
- A reminder to fully exit Codex, including background processes, restart it, and open a new task using a tool-capable conversational model.

Never include the credential or an unredacted authentication payload in the report.
