#!/bin/bash
set -euo pipefail

workflow_path='/hpc/diaggen/users/lonneke/github/DxNextflowRNA/NextflowModules'

# Set input and output dirs
input=`realpath $1`
output=`realpath $2`
email=$3

mkdir -p $output && cd $output
mkdir -p log

if ! { [ -f 'workflow.running' ] || [ -f 'workflow.done' ] || [ -f 'workflow.failed' ]; }; then
touch workflow.running
echo "check directory for output: ${output}"

export JAVA_HOME='/hpc/diaggen/software/tools/jdk-18.0.2.1/'  # change java version 
export NXF_JAVA_HOME='/hpc/diaggen/software/tools/jdk-18.0.2.1/'  # change java vesion of nextflow

sbatch <<EOT
#!/bin/bash
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --mem 10G
#SBATCH --gres=tmpspace:10G
#SBATCH --job-name Nextflow_RNASeq
#SBATCH -o log/slurm_nextflow_rnaseq.%j.out
#SBATCH -e log/slurm_nextflow_rnaseq.%j.err
#SBATCH --mail-user $email
#SBATCH --mail-type FAIL
#SBATCH --account=diaggen

/hpc/diaggen/software/development/DxNextflowRNA/tools/nextflow run /hpc/diaggen/users/lonneke/github/DxNextflowRNA/NextflowModules/main.nf  \
-c /hpc/diaggen/users/lonneke/github/DxNextflowRNA/NextflowModules/nextflow.config -resume -ansi-log false -profile slurm \
--input $input \
--outdir $output \
--email $email
 
if [ \$? -eq 0 ]; then
    echo "Nextflow done."

    echo "RNA Trimgalore test workflow completed successfully."
    rm workflow.running
    touch workflow.done

    exit 0
else
    echo "Nextflow failed"
    rm workflow.running
    touch workflow.failed

    exit 1
fi
EOT
else
echo "Workflow job not submitted, please check $output for 'workflow.status' files."
fi
