import os
import pandas as pd
from pathlib import Path

def main():
    # Grab the path from the .env file (via Docker)
    data_path = os.getenv("INPUT_CSV", "data/ex.csv")
    
    print("--- Running Scientific Analysis ---")
    if Path(data_path).exists():
        df = pd.read_csv(data_path)
        print(f"Successfully loaded {len(df)} rows from {data_path}")
    else:
        print(f"Warning: File not found at {data_path}")

if __name__ == "__main__":
    main()