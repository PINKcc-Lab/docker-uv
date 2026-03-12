import os
import pandas as pd
from pathlib import Path
import sys
import torch
def main():
    print(f"Python version: {sys.version}")
    print(f"PyTorch version: {torch.__version__}")
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU: {'Available' if torch.cuda.is_available() else 'Not Available'}")
    
if __name__ == "__main__":
    main()