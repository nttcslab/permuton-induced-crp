function [RowTable, ColumnTable, TableCoordinates, nesw]...
    = Update_TableCoordinates(X, nesw, TableCoordinates, RowTable, ColumnTable, eta, alpha, BlockIndex)

[logCRPprob, NumCustomers] = calc_CRPprob(RowTable, ColumnTable, eta);
K=size(nesw,1);
EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
new_logProb = calc_DirichletLikelihood(EachClusterCount, alpha) + calc_CRPprob(RowTable, ColumnTable, eta);

for kk=1:size(TableCoordinates,2)
    % Compute current log_prob
    current_logProb = new_logProb;
    
    % Temporary storage of current parameters
    current_NumCustomers = NumCustomers;
    current_nesw = nesw;
    current_TableCoordinates = TableCoordinates;
    current_BlockIndex = BlockIndex;
    
    % New candidate
    TableCoordinates(:,kk) = rand(2,1);
    [~,I1] = sort(TableCoordinates(1,:));
    [~,input_permutation] = sort(TableCoordinates(2,I1));
    [~,BlockIndex] = sort(I1);
    [clusters,nesw] = map_permutation2generic(input_permutation);
    nesw=nesw(BlockIndex,:);
    
    % Compute new log posterior
    EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
    new_logProb = calc_DirichletLikelihood(EachClusterCount, alpha)+calc_CRPprob(RowTable, ColumnTable, eta);
    
    % MH scheme
    if new_logProb-current_logProb<log(rand(1,1))
        NumCustomers = current_NumCustomers;
        nesw = current_nesw;
        TableCoordinates = current_TableCoordinates;
        new_logProb = current_logProb;
        BlockIndex = current_BlockIndex;
    end
end