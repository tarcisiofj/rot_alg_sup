fisher=importdata('Fisher.txt',',',1);

nb=NaiveBayes.fit(fisher.data(1:75,1:4),fisher.data(1:75,5));
c1=nb.predict(fisher.data(76:end,1:4));
cmat=confusionmat(fisher.data(76:end,5),c1);
post=posterior(nb,fisher.data(1:75,1:4));

nb1=NaiveBayes.fit(fisher.data(1:75,[2 3 4]),fisher.data(1:75,1));

nb=fitcnb(fisher.data(1:75,1:4),fisher.data(1:75,5))
islabel=  resubPredict(nb)
 cm = confusionmat(fisher.data(1:75,5),islabel)
 
