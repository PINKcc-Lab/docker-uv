# 🐳 The Docker Handbook for Scientists

## 1. Core Concepts: The "Ship" Analogy

To understand Docker, use the shipping container analogy:

* **Dockerfile:** The "Blueprint." A text file with instructions on how to build your environment.
* **Image:** The "Packed Container." A read-only snapshot created from your blueprint.
* **Container:** The "Live Ship." A running instance of your image where your code actually executes.
* **Docker Compose:** The "Fleet Manager." A tool to manage one or more containers (like your app + a database).

## 2. Essential Commands

You will use these 90% of the time:

| Command | Action | When to use it |
| --- | --- | --- |
| `docker compose up` | **Start** | Run your project and see the output. |
| `docker compose up --build` | **Rebuild & Start** | Use this after you change `pyproject.toml` or the `Dockerfile`. |
| `docker compose down` | **Stop** | Shut everything down and free up RAM. |
| `docker compose ps` | **Status** | See if your containers are running or crashed. |
| `docker compose logs -f` | **Watch** | Follow the "print" statements of your code in real-time. |

## 3. How Volumes Work (The "Magic" Link)

In your `docker-compose.yml`, you have a section called `volumes`:

```yaml
volumes:
  - ./src:/app/src

```

This **syncs** your local `src` folder with the container's `/app/src` folder.

* **Benefit:** You can edit code in your IDE (VS Code, PyCharm) and the container sees the changes **instantly** without needing a rebuild.
* **Note:** Changing `pyproject.toml` still requires a rebuild (`--build`) because libraries are installed into the image, not the volume.

## 4. Understanding your Dockerfile Layers

Docker builds in "layers." Each line in your Dockerfile is a layer. Docker caches these layers to save time.

1. **The Base:** `FROM astral/uv...` (Downloads the OS/Python).
2. **The Deps:** `COPY pyproject.toml ...` followed by `uv sync`. (Docker only reruns this if your dependencies change).
3. **The Code:** `COPY src/ ./src/`. (This changes often, so it's placed near the bottom).

**Rule of Thumb:** Always put the things that change *least* at the top of the Dockerfile.

## 5. Working Inside the Container

Sometimes you need to "go inside" the container to debug or run a one-off command.

**To open a terminal inside your running container:**

```bash
docker compose exec science-app /bin/bash

```

**To run a specific script inside the environment:**

```bash
docker compose run --rm science-app python src/analysis.py

```

## 6. Housekeeping (Freeing Disk Space)

Docker can eat up disk space quickly with old images and stopped containers. Every few weeks, run the "magic cleaning command":

```bash
docker system prune

```

*(This removes all stopped containers and unused networks. Add `-a` to remove old images too.)*

> **Next Step:** Your setup is now professional-grade. Would you like to see how to add a **PostgreSQL database** or a **Redis cache** to your `docker-compose.yml` to handle large datasets?