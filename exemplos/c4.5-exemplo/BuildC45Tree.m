function tree=BuildC45Tree(features,targets,inc_node,discrete_dim,maxNbin)
%Input:
%   features:N*L,N features and L samples
%   targets: labels
%   inc_node:allow incorrect number
%   discrete_dim:discrete number in each dim
%   maxNbin(max of discrete_dim))
%   base:default=0;
%output:
%   tree:C4.5 decision tree
[Ni,L]=size(features);
Uc=unique(targets);% set of labels
tree.dim=0;% set default value
tree.split_loc=inf;%tree.child(1:maxNbin)=zeros(1:maxNbin);
if isempty(features)
    return;
end
%% Step1: Stop condition:feature dim is one or examples is small
if ((inc_node>L)||(L==1)||(length(Uc)==1))
    H=hist(targets,length(Uc));
    [m,largest]=max(H);
    tree.child=Uc(largest);
    return;
end
%% Step2:use C4.5 choose the best feature
% 2-1 compute the node's information entropy
for i=1:length(Uc)
    Pnode(i)=length(find(targets==Uc(i)))/L;
end
Inode=-sum(Pnode.*log(Pnode)/log(2));%之所以除log(2),因为便于消除k值，属于一般经验值
% 2-1 For each dimension,compute the gain ratio impurity
% This is done separately for discrete and aontinuous features
delta_Ib=zeros(1,Ni);% gain
split_loc=ones(1,Ni)*inf;%连续属性的分裂位置
for i=1:Ni
    data=features(i,:);%每一个属性
    Nbins=length(unique(data));%每个属性的表现形式
    if (discrete_dim(i))
        %This is a discrete feature
        P=zeros(length(Uc),Nbins);%类别*属性表现波段
        for j=1:length(Uc)
            for k=1:Nbins
                indices=find((targets==Uc(j))&(features(i,:)==k));
                P(j,k)=length(indices);%不同类别下，各个属性段的分布
            end
        end
        Pk=sum(P);
        P=P/L;
        Pk=Pk/sum(Pk);
        info=sum(-P.*log(eps+P)/log(2));
        delta_Ib(i)=(Inode-sum(Pk.*info))/-sum(Pk.*log(eps+Pk)/log(2));
    else
        %This is a continuous feature
        P=zeros(length(Uc),2);
        [sorted_data,indices]=sort(data);%Sort the feature
        sorted_targets=targets(indices);
        %calculate the information for each possible split
        I=zeros(1,L-1);
        for j=1:L-1
            for k=1:length(Uc)
                P(k,1)=length(find(sorted_targets(1:j)==Uc(k)));
                P(k,2)=length(find(sorted_targets(j+1:end)==Uc(k)));
            end
            Ps=sum(P)/L;
            P=P/L;
            info=sum(-P.*log(eps+P)/log(2));%信息熵
            I(j)=Inode-sum(info.*Ps);%以j为分界线的信息增益
        end
        [delta_Ib(i),s]=max(I);
        split_loc(i)=sorted_data(s);
    end
end
%2-3 Find the dimension minimizing delta_Ib(impurity)
[m,dim]=max(delta_Ib);
dims=1:Ni;
tree.dim=dim;
%2-4 Split along the 'dim' dimension
Nf=unique(features(dim,:));
Nbins=length(Nf);
if(discrete_dim(dim))
    for i=1:Nbins
        indices=find(features(dim,:)==Nf(i));
        tree.child(i)=BuildC45Tree(features(dims,indices),targets(indices),inc_node,discrete_dim(dims),maxNbin);
    end
else
    %continuous features
    tree.split_loc=split_loc(dim);
    indices1=find(features(dim,:)<=split_loc(dim));
    indices2=find(features(dim,:)>split_loc(dim));
    tree.child(1)=BuildC45Tree(features(dims,indices1),targets(indices1),inc_node,discrete_dim(dims),maxNbin);
    tree.child(2)=BuildC45Tree(features(dims,indices2),targets(indices2),inc_node,discrete_dim(dims),maxNbin);
end