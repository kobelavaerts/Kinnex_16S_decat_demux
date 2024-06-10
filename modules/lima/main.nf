

process lima {
    publishDir "./results_lima", pattern: "**", mode: "copy"

    input:
    // path(bamfiles)
    tuple val(meta), path(bamfiles), path(samplesheet)
    path(kinex_primer_reference)
    // val(log_skera)


    output:
    tuple val(meta), path("**HiFi.*.bam"), emit: lima_bams
    path ("lima_output/lima_run-log.txt"), emit: lima_log
    // counts, rapport, summary (global metrics)

    
    script:
    """
    ${params.LIMA_PATH} \
    ${bamfiles} \
    ${kinex_primer_reference} \
    lima_results/HiFi.bam \
    --hifi-preset ASYMMETRIC \
    --split-named \
    --biosample-csv ${samplesheet} \
    --split-subdirs \
    --num-threads ${params.nthr_lima} \
    --log-level ${meta.log_lima} \
    --log-file lima_results/lima_run-log.txt"

    """

    // cmd="${LIMA_PATH} \
    // ${skera_results}/${movie}.skera.bam \
    // ${reference}/Kinnex16S_384plex_primers/Kinnex16S_384plex_primers.fasta \
    // ${lima_results}/HiFi.bam \
    // --hifi-preset ASYMMETRIC \
    // --split-named \
    // --biosample-csv ${inputs}/${samplesheet} \
    // --split-subdirs \
    // --num-threads ${nthr_lima} \
    // --log-level ${log_lima} \
    // --log-file ${lima_results}/lima_run-log.txt"

    stub:
    """
    mkdir lima_output
    touch lima_output/HiFi.Kinnex16S_Fwd_06--Kinnex16S_Rev_28.bam
    touch lima_output/lima_run-log.txt
    """
}