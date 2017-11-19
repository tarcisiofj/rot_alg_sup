function targets=UseC45Tree(features,indices,tree,discrete_dim,Uc)
%Input:
%   features:N*L,N features and L samples
%   indices: index
%   tree: C4.5 decision tree
%   discrete_dim:discrete number in each dim
%   Uc:target labels£®√ª”√£©
%output:
%   targets: classification results
%Step0:initilize the results
targets=zeros(1,size(features,2));
%Step1:stop condition:leaf node
if (tree.dim==0)
    targets(indices)=tree.child;% reached the end of the tree
    return;
end
%Step2:otherwise:use children node
%2-1,first,find the dimension we are to work on
dim=tree.dim;
dims=1:size(features,1);
%2-2 and classify 
if(discrete_dim(dim)==0)
    %continuous feature
    in=indices(find(features(dim,indices)<=tree.split_loc));
    targets=targets+UseC45Tree(feature(dims,:),in,tree.child(1),discrete_dim(dims),Uc);
    in=indices(find(features(dim,indices)>tree.split_loc));
    targets=targets+UseC45Tree(features(dims,:),in,tree.child(2),discrete_dim(dims),Uc);
else
    %Discrete features
    Uf=unique(features(dim,:));
    for i=1:length(Uf)
        in=indices(find(features(dim,indices)==Uf(i)));
        targets=targets+UseC45Tree(features(dims,:),in,tree.child(i),discrete_dim(dims),Uc);
    end
end





















