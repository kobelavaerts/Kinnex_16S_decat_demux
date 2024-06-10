
process skera_split {
    
    publishDir "./results_skera", pattern: "**", mode: "copy"



    input:
    // path(bamfiles)
    tuple val(meta), path(bamfiles)
    path(mas_seq_primers_reference)
    // val(log_skera)


    output:
    tuple val(meta), path("**${meta.movie}.skera.bam"), emit: skera_bams
    path ("skera_output/skera_run-log.txt"), emit: skera_log

    script:
    """
    ${params.SKERA_PATH} split \
    ${bamfiles} \
    ${mas_seq_primers_reference} \
    skera_output/${meta.movie}.skera.bam \
    --num-threads ${params.nthr_skera} \
    --log-level ${meta.log_skera} \
    --log-file skera_output/skera_run-log.txt
    """
    // script from Stephane (bash)
    // skera split \
    // ${inputs}/${adapterfolder}/${movie}.hifi_reads.${adapterfolder}.bam \
    // ${reference}/MAS-Seq_Adapter_v2/mas12_primers.fasta \
    // ${skera_results}/${movie}.skera.bam \
    // --num-threads ${nthr_skera} \
    // --log-level ${log_skera} \
    // --log-file ${skera_results}/skera_run-log.txt
    
    stub:
    """
    mkdir skera_output
    touch skera_output/${meta.movie}.skera.bam
    touch skera_output/skera_run-log.txt
    """
}