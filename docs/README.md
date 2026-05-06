# 🧬 Science Repo Template

A reproducible scientific computing environment powered by **uv** and **Docker**. This setup ensures that your data science experiments run exactly the same way on your laptop, a colleague's machine, or a high-performance computing cluster.

## 🚀 Quick Start

### 0. Knowledge about Docker and UV

We made a small powerpoint to quickly understand the interest of Docker + UV: [see it here](Reproducibility.pdf)  
You can read documentation we made to quickly be able to use those tools, it's very easy :)

- [📦 UV Doc](UV.md)
- [🐳 DOCKER Doc](docker.md)
- [🤖 Run on Jean-Zay Doc](jean-zay.md)

### 1. Prerequisites

Ensure you have the following installed:

- **Docker & Docker Compose**: to execute the code in a reproducible environment.
  - **macOS:** `brew install docker` (via Homebrew) or [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - **Windows:** Download [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - **Linux:** `curl -fsSL https://get.docker.com | sh` (Ubuntu/Debian)
- **uv** [Optionnal] If you need to manage libraries (only for dev purposes) : `curl -LsSf https://astral.sh/uv/install.sh | sh`)

### 2. Launch the Environment

Build and start the containerized application:

```bash
docker compose up --build
```

💡 **Tips**  
If you want to make the script run in background because it will run for a long time, you can add `-d` to the command to detach the terminal. It will run until the end even if you close the terminal.

```bash
docker compose up --build -d
```

Then retrieve logs with:

```bash
docker compose logs -f
```

# 🚀 GPU & CPU Execution Guide

This project is designed to be portable. It can run on a standard laptop (CPU mode) or a high-performance workstation (GPU mode) without changing any code or Dockerfiles.

⚠️ To use the GPU, your host machine must have:

1. **NVIDIA Hardware:** A CUDA-compatible GPU.
2. **NVIDIA Drivers:** Installed on the Host OS.
3. **NVIDIA Container Toolkit:** This is the bridge between Docker and your GPU.

- _Windows:_ Included in Docker Desktop.
- _Linux:_ Must be installed manually (`sudo apt install nvidia-container-toolkit`).

Your `.env` file controls which profile is active by default.

```bash
# cpu for CPU-only, gpu for NVIDIA/AMD
COMPOSE_PROFILES=cpu
```

Then

```bash
# Follow COMPOSE_PROFILES in .env
docker compose up --build

# Or explicitly
docker compose --profile cpu up --build
```

## 📦 Python & Dependency Management

This project uses **uv** for lightning-fast, deterministic builds.  
⚠️ If you want to manage dependencies you need to install [UV](https://docs.astral.sh/uv/getting-started/installation/).

- ### Update Python Version
You can edit pyproject.toml and update python version on the fly.
```toml
[project]
name = "science-repo"
...
requires-python = "==3.13.*"
...
```
Then update uv.lock with
```bash
uv lock
docker compose build
```

- ### Add New Libraries

To add a library (e.g., `scipy` or `torch`), always do it through **uv** to ensure your `uv.lock` stays updated:

```bash
uv add <package_name> --no-sync
docker compose build
```

💡 **Tips:** `--no-sync` avoid installing libraries locally in .venv. It will only update pyproject.toml and uv.lock. Usefull to avoid duplication of installation and save disk space. Do not use this parameter if you are coding in local without launching containers.

- ### Remove Libraries

```bash
uv remove <package_name>
```

- ### Usefull to know
  To add a git repository as a dependencies execute this command

```bash
uv add "<package-name> @ <git-url>"

# Exemple
uv add "streamlit-drawable-canvas @ git+https://github.com/Sourav-Ganguli/streamlit-drawable-canvas.git"
```

## 📂 Project Structure

| File/Folder      | Description                                                    |
| ---------------- | -------------------------------------------------------------- |
| `src/`           | Your Python source code (mapped to the container via volumes). |
| `data/`          | Local data directory (ignored by git, mounted in Docker).      |
| `pyproject.toml` | High-level dependencies and project metadata.                  |
| `uv.lock`        | The exact version manifest for reproducibility.                |
| `Dockerfile`     | Instructions to build the optimized image.                     |
| `.env`           | Environment variables for Docker Compose and the application.  |
