# Scrapling MCP on Railway

This repository is a minimal Railway-compatible wrapper for
[D4Vinci/Scrapling](https://github.com/D4Vinci/Scrapling). It deliberately
does not modify Scrapling source code. Its only runtime change replaces the
upstream image's `uv run scrapling` entrypoint with the Streamable HTTP MCP
server command.

## Railway configuration

Build this repository with the included `Dockerfile`. Railway must provide a
`SCRAPLING_MCP_AUTH_TOKEN` service variable. Keep that value in Railway only;
do not commit it to this repository or place it in a Docker build argument.

The container listens on `0.0.0.0:$PORT` and serves MCP at `/mcp`.
Clients must include:

```http
Authorization: Bearer <SCRAPLING_MCP_AUTH_TOKEN>
```

The unauthenticated endpoint should return `401 Unauthorized`.

## Upgrade strategy

The Dockerfile follows `ghcr.io/d4vinci/scrapling:latest` by default. For a
controlled Scrapling upgrade, change `SCRAPLING_IMAGE` to a tested upstream
tag, deploy, then rerun the unauthenticated, MCP initialize/tool-listing,
lightweight fetch, and browser-fetch smoke tests before promoting it.

## Local check

```bash
docker build -t scrapling-railway-mcp .
docker run --rm -e PORT=8000 -e SCRAPLING_MCP_AUTH_TOKEN=local-test-token \
  -p 8000:8000 scrapling-railway-mcp
```

No secret should be passed as a command-line argument or committed to source
control.
