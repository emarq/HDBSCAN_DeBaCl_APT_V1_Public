%at the end of running the code, all the folders are organized
function FinalMainFolderCleanUp(DatasetName)
    if exist('FinalResults','dir')==7
        rmdir FinalResults s
    end
    mkdir FinalResults
    movefile *.tiff FinalResults/
    movefile *.fig FinalResults/
    movefile *.txt FinalResults/
    copyfile(['FinalResults/' DatasetName])
    disp('Please find the final results in "FinalResults" folder')
end