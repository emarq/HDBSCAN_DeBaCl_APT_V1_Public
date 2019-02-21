%Shrinking the original pos file (if you want to do the cluster analysis on a smaller box)
function NewPos=ShrinkingPosFile(pos)

[row, ~]=find(pos(:,1)<40 & pos(:,2)<40 & pos(:,3)<40);

NewPos=pos(row,:);






end