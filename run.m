load('irmdata/sampledata.mat');
addpath('matlab');
X=X+1;
[RowTable, ColumnTable, TableCoordinates, nesw] = test_MCMC_PCRP(X);