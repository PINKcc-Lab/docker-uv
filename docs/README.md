# 🧬 Science Repo Template

A reproducible scientific computing environment powered by **uv** and **Docker**. This setup ensures that your data science experiments run exactly the same way on your laptop, a colleague's machine, or a high-performance computing cluster.

## 🚀 Quick Start

### 0. Knowledge about Docker and UV
You can read documentation we made to quickly be able to use those tools, it's very easy :)   

- [📦 UV Doc](UV.md)  
- [🐳 DOCKER Doc](docker.md)  

### 1. Prerequisites

Ensure you have the following installed:

* **Docker & Docker Compose**
    * **macOS:** `brew install docker` (via Homebrew) or  [Docker Desktop](https://www.docker.com/products/docker-desktop)
    * **Windows:** Download [Docker Desktop](https://www.docker.com/products/docker-desktop)
    * **Linux:** `curl -fsSL https://get.docker.com | sh` (Ubuntu/Debian)
* **uv** (Recommended for local development: `curl -LsSf https://astral.sh/uv/install.sh | sh`)

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



## 📦 Dependency Management

This project uses **uv** for lightning-fast, deterministic builds.

### Adding New Libraries

To add a library (e.g., `scipy` or `torch`), always do it through **uv** to ensure your `uv.lock` stays updated:

1. **Locally (Recommended):**
```bash
uv add <package_name>
docker compose build

```


2. **Via Docker (If uv isn't installed locally):**
```bash
docker compose run --rm science-app uv add <package_name>

```

## 📂 Project Structure

| File/Folder | Description |
| --- | --- |
| `src/` | Your Python source code (mapped to the container via volumes). |
| `data/` | Local data directory (ignored by git, mounted in Docker). |
| `pyproject.toml` | High-level dependencies and project metadata. |
| `uv.lock` | The exact version manifest for reproducibility. |
| `Dockerfile` | Instructions to build the optimized Python 3.12 image. |
| `.env` | Environment variables for Docker Compose and the application. |
| `config.yaml` | Application parameters and constants. |


# 🚀 GPU & CPU Execution Guide

This project is designed to be portable. It can run on a standard laptop (CPU mode) or a high-performance workstation (GPU mode) without changing any code or Dockerfiles.

## 📋 Prerequisites

To use the GPU, your host machine must have:

1. **NVIDIA Hardware:** A CUDA-compatible GPU.
2. **NVIDIA Drivers:** Installed on the Host OS.
3. **NVIDIA Container Toolkit:** This is the bridge between Docker and your GPU.
* *Windows/Mac:* Included in Docker Desktop.
* *Linux:* Must be installed manually (`sudo apt install nvidia-container-toolkit`).

## ⚙️ Configuration

We use environment variables and Docker profiles to manage execution modes.

### 1. The `.env` File

Your `.env` file controls which profile is active by default.

```bash
# Set to 'cpu' for laptops/Macs, 'gpu' for servers, 'mps' for mac amd chips
COMPOSE_PROFILES=cpu

# Set the Python version
PYTHON_VERSION=3.13

```

## 🛠 Usage

### Mode A: CPU (Default)

Use this for development, testing, or running on Mac/Non-NVIDIA hardware.

```bash
# If COMPOSE_PROFILES=cpu is in .env
docker compose up --build

# Or explicitly
docker compose --profile cpu up --build

```

### Mode B: GPU Acceleration

Use this for training models or heavy scientific computations.

```bash
# If COMPOSE_PROFILES=gpu is in .env
docker compose up --build

# Or explicitly
docker compose --profile gpu up --build

```