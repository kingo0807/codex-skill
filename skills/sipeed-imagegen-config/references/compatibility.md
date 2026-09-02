# Compatibility contract

Read this file immediately before editing provider configuration or diagnosing tool visibility.

## Known-compatible shape

For a newly created provider, use `sipeed` as the ID. If an already selected custom provider targets the same relay, preserve its existing ID and update that table instead.

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

The actor-authorization value is a fixed, non-secret client capability marker. It does not replace Bearer authentication. The relay should ignore or strip that header and authenticate the request through the Bearer token supplied from `OPENAI_API_KEY`.

Do not combine `[model_providers.<id>.auth]` with `env_key` or `requires_openai_auth`. Remove only the target provider's command-auth table and its authentication-helper references.

## Version-sensitive behavior

The actor-authorized image path is an implementation-level compatibility mechanism rather than a general promise that every OpenAI-compatible provider supports Codex built-in image generation. Verify all of these on the installed version:

- The custom provider is accepted and its Responses endpoint works.
- The static actor marker is non-empty while `requires_openai_auth` is false.
- The image-generation feature is enabled without a duplicate `[features]` table.
- The selected conversational model supports tool calls and the modalities required by the current gate.
- The built-in image-generation tool is actually exposed to `codex.exe exec`.
- The relay accepts the image-generation request and returns a PNG that Codex saves locally.

App, extension, and CLI builds can expose different behavior. A CLI success does not prove that a currently running App process inherited a newly created User environment variable. Require a full App restart and a new task after configuration.

## Endpoint construction

The configured base URL already ends in `/v1`. Probe:

```text
https://ai.corp.sipeed.com/v1/models
https://ai.corp.sipeed.com/v1/responses
```

Never construct `/v1/v1/models` or `/v1/v1/responses`.

## Failure boundary

If the installed version does not expose the built-in tool with this configuration, report the actual version, gate observation, and completed endpoint checks. Do not patch the binary, switch to the official provider, or silently implement a Python, Node, or MCP fallback.

Official references:

- https://learn.chatgpt.com/docs/config-file/config-advanced
- https://learn.chatgpt.com/docs/config-file/config-reference
- https://learn.chatgpt.com/docs/image-generation
