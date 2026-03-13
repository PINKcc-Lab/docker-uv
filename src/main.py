import os
import sys

import torch

os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"


def main():
    print(f"Python version: {sys.version}")
    print(f"PyTorch version: {torch.__version__}")
    print(
        f"GPU: {'Available CUDA' + torch.version.cuda if torch.cuda.is_available() else 'Not Available'}"
    )
    print(f"MPS (Apple Silicon) support: {'Available' if torch.backends.mps.is_available() else 'Not Available'}")

    device = (
        "cuda"
        if torch.cuda.is_available()
        else "mps"
        if torch.backends.mps.is_available()
        else "cpu"
    )
    print(f"Using device: {device}")


if __name__ == "__main__":
    main()
