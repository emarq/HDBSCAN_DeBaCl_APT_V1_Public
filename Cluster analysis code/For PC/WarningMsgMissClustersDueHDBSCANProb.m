%A pop up warning message which mentions we are missing some clusters because their HDBSCAN probabbility values are less than hdbscanProbabilityThreshold
function WarningMsgMissClustersDueHDBSCANProb(TotoalNumberOfClusters,ClusterCounter)


MessageForQuestdlgBox=[num2words(TotoalNumberOfClusters-ClusterCounter,'case','sentence') ' of the ' num2str(TotoalNumberOfClusters) ' detected clusters were removed because their atoms have HDBSCAN probabbility less than hdbscanProbabilityThreshold.If you continue, these ' num2str(TotoalNumberOfClusters-ClusterCounter) ' clusters are ignored. If you do not like to miss the clusters, please terminate the code and slightly reduce hdbscanProbabilityThreshold at the beginning of the code. What do you prefer to do?'];
choice = questdlg(MessageForQuestdlgBox, ...
	'Warning for the user from PlottingDeBaClResults function', ...
	'Continue','Terminate','Terminate' );
% Handle response
switch choice
    case 'Continue'
        disp('Please note that:')
        NOTE=[num2words(TotoalNumberOfClusters-ClusterCounter,'case','sentence') ' of the ' num2str(TotoalNumberOfClusters) ' detected clusters were removed,'];
        disp(NOTE)
        disp('I will CONTINUE the execution of the code.')
    case 'Terminate'
        error('Since the user does not like to miss any DeBaCl detected clusters, the code execution is terminated')
end




end