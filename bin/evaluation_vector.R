library(LSD)

### get parameters
args = commandArgs(trailingOnly=TRUE)
s1 = args[1]
s2 = args[2]
sampling_num = as.numeric(args[3])
seed = as.numeric(args[4])
output_filename = args[5]

############
###### function for MSE
test_MSE = function(sig1, sig2){
	MSE =  mean((sig1 - sig2)^2)
	return(MSE)
}
###### function for R2
test_R2 = function(sig1, sig2){
	r2 =  1 - sum((sig1 - sig2)^2)/sum((sig1 - mean(sig1))^2)
	return(r2)
}
############

### read data
d1 = read.table(s1, header = F)
d2 = read.table(s2, header = F)

### if sampling_num != 0, sampling calculate scale factor & plotting 
if (sampling_num != 0){
	set.seed(seed)
	used_id = sample(dim(d1)[1],sampling_num)
	d1 = d1[used_id,]
	d2 = d2[used_id,]		
}

### only keep both nonzero bins
used_id = as.logical((d1!=0)*(d2!=0))
d1_no0 = d1[used_id]
d2_no0 = d2[used_id]

### get sample evaluation
pearson_cor = cor(d1_no0, d2_no0, method = 'pearson')
spearman_cor = cor(d1_no0, d2_no0, method = 'spearman')
MSE = test_MSE(d1_no0, d2_no0)
R2 = test_R2(d1_no0, d2_no0)

### merge all evaluation scores
result = data.frame(s1, s2, pearson_cor, spearman_cor, MSE, R2)

### write output
write.table(result, paste(output_filename, '.txt', sep=''), quote=F, sep='\t', row.names = FALSE, col.names = FALSE)

### plot scatter plot
png(paste(output_filename, '.png', sep=''))
heatscatter(d1_no0, d2_no0, log='xy', pch = 20, main = paste('spearman: ', ))
abline(0,1,col='red')
dev.off()

