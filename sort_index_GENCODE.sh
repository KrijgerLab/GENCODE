#!/bin/bash

# Set variables
GENCODE_VERSION="47"
GENOME_BUILD="GRCh38"
GTF_FILE="gencode.v${GENCODE_VERSION}.annotation.gtf"
DOWNLOAD_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_${GENCODE_VERSION}/${GTF_FILE}.gz"

# Create a new mamba environment with bedtools, htslib (for bgzip and tabix)
echo "Creating mamba environment 'genomic_tools'..."
mamba create -n genomic_tools -y bedtools htslib

# Activate the environment
mamba activate genomic_tools

# Create a directory for the annotation files
mkdir -p gencode_v${GENCODE_VERSION}
cd gencode_v${GENCODE_VERSION}

# Download the GENCODE GTF file
echo "Downloading GENCODE v${GENCODE_VERSION} annotation..."
wget ${DOWNLOAD_URL}

# Sort the GTF file directly from the compressed file and re-compress
echo "Sorting and compressing the GTF file..."
gunzip -c ${GTF_FILE}.gz | bedtools sort -i - | bgzip > sorted_${GTF_FILE}.gz

# Index the compressed, sorted GTF file
echo "Indexing the sorted GTF file..."
tabix -p gff sorted_${GTF_FILE}.gz

# Output completion message
echo "GENCODE v${GENCODE_VERSION} annotation is downloaded, sorted, compressed, and indexed."
echo "Files generated:"
echo "  - sorted_${GTF_FILE}.gz"
echo "  - sorted_${GTF_FILE}.gz.tbi"

# Instructions to activate the environment later
echo "To activate the environment later, use:"
echo "  mamba activate genomic_tools"
