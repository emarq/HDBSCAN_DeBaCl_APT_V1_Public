%DeBaCl post processing analysis are done here
function [InitialNumberOfLeafs, NumberOfClusters]=DeBaClPostProcess(FolderAddress,MassLengthDeBaClThreshold,gammaDeBaCl)

    disp(FolderAddress)
    LabelFileAddress=[FolderAddress '/DeBaCl_labels.txt']; 
    Temp=importdata(LabelFileAddress);
    labels=Temp(:,2);

    treeoutputFileAddress=[FolderAddress '/DeBaCl_treeOutput.txt'];
    DBLoutput=ReadDeBaCltreeOutputFile(treeoutputFileAddress);
    
    InitialNumberOfLeafs=0;
    for i=1:size(DBLoutput,1)
        if size(DBLoutput{i,8},2)==0
            InitialNumberOfLeafs=InitialNumberOfLeafs+1;
        end
    end
    
    if size(DBLoutput,1)>1
        LeafMassSizeCtrl=true(1);
    else
        LeafMassSizeCtrl=false(1);
    end

    AvoidInfiniteLoopCounter=0;%In rare cases, pruning is too complex that 
    %it is good to stop recursively merging because it is impossible. 
    %If in 200 loops we cannot recursively merge the leafs, it is good to
    %stop it.
    
    while LeafMassSizeCtrl
        AvoidInfiniteLoopCounter=AvoidInfiniteLoopCounter+1;
        %Finding rejected leafs
        RejectedLeafNodeIDs=[];
        for i=1:size(DBLoutput,1)
            if size(DBLoutput{i,8},1)==0 %leaf condition (i.e. leafs do not have children)
                if (DBLoutput{i,5}-DBLoutput{i,4})<MassLengthDeBaClThreshold
                    RejectedLeafNodeIDs=[RejectedLeafNodeIDs;DBLoutput{i,1}];
                end        
            end
        end

        if size(RejectedLeafNodeIDs,1)==0
            LeafMassSizeCtrl=false(1);
            continue
        end
    
        for i=size(RejectedLeafNodeIDs,1):-1:1  %i=1:size(RejectedLeafNodeIDs,1)
            for j=1:size(DBLoutput,1)
                if ismember(RejectedLeafNodeIDs(i,1),DBLoutput{j,8})
                    LeafIsReal=true(1);%leaf does not have any children
                    for k=1:size(DBLoutput{j,8},2)
                        for m=1:size(DBLoutput,1)
                            if (size(DBLoutput{m},1)>0) && (DBLoutput{m,1}==DBLoutput{j,8}(k))
                                if size(DBLoutput{m,8},1)>0
                                    LeafIsReal=false(1);
                                end
                            end
                        end
                    end
                    if ~LeafIsReal
                        break
                    end
                    EndMassSaver=[];                
                    for k=1:size(DBLoutput{j,8},2)
                        for m=1:size(DBLoutput,1)
                            if (size(DBLoutput{m},1)>0) && (DBLoutput{m,1}==DBLoutput{j,8}(k))
                                EndMassSaver=[EndMassSaver;DBLoutput{m,5}];
                                for jj=1:8
                                    DBLoutput{m,jj}=[];
                                end
                                labels(any(labels(:,1)==DBLoutput{j,8}(k),2),:)=DBLoutput{j,1};
                                break
                            end
                        end
                    end
                    maxEndMass=max(EndMassSaver);
                    DBLoutput{j,5}=maxEndMass(1,1);
                    DBLoutput{j,8}=[];
                    break
                end
            end
        end
        
        if AvoidInfiniteLoopCounter>200
            LeafMassSizeCtrl=false(1);
        end
    end
    disp(['AvoidInfiniteLoopCounter ' num2str(AvoidInfiniteLoopCounter)])
%sometimes, when prunning happens, more than two children are formed for a
%single parent. In this case, two of the children have size larger than
%gammaDeBaCl; however, the the size of the other children may be less than
%the gammaDeBaCl value. Here, we are going to assign Noise ID to these too
%small children. In "RelabelByKNN" function, we will use KNN approach to
%assign a cluster ID to these noise atoms.
    NodeID=unique(labels(:,1));
    NodeID(any(NodeID(:,1)==-1,2),:)=[];
    for i=1:size(NodeID,1)
        NodeCounter=sum(labels(:,1)==NodeID(i,1));
        if NodeCounter<gammaDeBaCl
            labels(any(labels(:,1)==NodeID(i,1),2),:)=-1;
        end
    end

    fid1 = fopen(LabelFileAddress,'wt');
    for i=1:size(labels,1)
        PRINT=[i-1 labels(i,1)];
        fprintf(fid1, '%i %i\n', PRINT);
    end
    fclose(fid1);

    UniqueLabels=unique(labels(:,1));
    UniqueLabels(any(UniqueLabels(:,1)==-1,2),:)=[];
    NumberOfClusters=size(UniqueLabels,1);
    
end