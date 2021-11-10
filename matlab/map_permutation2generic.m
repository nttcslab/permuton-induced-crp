function [clusters,nesw] = map_permutation2generic(input_permutation)
% clusters (n x n): Cluster assignment
% nesw (n x 4): [north east south west]

[clusters, nesw] = map_permutation2diagonalRec(input_permutation);
[clusters, nesw]=map_diagonal2generic(nesw, input_permutation);


function [clusters,nesw] = map_diagonal2generic(nesw, input_permutation)

n=size(nesw,1);
nesw(:,1)=nesw(:,1)-1;
nesw(:,2)=nesw(:,2)-1;
horizontalWallLocations=1:n;
verticalWallLocations=1:n;

%horizontal walls
for ii=1:n
    horizontalA{ii}=[];
    vIndex_up=find(nesw(:,3)==ii);
    vIndex_bottom=find(nesw(:,1)==ii);
    vIndex_bottom(nesw(vIndex_bottom,2)==0)=[];
    vIndex=[vIndex_up;vIndex_bottom];
    if numel(vIndex)>=2
        tempSet = [verticalWallLocations(nesw(vIndex_up,4))  verticalWallLocations(nesw(vIndex_bottom,2))];
        tempSet = sort(tempSet);
        [~,Locb] = ismember(vIndex,input_permutation);
        [~,b]=sort(Locb);
        temp_perm=input_permutation(Locb(b));
        for jj=1:size(temp_perm,2)
            if sum(vIndex_up==temp_perm(jj))>0
                %verticalWallLocations(nesw(temp_perm(jj),4))=tempSet(jj);
                horizontalA{ii}=[horizontalA{ii} nesw(temp_perm(jj),4)];
            else
                %verticalWallLocations(nesw(temp_perm(jj),2))=tempSet(jj);
                horizontalA{ii}=[horizontalA{ii} nesw(temp_perm(jj),2)];
            end
        end
    end
end

cSet = merge_TotalOrders(horizontalA);
verticalWallLocations(cSet) = sort(cSet);

% vertical walls
for ii=1:n    
    verticalA{ii}=[];
    vIndex_left=find(nesw(:,4)==ii);
    vIndex_right=find(nesw(:,2)==ii);
    vIndex_right(nesw(vIndex_right,1)==0)=[];
    vIndex=[vIndex_left;vIndex_right];
    if numel(vIndex)>=2
        tempSet = [horizontalWallLocations(nesw(vIndex_left,3)) ...
            horizontalWallLocations(nesw(vIndex_right,1))];
        tempSet = sort(tempSet);
        [~,Locb] = ismember(vIndex,input_permutation);
        [~,b]=sort(Locb,'descend');
        temp_perm=input_permutation(Locb(b));
        for jj=1:size(temp_perm,2)
            if sum(vIndex_left==temp_perm(jj))>0
                %horizontalWallLocations(nesw(temp_perm(jj),3))=tempSet(jj);
                verticalA{ii}=[verticalA{ii} nesw(temp_perm(jj),3)];
            else
                %horizontalWallLocations(nesw(temp_perm(jj),1))=tempSet(jj);
                verticalA{ii}=[verticalA{ii} nesw(temp_perm(jj),1)];
            end
        end
    end
end
for ii=1:size(verticalA,2)
    verticalA{ii}=(-1)*verticalA{ii};
end
cSet = merge_TotalOrders(verticalA);
horizontalWallLocations((-1)*cSet) = sort((-1)*cSet);



clusters=zeros(n,n);
temp=zeros(n,4);
for ii=1:n
    if nesw(ii,1)>0
        top=horizontalWallLocations(nesw(ii,1))+1;
    else
        top=1;
    end
    bottom=horizontalWallLocations(nesw(ii,3));
    if nesw(ii,2)>0
        left=verticalWallLocations(nesw(ii,2))+1;
    else
        left=1;
    end
    right=verticalWallLocations(nesw(ii,4));
    
    clusters(top:bottom,left:right)=ii;
    temp(ii,:)=[top left bottom right];
end
nesw=temp;
%imagesc(clusters)


function[clusters, nesw] = map_permutation2diagonalRec(input_permutation)

n=size(input_permutation,2);
clusters = zeros(n,n);
nesw = zeros(n,4); % north, east, south, west

for ii=input_permutation
    clusters(ii,ii)=ii;
    south=ii;
    while 1
        if south==n
            break
        end
        south=south+1;
        if clusters(south,ii)>0
            south=south-1;
            break
        end
    end
    east=ii;
    while 1
        if east==1
            break
        end
        east=east-1;
        if clusters(ii,east)>0
            east=east+1;
            break
        end
    end
    north=ii;
    while 1
        if north==1
            break
        end
        north=north-1;
        if clusters(north,ii-1)==0
            north=north+1;
            break
        end
    end
    west=ii;
    while 1
        if west==n
            break
        end
        west=west+1;
        if clusters(ii+1,west)==0
            west=west-1;
            break
        end
    end
    clusters(north:south,east:west)=ii;
    nesw(ii,:) = [north east south west];
end