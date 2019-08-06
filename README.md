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
Put uri to our workflows here.

## Contributing
We invite anybody to contribute to the UMCU Genetics Nextflow Modules repository. If you would like to contribute please use the following procedure:
- Fork the repository
- Commit the changes to your fork
- Submit a pull request

The pull request will be reviewed and included as fast as possible.

### Contributing guidelines
- Use the `tool/version/command.nf` folder structure of this repository.
- Use the original tool version numbering
- Use CamelCase for tool and process names
- Use lowercase with words separated by underscores for params, inputs, outputs and script.
- All input and output identifiers should reflect their conceptual identity. Use informative names like unaligned_sequences, reference_genome, phylogeny, or aligned_sequences instead of foo_input, foo_file, result, input, output, and so forth.
- Use the following patterns for optional input (parameters) and output :
    - Input: https://github.com/nextflow-io/patterns/blob/master/docs/optional-input.adoc
    - Output: https://github.com/nextflow-io/patterns/blob/master/docs/optional-output.adoc
