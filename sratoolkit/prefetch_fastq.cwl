#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
doc: |
  Worfklow combining an SRA fetch from NCBI with a fastq-dump cmd

requirements:
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  sra_accession: string

steps:
  prefetch:
    in:
      accession: sra_accession
    out:
      - sra_file
    run: ./prefetch.cwl

  fastq_dump:
    in:
      sra_file: prefetch/sra_file
      split_files:
        default: true
    out:
      - all_fastq_files
      - fastq_file_1
      - fastq_file_2
    run: ./fastq_dump.cwl

outputs:
  fastq_files:
    type: File[]
    outputSource: fastq_dump/all_fastq_files
    format: edam:format_1931 # FASTQQ
  fastq_file_1:
    type: File
    outputSource: fastq_dump/fastq_file_1
    format: edam:format_1931 # FASTQ
  fastq_file_2:
    type: File?
    outputSource: fastq_dump/fastq_file_2
    format: edam:format_1931 # FASTQ

$namespaces:
  edam: http://edamontology.org/
$schemas:
  - http://edamontology.org/EDAM_1.18.owl