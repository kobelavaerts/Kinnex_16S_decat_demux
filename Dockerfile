FROM continuumio/miniconda3:24.4.0-0


# Install procps so that Nextflow can poll CPU usage and
# deep clean the apt cache to reduce image/layer size
RUN apt-get update \
      && apt-get install -y procps \
      && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# get the environment file
COPY environment.yaml environment.yaml

# create the conda environment
RUN conda env create --name kinnex_pacbio --file environment.yaml && conda clean -a

# add conda isntallation dir to PATH instead of doing 'conda activate'
ENV PATH /opt/conda/envs/kinnex_pacbio/bin:$PATH

