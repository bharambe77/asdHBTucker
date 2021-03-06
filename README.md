Simulink Project: asdHBTucker

Author: Adam Sandler
Date: 7/20/18

Instructions:

Tensor decompsition:
    Required data files: asdSparse.csv
    Required packages: Sandia NL Tensor Toolbox
    
    1. Compile appropriate MEX file (sample code provided but commented out in lines 5-6)
    Note: parallel verion requires OpenMP
    2. Adjust any settings in asdTens.m (see init_options.m for more info)
    Note: for pre-processing of genes, uncomment out (line 2):
        asd=asdGeneSelect(asdSparse, .1);
    and comment out (line 3):
        asd=sptensor(asdSparse(:,1:3),asdSparse(:,4));
    3. Run asdTens.m
    4. Output will be in asdHBTucker.mat

Classification (MatLab):
    Required data files: asdHBTucker*.mat (output of Tensor decomposition)
    
    1. Ensure logisticReg.m or logisticRegPCA.m loads the right .mat file
    2. If running ogisticRegPCA.m, adjust nPCs (number of principal components) in line 23
    3. Run logisticReg.m or logisticRegPCA.m
    4. Output will be in command line

Classification - no decomposition (MatLab):
    Required data files: asdSparseGenes.csv (sparse representation of patient and genetic variants counting tensor)
    
    1. Run logisticReg_noDecomp_genes.m
    2. Output will be in command line

Classification (Python):
    Required data files: asdHBTucker*.mat (output of Tensor decomposition)
    Required packages: matplotlib, numpy, scipy, sklearn, xgboost (for gbm.py only)
    
    1. Make create a /plot/ folder (if one does not exist
    2. Ensure gbm.py, logistic_reg.py, logistic_feature_select.py, ran_forest.py, or svm.py loads the right .mat file
    3. Adjust any settings (number of features, regression factors, depth, and/or # of estimators
    4. Run gbm.py, logistic_reg.py, logistic_feature_select.py, ran_forest.py, or svm.py
    5. Output will be in command line


Files:
- asdGeneSelect.m- method for pre-selecting specific genes based on logistic regression
- asdGeneSelectCV.m- method for pre-selecting specific genes based on logistic regression, while cross-validating
- asdGeneSelectCV2.m- method for pre-selecting specific genes based on logistic regression, while cross-validating, using genetic variants only
- AsdHBTucker.prj- Simulink Project file
- asdHBTucker3.m- hierarchical Bayesian Tucker decomposition function
- asdTens.m- main run file
- asdTensCV.m- main run file, separates decomposition into CV folds
- asdTensCVTest.m- main run file, computes groups for CV test folds
- crp.m- draws new restaurant from Chinese Restaurant Process (CRP)
- createMRMRcsv.m- creates data csv for use in mRMR
- drawCoreCon.m- draws the core tensor for the conditional Dirichlet distribution
- drawCoreUni.m- draws the core tensor for the uniform Dirichlet distribution
- drawZ.m- draws topics for a specific sample
- drawZc.c- C version of drawZ function
- drawZsc.c- C version of drawZs function
- drchrnd.m- generates probabilities from the Dirichlet distribution
- elems.m- returns all values between two vectors
- entropy.m- calculates entropy of probability vector
- gatherCVData.m- collects all data into one file for CV classification
- gbm.py- uses a gradient boosting model to learn & predict ASD
- gbm_mi.py- uses a gradient boosting model to learn & predict ASD, with MI feature selection
- init_options.m- option initialization
- initializeTree.m- initializes hierarchical tree from the CRP
- initializePAM.m- initializes hierarchical DAG from the PAM
- ldaTests.R- computes LDA decomposition baseline tests
- logistic_reg.py- predict using logistic regression with regularization
- logistic_feature_select.py- predict using logistic regression with MI feature selection
- logisticReg.m- uses a logistic regression model to learn & predict ASD
- logisticRegDecompCV.m- uses a logistic regression model to learn & predict ASD, uses results from asdTensCV.m
- logisticRegPCA.m- predict using logistic regression, using first X PCs
- logisticReg_mRMR.r- uses a logistic regression model to learn & predict ASD, with mRMR feature selection
- logisticReg_noDecomp.m- uses a logistic regression model to learn & predict ASD, uses gene selection rather than a decomposition
- logisticReg_noDecomp_genes.m- uses a logistic regression model to learn & predict ASD, uses gene selection rather than a decomposition, using genetic variants only
- multi.m- draws a single sample from the multinomial distribution
- mRMR.r- selects features using mRMR method
- newTreePaths.m- draws tree for test documents
- newTreePathsInit.m- draws tree for test documents
- nn.py- uses a neural network model to learn & predict ASD
- opt.m- separate file that computes tests for our optimization problem
- ran_forest.py- predict using random forest
- ran_forest2.py- predict using random forest, for CV datasets
- ran_forest_mi.py- predict using random forest, with MI feature selection
- redrawTree.c- draws the tree from the CRP
- redrawPAM.c- draws the DAG from the PAM
- rgamma.c- samples small-shape gamma RVs via accept-reject
- roc_cv.py- computes and plots ROC for each CV
- roc_cv2.py- computes and plots ROC for each CV, for CV datasets
- roc_cv_nn.py- computes and plots ROC for each CV, for nn.py
- svm.py- uses SVM to learn & predict ASD