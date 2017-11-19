%%基于C4.5决策树，完成图像的二值化
close all;
clear;
clc;
Image=imread('flower_test.png');
Mask=imread('flower_mask.png');
figure;imshow(Image);title('used image');
figure;imshow(Mask);title('used mask');
%In the Mask:
%   Mask(i,j)=0->label 0
%   Mask(i,j)=255->label 1
%   Mask(i,j)=128->unknown
[M,N,L]=size(Image);
Data=reshape(Image,[M*N,3]);
pID=find(Mask==255);
nID=find(Mask==0);
pNum=size(pID,1);
nNum=size(nID,1);
TrainData=[Data(pID,:);Data(nID,:)]';
TrainLabels=[1*ones([pNum,1]);0*ones([nNum,1])]';
TrainNum=pNum+nNum;
%train
DivNum=32;
TrainDataFeatures=uint8(TrainData/DivNum)+1;
Nbins=max(TrainDataFeatures(:));
inc_node=TrainNum*0.1;
discrete_dim=[Nbins,Nbins,Nbins];
tree=BuildC45Tree(TrainDataFeatures,TrainLabels,inc_node,discrete_dim,max(discrete_dim));
%test
TestDataFeatures=uint8(Data'/DivNum)+1;
targets=UseC45Tree(TestDataFeatures,1:M*N,tree,discrete_dim,unique(TrainLabels));
Results=reshape(targets,[M,N]);
figure;
imshow(Results,[]);
title('C4.5 ClaSSIFICATION Results');














