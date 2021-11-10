function result = merge_TotalOrders(A)

concatSet = [];
for ii=1:size(A,2)
    concatSet = [concatSet A{ii}];
end
uniqueSet = unique(concatSet);
orderSet = zeros(size(uniqueSet));

for ii=1:size(uniqueSet,2)
    temp = uniqueSet(ii);
    temp_stock = [];
    while numel(temp)~=0
        for jj=1:size(A,2)
            [~,Locb] = ismember(temp(1),A{jj});
            if Locb>0
                temp = [temp A{jj}(1:Locb)];
            end
        end
        temp_stock = [temp_stock temp(1)];
        temp(temp==temp(1))=[];
    end
    orderSet(ii) = numel(unique(temp_stock));
end

[~,I]=sort(orderSet);
result = uniqueSet(I);
