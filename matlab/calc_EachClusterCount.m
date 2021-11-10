function EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable)

D=max(X(:));
K=size(nesw,1);
EachClusterCount=zeros(D,K);
for kk=1:K
    RowIndex=nesw(kk,1):nesw(kk,3);
    ColumnIndex=nesw(kk,2):nesw(kk,4);
    inputRow = ismember(RowTable,RowIndex);
    inputColumn = ismember(ColumnTable,ColumnIndex);
    for dd=1:D
        EachClusterCount(dd,kk)=sum(sum(X(inputRow,inputColumn)==dd));
    end
end
