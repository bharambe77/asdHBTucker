load('asdHBTucker_gam0.1.mat'); %load tensor

%run only once, keep constant
%or use seed
pTest=.3; %percent of data in test
rng(12345); %seed RNG
nPat=size(phi,1); %number of patients
ind=crossvalind('HoldOut',nPat,pTest); %split data into test & train sets
%save('cvInd.mat','ind'); %save indices
%load('cvInd.mat'); %load indices

phiMat=tenmat(phi,1); %flatten tensor to matrix
phiMat=phiMat(:,:); %convert to matrix
phiMat=phiMat(:,sum(phiMat,1)>0); %remove columns of all zeros
asd=logical(repmat([1;0],nPat/2,1)); %binary whether or not patient has ASD

warning off stats:pca:ColRankDefX;

[~,phiPCs]=pca(phiMat); %compute PCA

warning on stats:pca:ColRankDefX;

nPCs=50; %number of PCs
phiMat=phiPCs(:,1:nPCs);

%split data based on index into training and testing sets
trainPhi=phiMat(ind,:);
trainASD=asd(ind);
testPhi=phiMat(~ind,:);
testASD=asd(~ind);

nFolds=10; %set number of folds
nTrain=sum(ind); %size of training set
cvInd=crossvalind('Kfold',nTrain,nFolds); %split data into k folds
AUC=zeros(nFolds,1); %initialize AUC vector
AUCtr=zeros(nFolds,1); %initialize AUC vector

%disable certain warnings
warning off stats:glmfit:IterationLimit;
warning off stats:glmfit:IllConditioned;
warning off MATLAB:nearlySingularMatrix;

for i=1:nFolds
    b=cvInd==i; %logical indices of test fold
    
    %split data based on index into training and testing sets
    cvTestPhi=trainPhi(b,:);
    cvTrainPhi=trainPhi(~b,:);
    cvTestASD=trainASD(b,:);
    cvTrainASD=trainASD(~b,:);
    
    %logistic regression
    logReg=glmfit(cvTrainPhi,cvTrainASD,'binomial');
    
    %prediction
    predtr=glmval(logReg,cvTrainPhi,'logit');
    pred=glmval(logReg,cvTestPhi,'logit');
    
    %compute AUC of ROC curve
    [~,~,~,AUCtr(i)]=perfcurve(cvTrainASD,predtr,1);
    [~,~,~,AUC(i)]=perfcurve(cvTestASD,pred,1);
end

%re-enable certain warnings
warning on stats:glmfit:IterationLimit;
warning on stats:glmfit:IllConditioned;
warning on MATLAB:nearlySingularMatrix;

%t-test that mean AUC = 0.5
[~,p]=ttest(AUC,.5);
[~,ptr]=ttest(AUCtr,.5);

%print values
fprintf('Set\t Mean\t StDev\t P-value\n');
fprintf('Valid\t %1.4f\t %1.4f\t %1.4f\n',mean(AUC),std(AUC),p);
fprintf('Train\t %1.4f\t %1.4f\t %1.4f\n',mean(AUCtr),std(AUCtr),ptr);