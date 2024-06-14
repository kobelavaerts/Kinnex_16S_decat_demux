

process bam2fastq {
    publishDir "${params.outdir}/results_bam2fastq", pattern: "**", mode: "copy"

    input:
    // path(bamfiles)
    // tuple val(meta), path(bamfiles), val(sample)
    tuple path(bamfiles), path(index), val(barcode), val(sample)


    output:
    tuple path("**.fastq.gz"), val(barcode), val(sample), emit: fastqz

    script:
    """
    bam2fastq \
    ${bamfiles} \
    --output ${sample} \
    --num-threads ${params.nthr_bam2fastq}

    """

// for bam in $(find ${lima_results} -name "*.bam"); do
// # rename sample from samplesheet 'Bio Sample'
// pfx=$(basename ${bam%.bam})
// bcpair=${pfx#HiFi.}
// biosample=$(grep ${bcpair} ${inputs}/${samplesheet} | \
//   dos2unix | cut -d, -f 2 | tr -d "\n")

// echo "${BAM2FASTQ_PATH} \
//     ${bam} \
//     --output ${fastq_results}/${biosample} \
//     --num-threads ${nthr_bam2fastq}" >> job.list
// done

// # execute job list in batches of \${nthr_bam2fastq_par}
// cmd="parallel -j ${par_bam2fastq} --joblog my_job_log.log \
//   < job.list && (rm job.list my_job_log.log)"

// echo -e "\n# Executing job list in parallel batches"

// echo "# ${cmd}"
// eval ${cmd}


    stub:
    """
    mkdir fastq_results
    touch fastq_results/${sample}.fastq.gz
    """
}