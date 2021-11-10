function [RowTable, ColumnTable, TableCoordinates, nesw] = test_MCMC_PCRP(X, opt)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2      % Assign the options to their default values
    opt = [];
end
if ~isfield(opt,'n'),   opt.K = 20;   end;
if ~isfield(opt,'alpha'),   opt.alpha = 0.1;    end;
if ~isfield(opt,'eta'),   opt.eta = 0.1;    end;
if ~isfield(opt,'maxiter'), opt.maxiter = 1001; end;
if ~isfield(opt,'missingRatio'), opt.missingRatio = 0.2; end;
K = opt.K;
alpha = opt.alpha; %Likehilood hyper parameter
eta = opt.eta; %Concentration parameter for CRP
maxiter = opt.maxiter;
missingRatio = opt.missingRatio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(0,'defaultAxesFontSize',16)
set(0,'defaultTextFontSize',16)
set(0,'defaultAxesFontName','Helvetica')
set(0,'defaultTextFontName','Helvetica')
figure('position',[100 100 1200 1000])

%%%%%%%% test data %%%%%%%%%
originalX = X;
missingIndex=rand(size(originalX));
X(missingIndex<missingRatio)=0;

%%% Initialization
RowTable = floor( K * rand(size(X,1),1) ) + 1;
ColumnTable = floor( K * rand(size(X,2),1) ) + 1;
[logCRPprob, NumCustomers] = calc_CRPprob(RowTable, ColumnTable, eta);
TableCoordinates = rand(2,K);
[~,I1] = sort(TableCoordinates(1,:));
[~,input_permutation] = sort(TableCoordinates(2,I1));
[~,BlockIndex] = sort(I1);
[clusters,nesw] = map_permutation2generic(input_permutation);
nesw=nesw(BlockIndex,:);




train_log_posterior = [];
test_perplexity = [];
for iter=1:maxiter
    
    
    [logCRPprob, NumCustomers] = calc_CRPprob(RowTable, ColumnTable, eta);
    EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
    temp_train_log_posterior = [calc_DirichletLikelihood(EachClusterCount, alpha)...
        + calc_CRPprob(RowTable, ColumnTable, eta) ...
        calc_DirichletLikelihood(EachClusterCount, alpha)];
    
    temp_test_perplexity = calc_testPerplexity(originalX, alpha, missingIndex, missingRatio,...
        nesw, RowTable, ColumnTable);
    
    

    if iter == 1
        train_log_posterior = temp_train_log_posterior;
        test_perplexity = temp_test_perplexity;
    else
        train_log_posterior = [train_log_posterior;temp_train_log_posterior];
        test_perplexity = [test_perplexity;temp_test_perplexity];
    end
    trueBlockLocation = nesw(:, [1 3 2 4]);
    [~,I1] = sort(TableCoordinates(1,:));
    [~,input_permutation] = sort(TableCoordinates(2,I1));
    [clusters, nesw] = map_permutation2diagonalRec(input_permutation);
    subplot(2,3,1);imagesc(clusters);colormap(gray);title('Diagonal rectangulation');
    
    [clusters,nesw] = map_permutation2generic(input_permutation);
    subplot(2,3,4);imagesc(clusters);colormap(gray);title('Generic rectangulation');
    
    
    subplot(2,3,2);plot_ClusteringResult(originalX, trueBlockLocation, RowTable, ColumnTable);%daspect([1 1 1]);
    title('Input matrix')
    subplot(2,3,3);plot(test_perplexity,'LineWidth',3);title('Test perplexity');ylabel('Perplexity');
    subplot(2,3,5);scatter(TableCoordinates(1,:),TableCoordinates(2,:),3*NumCustomers+10,'filled');%daspect([1 1 1]);
    title('Table coordinates')
    subplot(2,3,6);plot(train_log_posterior,'LineWidth',3);
    legend({'Posterior','Likelihood'},'Location','southeast')
    title('Training log posterior');ylabel('Log posterior');
    pause(0.01);
    
    
    % MCMC updates
    [RowTable, ColumnTable, TableCoordinates, nesw]...
        = Update_CRPtable(X, nesw, TableCoordinates, RowTable, ColumnTable, eta, alpha, BlockIndex);
    [RowTable, ColumnTable, TableCoordinates, nesw]...
        = Update_TableCoordinates(X, nesw, TableCoordinates, RowTable, ColumnTable, eta, alpha, BlockIndex);
    
    
end
