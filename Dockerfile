ARG SCRAPLING_IMAGE=ghcr.io/d4vinci/scrapling:latest
FROM ${SCRAPLING_IMAGE}

# The upstream image starts `uv run scrapling` by default. Override that
# entrypoint so Railway runs the HTTP MCP server and expands its injected PORT.
EXPOSE 8000
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["exec uv run scrapling mcp --http --host 0.0.0.0 --port ${PORT:-8000}"]
