format short 
clc
clear all

cost=[11 20 7 8;20 16 10 12;8 12 18 9];
A=[50 40 70];
B=[30 25 35 40];
if(sum(A)==sum(B))
    fprintf("Balanced Transportation\n");
else
    fprintf("Unbalanced Transportation\n");
    if(sum(B)>sum(A))
        cost(end+1,:)=zeros(1,length(B));
        A(end+1)=sum(B)-sum(A);
    elseif(sum(A)>sum(B))
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
        [rowind,colind]=find(mincost==cost);
        x1=min(A(rowind),B(colind));
        [val ,ind]=max(x1);
        ii=rowind(ind);
        jj=colind(ind);
        y1=min(A(ii),B(jj));
        X(ii,jj)=y1;
        if min(A(ii),B(jj))==A(ii)
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
    disp("Non Degenerate");
else
    disp("Degenerate");
end
ans=(sum(sum(icost.*X)))
