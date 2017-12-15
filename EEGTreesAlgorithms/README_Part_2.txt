
NAME
	EEGTrees

DESCRIPTION

	Context tree selection from the processed EEG data.


AUTHORS 

	Aline Duarte, Ricardo Fraiman, Antonio Galves, Guilherme Ost and Claudia Vargas.


REQUIREMENTS 

	Matlab must to be installed on the computer as well as EEGlab toolbox. The path ‘…/mypath/EEGTrees/EEGTreesAlgorithms’ must be added on Matlab.

	
USAGE

	EEGTrees(rootdir, proj, alpha, beta) 


ARGUMENTS
	
	rootdir	: path where the files .mat are placed. That is, ‘mypath/Processed_data, where ‘mypath’ were chosen in the EEG_Processing step

	proj : number of Brownian Bridges to be used in the projective test. See REFERENCE.

       alpha : significance level of each Kolmogorov-Smirnov test applied to two samples of projected EEG signals. See REFERENCE.
	
	beta : (1-beta)-quantile of a Binomial distribution of parameters alpha and proj, used to compute the threshold for the sum of rejections over the proj directions (parameter C in the REFERENCE).


OUTPUT
	Two cell arrays

	(1) a SetTrees cell array presenting the context trees selected from the data for each context tree model, each volunteer and each electrode.
	(2) a Summary cell array indicating  each volunteer and each context tree model
	(a) the number of electrodes which selected the root tree 
	(b) the number of electrodes whose selected context tree has 2 as a context 
	(c) the number of electrodes whose selected context tree has not 1 and 0 as contexts.  

REFERENCE

Retrieving a context tree from EEG data.
Can be downloaded from arXiv:1602.00579, 2016. 









