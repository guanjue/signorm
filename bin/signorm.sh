##################################
script_folder='/Volumes/MAC_Data/data/labs/zhang_lab/01projects/signorm/bin/'
analysis_folder='/Volumes/MAC_Data/data/labs/hardison_lab/vision/gene_rnaseq_atac/'

input_folder='/Volumes/MAC_Data/data/labs/zhang_lab/01projects/signorm/test_data/input_signal/'
output_folder_t_r_file='/Volumes/MAC_Data/data/labs/zhang_lab/01projects/signorm/test_data/signorm_signal_t_r_info/'
output_folder_normed_sig_file='/Volumes/MAC_Data/data/labs/zhang_lab/01projects/signorm/test_data/signorm_normed_signal/'
##################################
	if [ -d "$output_folder_t_r_file" ]; then  
		rm -r $output_folder_t_r_file
	fi
	mkdir $output_folder_t_r_file

	if [ -d "$output_folder_normed_sig_file" ]; then  
		rm -r $output_folder_normed_sig_file
	fi
	mkdir $output_folder_normed_sig_file
##################################

##################################
cd $analysis_folder
### run pipeline
while read LINE
do
	sig1=$(echo "$LINE" | awk '{print $1}')
	sig2=$(echo "$LINE" | awk '{print $2}')
	echo $sig1 $sig2
	### get ncis t_r matrix
	time python $script_folder'get_ncis_t_a_b.py' -i $input_folder$sig1 -j $input_folder$sig2 -o $output_folder_t_r_file$sig1'_vs_'$sig2'.txt'
	### get scale factor and normalize x-axis signal
	time Rscript $script_folder'signorm.R' $input_folder$sig1 $input_folder$sig2 $output_folder_t_r_file$sig1'_vs_'$sig2'.txt' $output_folder_normed_sig_file$sig1'.norm.txt' var BinSeg 1000000 2017 0 3 4 $script_folder
done < $input_folder'info_table.txt'
##################################

