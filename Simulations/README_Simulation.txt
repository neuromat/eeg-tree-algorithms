NAME
	Simulation

DESCRIPTION

	Simulate and .


AUTHORS 

	Aline Duarte, Ricardo Fraiman, Antonio Galves, Guilherme Ost and Claudia Vargas.


REQUIREMENTS 

	Matlab must to be installed on the computer as well as EEGlab toolbox. The path '.../mypath/StProcDrivenByCTM/Simulations' must be add on Matlab.


USAGE

	Simulation(base_rootdir, N, l, alpha, beta, proj) 


ARGUMENTS
	
	base_rootdir : path where the folder 'StProcDrivenByCTM' were placed

	N : number of steps to be simulated

	l :  maximal height of the context tree

	proj : number of Brownian Bridges to be used in the projective test. See REFERENCE.

       	alpha : significance level of each Kolmogorv-Smirnov test applied to two samples of projected EEG signals. See REFERENCE.
	
	beta : (1-beta)-quantile of a Binomial distribution of parameters alpha and proj, used to compute the threshold for the sum of rejections over the proj directions (parameter C in the REFERENCE).


OUTPUT
	Two cell arrays
	(1) a SetTrees cell array presenting the context trees selected from the data for each context tree model, each volunteer and each electrode.

	(2) a Summary cell array indicating for each volunteer and each context tree model
	(a) the number of electrodes which selected the root tree
	(b) the number of electrodes whose selected context tree has 2 as a context 
	(c) the number of electrodes whose selected context tree has not 1 and 0 as contexts.  

REFERENCE

Retrieving a context tree from EEG data.
Can be downloaded from arXiv:1602.00579, 2016.
