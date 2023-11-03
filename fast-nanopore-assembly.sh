#!/bin/bash

# environment only present on wbvr006 on lelycompute-01!

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate nano-dragonflye;

workdir="$PWD";

mkdir -p "$workdir"/RAWREADS;
mkdir -p "$workdir"/dragonflye-assembly;

RAWREADS="$workdir"/RAWREADS;
DRAGON="$workdir"/dragonflye-assembly;

minQvalue=10;
CPU=24;
minReadlen=1000;
model="r1041_e82_400bps_hac_g615";

FILE=barcode.lst;
if [ -f "$FILE" ]; then
    echo "$FILE exists."
	
		count0=1;
		countBC=$(cat "$FILE" | wc -l);

while [ $count0 -le $countBC ];do

# name of the barcode list
			name=$(cat "$FILE" | awk 'NR=='$count0);			

# concat alle *.fastq.gz files into 1 file for downstream processing
				cat ./fastq_pass/"$name"/*.gz > "$RAWREADS"/"$name".fq.gz;

rm -rf "$DRAGON"/"$name";
mkdir -p "$DRAGON"/"$name";	

READSin="$RAWREADS"/"$name".fq.gz;
OUTdir="$DRAGON"/"$name";
	
	echo -e "this barcode $BC is being processed at this moment";
	
	dragonflye --cpus "$CPU" --minquality "$minQvalue" --minreadlen "$minReadlen" --prefix "$name" --keepfiles --namefmt "$name"'_contig%05d' --assembler flye --opts '-i 10' --nanohq --medaka 3 --model "$model" --outdir "$OUTdir" --reads "$READSin" --force;

	##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate nano-bandage;

BANDAGEin="$FLYE/$name"/assembly_graph.gfa;
BANDAGEout="$REPORTING"/"$name".png;

# create an image from the assembly	
	Bandage image "$BANDAGEin" "$BANDAGEout";	
	
	
	
	
	
		count0=$((count0+1));
	done
	
	
	
	
else 
    echo "$FILE does not exist, please create one."
	echo "an example of the file is within the git cloned directory";
fi


