
process create_archive {
    
    publishDir "${params.archivedir}", pattern: "**", mode: "copy"



    input:
    // tuple val(meta), path(lima_counts), path(samplesheet), path(rmd_file), path(logo_file)
    tuple val(meta), path(fastq_files, stageAs: "fastq_results/*"), path(info, stageAs: "info/*"), path(files)


    output:
    tuple val(meta), path("**"), emit: archive

    script:
    """
    #{ tar -cvhf - fastq_results info ${files} \
    #| tee >(md5sum > ${meta.project}-results.md5sum.txt) \
    #> ${meta.project}-results.tar } 2> ${meta.project}-results_content.txt
    
    tar -cvhf - fastq_results info ${files} \
        | tee >(md5sum > ${meta.project}-results.md5sum.txt) \
        > ${meta.project}-results.tar
    sed -i 's/-/${meta.project}-results.tar/g' ${meta.project}-results.md5sum.txt

    """
    // projectnum=$(echo ${samplesheet} | cut -d "_" -f 1 | tr -d "\n")
    // cmd="scripts/barcode_QC_Kinnex.sh \
    //     -i ${outfolder}/${final_results}/HiFi.lima.counts \
    //     -r scripts/barcode_QC_Kinnex.Rmd \
    //     -m ${mincnt} \
    //     -f ${qc_format} \
    //     -p ${projectnum} \
    //     -s ${outfolder}/${inputs}/${samplesheet}"

    
}