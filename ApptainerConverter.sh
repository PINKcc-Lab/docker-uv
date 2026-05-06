#!/usr/bin/env bash
set -euo pipefail

SIF_NAME="output"
DOCKERFILE="Dockerfile"
IMAGE_TAG="apptainer-build-tmp"
BUILD_ARGS=()

# ─── Parse flags ──────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)     SIF_NAME="$2";                       shift 2 ;;
    -f|--file)       DOCKERFILE="$2";                     shift 2 ;;
    --build-arg)     BUILD_ARGS+=("--build-arg" "$2");    shift 2 ;;
    -h|--help)
      echo "Usage: $0 [-o|--output <sif_name>] [-f|--file <dockerfile>] [--build-arg KEY=VALUE]..."
      echo ""
      echo "  -o, --output   Output SIF name (default: output)"
      echo "  -f, --file     Dockerfile to use (default: Dockerfile)"
      echo "  --build-arg    Build argument (repeatable, e.g. --build-arg FOO=bar)"
      exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ ! -f "$DOCKERFILE" ]]; then
  echo "Error: Dockerfile '${DOCKERFILE}' not found." >&2
  exit 1
fi

echo "Dockerfile  : ${DOCKERFILE}"
echo "Output SIF  : ${SIF_NAME}.sif"
if [[ ${#BUILD_ARGS[@]} -gt 0 ]]; then
  echo "Build args  : ${BUILD_ARGS[*]}"
fi
echo ""

# ─── 1. Setup buildx builder (idempotent) ─────────────────────────────────────
docker buildx create --name multiarch-builder --use 2>/dev/null || docker buildx use multiarch-builder
docker buildx inspect --bootstrap

# ─── 2. Build the Apptainer tool image ────────────────────────────────────────
docker buildx build \
  --platform linux/amd64 \
  --load \
  -t apptainer-tool \
  -f ApptainerConverter.dockerfile .

# ─── 3. Build the target image for amd64 ──────────────────────────────────────
docker buildx build \
  --platform linux/amd64 \
  --load \
  -t "${IMAGE_TAG}:latest" \
  -f "${DOCKERFILE}" \
  "${BUILD_ARGS[@]+"${BUILD_ARGS[@]}"}" \
  .

# ─── 4. Convert to .sif ───────────────────────────────────────────────────────
docker run --privileged --rm \
  --platform linux/amd64 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)":/data \
  apptainer-tool \
  apptainer build "/data/${SIF_NAME}.sif" "docker-daemon://${IMAGE_TAG}:latest"

# ─── 5. Cleanup tmp image ─────────────────────────────────────────────────────
docker rmi "${IMAGE_TAG}:latest" 2>/dev/null && echo "Cleaned up temporary image."

echo ""
echo "Done! SIF image available at: $(pwd)/${SIF_NAME}.sif"