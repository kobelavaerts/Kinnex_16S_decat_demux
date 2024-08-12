
process barcode_QC_Kinnex {
    
    publishDir "${params.outdir}/results_barcode_QC", pattern: "**", mode: "copy"



    input:
    tuple val(meta), path(lima_counts), path(samplesheet), path(rmd_file), path(logo_file)


    output:
    tuple val(meta), path("**"), emit: qc_file

    script:
    """
    barcode_QC_Kinnex.sh \
    -i ${lima_counts} \
    -r ${rmd_file} \
    -m ${params.mincnt} \
    -f ${params.qc_format} \
    -p ${meta.project} \
    -s ${samplesheet}
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