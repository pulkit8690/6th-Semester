clear all
clc 
format short
cost=[2 7 4;3 3 1; 5 5 4; 1 6 2];
A=[5 8 7 14];
B=[7 9 18];

if(sum(A)==sum(B))
    fprintf("Balanced\n");
else
    fprintf("Unbalanced\n");
    if(sum(B)>sum(A))
        cost(end+1,:)=zeros(1,length(B));
        A(end+1)=sum(B)-sum(A);
    elseif (sum(A)>sum(B))
        cost(:,end+1)=zeros(length(A),1);
        B(end+1)=sum(A)-sum(B);
    end
end
icost=cost;
X=zeros(size(cost));
[m,n]=size(cost);
BFS=m+n-1;

for i=1:size(cost,1)
    for j=1:size(cost,2)
        mincost=min(cost(:));
        [rowind, colind]=find(mincost==cost);
        X1=min(A(rowind),B(colind));
        [val,ind]=max(X1);
        ii=rowind(ind);
        jj=colind(ind);
        Y1=min(A(ii),B(jj));
        X(ii,jj)=Y1;
        if(min(A(ii),B(jj))==A(ii))
            B(jj)=B(jj)-A(ii);
            A(ii)=A(ii)-X(ii,jj);
            cost(ii,:)=inf;
        else
            A(ii)=A(ii)-B(jj);
            B(jj)=B(jj)-X(ii,jj);
            cost(:,jj)=inf;
        end

    end
end
if(BFS==length(nonzeros(X)))
    fprintf("Degenerate \n");
else
    fprintf("Non Degenerate");
end
ans=sum(sum(icost.*X));