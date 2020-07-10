# Nextflow Modules
UMCU Genetics Nextflow modules

## Getting started with Nextflow
- Website: https://www.nextflow.io/
- Docs: https://www.nextflow.io/docs/latest/index.html
- DSL2 and Modules docs: https://www.nextflow.io/docs/edge/dsl2.html#modules
- Useful resources:
  - https://github.com/nextflow-io/patterns
  - https://github.com/oliverSI/GATK4_Best_Practice
  - https://github.com/SciLifeLab/Sarek

## Nextflow workflows
- [DxNextflowWorkflows](https://github.com/UMCUGenetics/DxNextflowWorkflows)

## Contributing
We invite anybody to contribute to the UMCU Genetics Nextflow Modules repository. If you would like to contribute please use the following procedure:
- Fork the repository
- Commit the changes to your fork
- Submit a pull request

The pull request will be reviewed and included as fast as possible.

### Coding guidelines
See `utils/template.nf` for a process template which uses the following guidelines.
- Use the `Tool/version/Command.nf` folder structure of this repository.
- Use the original tool version numbering
- Use CamelCase for tool, command and process names
- Use lowercase with words separated by underscores for params, inputs, outputs and scripts.
- Use 4 spaces per indentation level.
- All input and output identifiers should reflect their conceptual identity. Use informative names like unaligned_sequences, reference_genome, phylogeny, or aligned_sequences instead of foo_input, foo_file, result, input, output, and so forth.
- Define two labels for each process, containing toolname, version and command separated by an underscore.
    - BWA_0.7.17
    - BWA_0.7.17_MEM
- Define a tag to each process, containing toolname, command, sample_id and/or rg_id.
    - {"BWA MEM ${sample_id} - ${rg_id}"}
- Set a (hosted) container for each process.
- Add 'set -euo pipefail' to each process.
    - `shell = ['/bin/bash', '-euo', 'pipefail']`
- Do not define any runtime settings like cpus, memory and time.
- Set process parameters on include:
   - `include process from 'path/to/process.nf' params(optional: '')`
- Use separate process input channels as much as possible. Use tuples for linked inputs only. 
    ```
    input:
          val(analysis_id)
          tuple(sample_id, path(bam), path(bai))
    ```
- Define named process output channels. This ensures that outputs can be referenced in external scope by their respective names. Indicate whether an output channel is optional. 
    ```
    output:
          path("my_file.txt", emit: my_file)
          path("my_optional_file.txt",  optional: my_optional_file, emit: my_optional_file)
    ```
- Use `params` for resource files, for example `genome.fasta`, `database.vcf`.

## GUIX
1. Creating squashfs immage
```bash
guixr pack -f squashfs -RR -S /bin=bin <name of tool you need> bash glibc-utf8-locales tzdata coreutils procps grep sed bootstrap-binaries
```
2. Copy .squashfs to appropriate directory and rename `<Tool>_<version>.squashfs`.
3. Add container to process: `container = '<Tool>_<version>.squashfs'`

## Nextflow config for Utrecht HPC
```
profiles {
    sge {
        process {
            executor = 'sge'
            queue = 'all.q'
            errorStrategy = 'finish'
        }
    }
    slurm {
        process {
            executor = 'slurm'
            queue = 'cpu'
            errorStrategy = 'finish'
        }
    }
}

singularity {
    enabled = true
    runOptions = '-B /hpc:/hpc -B $TMPDIR:$TMPDIR'
    autoMounts = true
}

```
