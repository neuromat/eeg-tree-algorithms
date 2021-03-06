NAME
	EEG_Processing


DESCRIPTION

	Pre-processing of EEG data

AUTHORS 

	Aline Duarte, Ricardo Fraiman, Antonio Galves, Guilherme Ost and Claudia D. Vargas


REQUIREMENTS 
	
	Matlab must to be installed on the computer as well as EEGlab toolbox. The path ‘…/mypath/EEGTrees/EEGTreesAlgorithms’ must be add on Matlab.


USAGE

	EEG_Processing(rootdir, destdir)


ARGUMENTS
	
	rootdir: path where the folder .raw data were placed
	destdir: path where the folder with the processed data will be placed


OUTPUT 
	
	The folder ‘Processed_data’ saved in ‘destdir’ and containing the .mat processed data files separated by volunteer. Each file contain a ALLEEG cell array with all EEG segments necessary to perform the context tree selection procedure.


OUTPUT DETAILS AND EXAMPLE

	EEG_Processing(‘my_path/EEGTreesAlgorithms’)

	We shall give more details of the output through an example. Suppose that in the directory 'my_path/Raw_Data’ there is only the file V01_TIQ.raw, the others files are processed in an equivalent way.

	First, the V01_TIQ.raw file is with a Butterworth fourth order bandpass filter of 1-30 Hz. Artifacts above and below 100 microvolts are removed. Each electrode is re-referenced by using the Cz electrode as reference.
	
	Secondly, the filtered V01_TIQ EEG data is segmented as follows.
	(i) The data is divided in two parts, each part corresponding to the blocks QIT and TIQ.
	(ii) From each block, two segments are extracted, one for each chain, Quaternary and Ternary. The two segments corresponding to the Ternary (Quaternary) chain select from QIT and TIQ will be saved in a variable ALLEEG(1) (ALLEEG(2)) with the name TerVO1 (QuaV01)
	(iii) The EEG chunks corresponding to the Ternary chain are segmented as follows. For each possible string of symbols {0,1,2} with length at most 3, EEG segments of 450ms are extracted, each one corresponding to the last symbol of the string (from 50ms before the stimulus input to 400ms after it, as illustrated on Figure 2 in https://arxiv.org/abs/1602.00579). Then, a baseline correction is performed using the signal collected 50 ms before each event input. 
	The EEG chunks corresponding to each string are saved in the ALLEEG variable by the name ‘string_TerV01’. The same procedure is applied to EEG signals corresponding to the Quaternary chain.
	

 
