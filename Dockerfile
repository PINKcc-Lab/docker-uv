# Use the OFFICIAL uv image with a dynamic Python version
FROM astral/uv:python3.12-bookworm-slim
ARG PYTHON_VERSION

# Set the working directory
WORKDIR /app

# Optimize uv for Docker
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# 1. Install dependencies
RUN uv python install ${PYTHON_VERSION}
COPY pyproject.toml uv.lock* ./
RUN uv sync --no-install-project --no-dev --python ${PYTHON_VERSION}

# 2. Copy the rest of the project
COPY src/ ./src/
COPY .env ./ 
COPY config.yaml* ./
COPY docs/ ./docs/

# 3. Final sync to install the project
RUN uv sync --no-dev --python ${PYTHON_VERSION}

# Place the virtualenv binaries in the PATH
ENV PATH="/app/.venv/bin:$PATH"

# Run the main script
CMD ["python", "src/main.py"]