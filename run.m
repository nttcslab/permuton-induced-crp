load('irmdata/sampledata.mat');
X=X+1;
[RowTable, ColumnTable, TableCoordinates, nesw] = test_MCMC_PCRP(X);