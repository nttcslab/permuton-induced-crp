function [clusters, nesw] = map_permutation2diagonalRec(input_permutation)

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