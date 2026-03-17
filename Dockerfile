# Use the official uv image
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Re-declare ARG after FROM to use it in the build
ARG PYTHON_VERSION=3.12

WORKDIR /app

# 1. Configuration for performance and volume compatibility
ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_PREFERENCE=only-managed \
    UV_PROJECT_ENVIRONMENT=/app/.venv

# 2. Install Python version early
RUN uv python install ${PYTHON_VERSION}

# 3. Layer Caching
COPY pyproject.toml ./pyproject.toml
COPY uv.lock ./uv.lock
RUN uv sync --frozen --no-install-project

# 4. Copy the rest of the project
COPY src/ ./src/
COPY docs/ ./docs/

# Place the virtualenv binaries in the PATH
ENV PATH="/app/.venv/bin:$PATH"

# 5. The "Repair & Run" Command
# 'uv sync' here fixes the host-link issue if the volume is mounted.
CMD ["sh", "-c", "uv sync && uv run src/main.py"]