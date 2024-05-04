%Input Parameter
A=[2 3 -1 4;1 -2 6 -7];
B=[8;-3];
C=[2 3 4 7];
% n and m
n=size(A,2);
m=size(A,1);

% nCm
nCm=nchoosek(n,m);
p=nchoosek(1:n,m);

sol=[];
if(n>m)
    for i=1:nCm
        y=zeros(n,1);
        A1=A(:,p(i,:));
        X=A1\B;
        if(X>0 & X~=inf & X~=-inf)
            y(p(i,:))=X;
            sol=[sol y];
        end
    end
else
    error("n is less than m");
end

Z=C*sol;
[value, index]=max(Z);
bfs=sol(:,index);
optval=[bfs' value];
array2table(optval)

