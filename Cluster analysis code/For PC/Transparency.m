%Assigning a transparency value to each color based on the probability of being considered as a member of a cluster
function TransparencyOutput=Transparency(x,SelProbTemp,SelectedColor)%X Y Z Probability ColorsInRGB

Colors=(SelProbTemp(:,1).*([SelectedColor(1,1) SelectedColor(1,2) SelectedColor(1,3)]))+((1-SelProbTemp(:,1)).*([1 1 1]));
X=([x(:,1) x(:,2) x(:,3) Colors]);
A=mat2cell(X,ones(size(X,1),1),[1 1 1 3]);
rowHeadings = {'X', 'Y', 'Z', 'Col'};
TransparencyOutput=cell2struct(A,rowHeadings,2);




end