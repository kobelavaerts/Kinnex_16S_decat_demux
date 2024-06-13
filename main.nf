#!/usr/bin/env nextflow




include {skera_split;} from './modules/skera'

include {lima;} from './modules/lima'

include {bam2fastq;} from './modules/bam2fastq'


workflow {
    // inintiate channels for skera
    input_bam_ch = channel.fromPath(params.bampath, checkIfExists: true)
    input_bam_ch | view

    reference_mas_seq_primers_ch = channel.fromPath(params.reference_mas_seq_primers)

    // create meta map to pass through meta info (movie, log settings, etc)
    meta = [:]
    meta.movie = params.movie
    meta.log_skera = params.log_skera
    meta.log_lima = params.log_lima

    println meta

    // movie_ch = channel.value(params.movie)
    // skera_input = movie_ch | combine(input_bam_ch)

    // skera_input = tuple(meta, input_bam_ch )
    // skera_input = channel.of(meta) | combine(input_bam_ch)

    // create input for skera
    skera_input = input_bam_ch \
        | map{it -> tuple(meta, it)}

    skera_input | view


    //  run skera
    skera_split( skera_input, reference_mas_seq_primers_ch)


    // create channel samplesheet
    samplesheet_ch = channel.fromPath(params.samplesheet_path, checkIfExists: true)
    lima_input = skera_split.out.skera_bams \
        | combine(samplesheet_ch)

    lima_input | view
    reference_kinex_primers_ch = channel.fromPath(params.reference_kinex_primers)


    // run lima
    lima(lima_input, reference_kinex_primers_ch)


    // bam2fastq
    // samplesheet
    sample_info = samplesheet_ch \
        | splitCsv(header:true) \
        | map{ row -> tuple(row.Barcode, row.'Bio Sample') }

    // sample_info | view

    lima_output_only_bams = lima.out.lima_bams \
        | map{ meta, bams -> bams}

    bam2fastq_input = lima_output_only_bams \
        | flatten \
        | combine(sample_info)
        | filter { bams, barcode, sample -> bams =~ /\/HiFi.${barcode}.bam/}

    bam2fastq_input | view

    // bam2fastq_input_edit = bam2fastq_input \
    //     | map { it -> tuple(meta, it)} \
    //     | map { it.meta.barcode = it.barcode}

    
    // bam2fastq_input_edit | view

    bam2fastq(bam2fastq_input)
    // get error for bam2fasrtq
    // similar to the following https://github.com/PacificBiosciences/pbbioconda/issues/559

}