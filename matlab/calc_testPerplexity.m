function result = calc_testPerplexity(originalX, alpha, missingIndex, missingRatio,...
    nesw, RowTable, ColumnTable)

X = originalX;
X(missingIndex<missingRatio)=0;

EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
EachClusterCount = EachClusterCount + alpha;
DirParam = EachClusterCount ./ (ones(size(EachClusterCount,1),1)*sum(EachClusterCount, 1));

testX = originalX;
testX(missingIndex>=missingRatio)=0;
EachClusterCount = calc_EachClusterCount(testX, nesw, RowTable, ColumnTable);

result = 0;
for ii=1:size(EachClusterCount,2)
    if sum(EachClusterCount(:,ii),1)~=0
        result = result + sum(EachClusterCount(:,ii).*log(DirParam(:,ii)),1);
    end
end

missingIndex(missingIndex<missingRatio)=0;
missingIndex(missingIndex>=missingRatio)=1;
originalmissing = zeros(size(originalX));
originalmissing(originalX~=0) = 1;
result = exp((-1)*result/sum(sum((1-missingIndex).*originalmissing)));