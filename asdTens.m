asdSparse=csvread('asdSparse.csv',1,1);
asd=sptensor(asdSparse(:,1:3),asdSparse(:,4));
%asd=poissrnd(2,20,20,20);
%asd=sptensor(asd);
%[tuck, tree]=asdHBTucker(asd,2,0.5);
tic;
[phi, psi, tree]=asdHBTuckerPar(asd,2,0.5);
toc;
save('asdHBTucker.mat','phi','psi','tree');