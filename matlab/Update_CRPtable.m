function [RowTable, ColumnTable, TableCoordinates, nesw]...
    = Update_CRPtable(X, nesw, TableCoordinates, RowTable, ColumnTable, eta, alpha, BlockIndex)

[logCRPprob, NumCustomers] = calc_CRPprob(RowTable, ColumnTable, eta);
K=size(nesw,1);
EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
new_logProb = calc_DirichletLikelihood(EachClusterCount, alpha) + calc_CRPprob(RowTable, ColumnTable, eta);

for ii=1:size(RowTable,1)
    % Compute current log_prob
    current_logProb = new_logProb;
    
    % Temporary storage of current parameters
    current_RowTable = RowTable;
    current_ColumnTable = ColumnTable;
    current_NumCustomers = NumCustomers;
    current_logCRPprob = logCRPprob;
    current_nesw = nesw;
    current_TableCoordinates = TableCoordinates;
    current_BlockIndex = BlockIndex;
    
    % New candidate
    NumCustomers(RowTable(ii)) = NumCustomers(RowTable(ii)) - 1;
    logCRPprob = logCRPprob - log(NumCustomers(RowTable(ii))-1);
    if NumCustomers(RowTable(ii))==0
        [nesw, TableCoordinates, RowTable, ColumnTable, NumCustomers]...
            = delete_emptyTable(nesw, TableCoordinates, RowTable, ColumnTable, NumCustomers, RowTable(ii));
    end
    if rand(1,1) < eta %eta/(size(RowTable,1)+size(ColumnTable,1)+eta)
        % New table generation
        RowTable(ii) = size(NumCustomers,1) + 1;
        NumCustomers = [NumCustomers;1];
        TableCoordinates = [TableCoordinates rand(2,1)];
        %TableCoordinates(1,end) = (max(TableCoordinates(1,:))+1)/2; % Sophisticated proposal
        [~,I1] = sort(TableCoordinates(1,:));
        [~,input_permutation] = sort(TableCoordinates(2,I1));
        [~,BlockIndex] = sort(I1);
        [clusters,nesw] = map_permutation2generic(input_permutation);
        nesw=nesw(BlockIndex,:);
        logCRPprob = logCRPprob + log(eta);
    else
        % Assign to existing tables
        RowTable(ii) = randsample(1:size(NumCustomers,1),1,true,NumCustomers');
        %RowTable(ii) = floor(K*rand(1,1))+1;
        logCRPprob = logCRPprob + log(NumCustomers(RowTable(ii))-1);
        NumCustomers(RowTable(ii)) = NumCustomers(RowTable(ii)) + 1;
    end
    
    % Compute new log posterior
    EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
    new_logProb = calc_DirichletLikelihood(EachClusterCount, alpha)+calc_CRPprob(RowTable, ColumnTable, eta);
    
    % MH scheme
    

    if new_logProb-current_logProb<log(rand(1,1))
        RowTable = current_RowTable;
        ColumnTable = current_ColumnTable;
        NumCustomers = current_NumCustomers;
        logCRPprob = current_logCRPprob;
        nesw = current_nesw;
        TableCoordinates = current_TableCoordinates;
        new_logProb = current_logProb;
        BlockIndex = current_BlockIndex;
    end
end

for ii=1:size(ColumnTable,1)
    % Compute current log_prob
    current_logProb = new_logProb;
    
    % Temporary storage of current parameters
    current_RowTable = RowTable;
    current_ColumnTable = ColumnTable;
    current_NumCustomers = NumCustomers;
    current_logCRPprob = logCRPprob;
    current_nesw = nesw;
    current_TableCoordinates = TableCoordinates;
    current_BlockIndex = BlockIndex;
    
    % New candidate
    NumCustomers(ColumnTable(ii)) = NumCustomers(ColumnTable(ii)) - 1;
    logCRPprob = logCRPprob - log(NumCustomers(ColumnTable(ii))-1);
    if NumCustomers(ColumnTable(ii))==0
        [nesw, TableCoordinates, RowTable, ColumnTable, NumCustomers]...
            = delete_emptyTable(nesw, TableCoordinates, RowTable, ColumnTable, NumCustomers, ColumnTable(ii));
    end
    if rand(1,1)<eta %eta/(size(RowTable,1)+size(ColumnTable,1)+eta)
        % New table generation
        ColumnTable(ii) = size(NumCustomers,1) + 1;
        NumCustomers = [NumCustomers;1];
        TableCoordinates = [TableCoordinates rand(2,1)];
        %TableCoordinates(1,end) = (max(TableCoordinates(1,:))+1)/2; % Sophisticated proposal
        [~,I1] = sort(TableCoordinates(1,:));
        [~,input_permutation] = sort(TableCoordinates(2,I1));
        [~,BlockIndex] = sort(I1);
        [clusters,nesw] = map_permutation2generic(input_permutation);
        nesw=nesw(BlockIndex,:);
        logCRPprob = logCRPprob + log(eta);
    else
        % Assign to existing tables
        ColumnTable(ii) = randsample(1:size(NumCustomers,1),1,true,NumCustomers');
        %ColumnTable(ii) = floor(K*rand(1,1))+1;
        logCRPprob = logCRPprob + log(NumCustomers(ColumnTable(ii))-1);
        NumCustomers(ColumnTable(ii)) = NumCustomers(ColumnTable(ii)) + 1;
    end
    
    % Compute new log posterior
    EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
    new_logProb = calc_DirichletLikelihood(EachClusterCount, alpha)+calc_CRPprob(RowTable, ColumnTable, eta);
    
    % MH scheme
    

    
    if new_logProb-current_logProb<log(rand(1,1))
        RowTable = current_RowTable;
        ColumnTable = current_ColumnTable;
        NumCustomers = current_NumCustomers;
        logCRPprob = current_logCRPprob;
        nesw = current_nesw;
        TableCoordinates = current_TableCoordinates;
        new_logProb = current_logProb;
        BlockIndex = current_BlockIndex;
    end
end


function [nesw, TableCoordinates, RowTable, ColumnTable, NumCustomers]...
    = delete_emptyTable(nesw, TableCoordinates, RowTable, ColumnTable, NumCustomers, kk)

RowTable(RowTable>kk)=RowTable(RowTable>kk)-1;
ColumnTable(ColumnTable>kk)=ColumnTable(ColumnTable>kk)-1;
TableCoordinates(:,kk)=[];
[~,I1] = sort(TableCoordinates(1,:));
[~,input_permutation] = sort(TableCoordinates(2,I1));
[~,BlockIndex] = sort(I1);
[clusters,nesw] = map_permutation2generic(input_permutation);
nesw=nesw(BlockIndex,:);
NumCustomers(kk)=[];

