# Runs the Python MCP server directly (streamable-http + OAuth layer).
# The upstream Dockerfile wrapped the tool in supergateway with NO auth,
# leaving /mcp publicly accessible — do not revert to it.
FROM python:3.14-slim
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    MCP_TRANSPORT=streamable-http
WORKDIR /app
COPY pyproject.toml README.md ./
COPY src ./src
RUN pip install --no-cache-dir .
# Non-root user; needs a writable home for the ~/.cache session-token cache.
RUN useradd --create-home --shell /usr/sbin/nologin app
USER app
ENV HOME=/home/app
# Railway injects PORT; server binds 0.0.0.0:$PORT
CMD ["cronometer-api-mcp"]
