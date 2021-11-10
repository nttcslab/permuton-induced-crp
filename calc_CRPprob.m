function [result, NumCustomers] = calc_CRPprob(RowTable, ColumnTable, eta)

ConcatTable=[RowTable;ColumnTable];
[gc,grps] = groupcounts(ConcatTable);
result = sum(gammaln(gc))+ (numel(grps)-1)*log(eta) -sum(gammaln(size(ConcatTable,1)));


K = max(ConcatTable(:));
NumCustomers=zeros(K,1);
for kk=1:K
    NumCustomers(kk) = sum(ConcatTable==kk);
end
