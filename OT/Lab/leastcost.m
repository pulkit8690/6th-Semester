clc
clear all
format short

cost=[2 7 4;3 3 1; 5 5 4; 1 6 2];
A=[5 8 7 14];
B=[7 9 18];

if(sum(A)==sum(B))
    disp("balanced TP")
else
    disp("unbalanced")
    if(sum(A)<sum(B))
        cost(end+1,:)=zeros(1,length(B));
        A(end+1)=sum(B)-sum(A);                                                                        
    elseif(sum(A)>sum(B))
        cost(:,end+1)=zeros(length(A),1);
        B(end+1)=sum(A)-sum(B);
    end
end

%%allocation matrix
icost=cost;
X=zeros(size(cost));
[m,n]=size(cost);
bfs=m+n-1; %to check degeneracy
for i=1:size(cost,1)
    for j=1:size(cost,2)
     mincost = min(cost(:));
     [rowind ,colind]=find(mincost==cost);
     x1=min(A(rowind),B(colind));
     [val, ind]=max(x1);  % Find max allocation
     ii=rowind(ind);% Identify row position
     jj=colind(ind);% Identify col position
     y1=min(A(ii),B(jj));% Find the value
     X(ii,jj)=y1;%Assign Allocation
     if min(A(ii),B(jj))==A(ii)
         B(jj)=B(jj)-A(ii);
         A(ii)=A(ii)-X(ii,jj);
         cost(ii,:)=Inf;
     else 
         A(ii)=A(ii)-B(jj);
         B(jj)=B(jj)-X(ii,jj);
         cost(:,jj)=Inf;

     end
    end
end

if(bfs==length(nonzeros(X)))
    disp("non degenerate")
else
    disp("degenerate")
end
ans=sum(sum(icost.*X))




