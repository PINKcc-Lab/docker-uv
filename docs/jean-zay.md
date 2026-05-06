## Running on Jean-Zay

### 1. Build the Apptainer Image

Run the conversion script locally to package your Docker image into a `.sif` file compatible with Jean-Zay:

```bash
./ApptainerConverter.sh -o science-repo
```

Additional options:
| Flag | Description |
|------|-------------|
| `-h` | Print help |
| `-o <name>` | Output SIF filename (default: `output`) |
| `-f <Dockerfile>` | Use an alternate Dockerfile |
| `--build-arg KEY=VALUE` | Pass build arguments (repeatable) |

### 2. Transfer to Jean-Zay

Copy the generated image to your Jean-Zay home directory:

```bash
scp science-repo.sif <your_login>@jean-zay.idris.fr:~/science-repo.sif
```

> ⚠️ All following steps must be run **on Jean-Zay**.

### 3. Validate the Image

Jean-Zay requires images to be validated before use. If you've previously registered a version of this image, remove it first:

```bash
idrcontmgr rm science-repo.sif
```

Then register and validate the new image:

```bash
idrcontmgr cp science-repo.sif
```

To confirm the image is listed and ready:

```bash
idrcontmgr ls
```

### 4. Submit a Job

Create a Slurm job script (`job.sh`) and adapt the paths, time limit, and account to your project:

```bash
#!/bin/bash
#SBATCH --job-name=science-repo_%j
#SBATCH --output=logs/science-repo_%j.out
#SBATCH --error=logs/science-repo_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=10
#SBATCH --hint=nomultithread
#SBATCH --time=01:00:00
#SBATCH --account=<your_account>@v100
#SBATCH -C v100-32g

module purge
module load singularity/3.8.5

DATA_JZ=/lustre/fswork/projects/rech/<proj>/<login>/data
SRC_JZ=/lustre/fswork/projects/rech/<proj>/<login>/code/science-repo

cd ${SLURM_SUBMIT_DIR}

srun singularity exec --nv \
    --bind $DATA_JZ:/app/data \
    --bind $SRC_JZ/src:/app/src \
    $SINGULARITY_ALLOWED_DIR/science-repo.sif \
    /app/.venv/bin/python /app/src/main.py
```

Submit the job:

```bash
sbatch job.sh
```

Check its status:

```bash
squeue --me
```

Cancel a job:
```bash
scancel <job-id>
```