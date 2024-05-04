A=[2 5;1 1];
B=[80;20];
C=[0.5 -0.01];

Ineqn=[0 0];
s=eye(size(A,1));
index=find(Ineqn>0);
s(index,:)=-s(index,:);

objfn=array2table(C);

mat=[A,s];
constraint=array2table(mat);
constraint.Properties.VariableNames(1:size(mat,2))={'x1','x2','s1','s2'}

newC=[0.5 -0.01 0 0];
n=size(mat,2);
m=size(mat,1);

if(n>m)
    nCm=nchoosek(n,m);
    p=nchoosek(1:n,m);
    sol=[];
    for i=1:nCm
        y=zeros(n,1);
        A1=mat(:,p(i,:));
        X=A1\B;
        if(X>=0 & X~=inf & X~=-inf)
            y(p(i,:))=X;
            sol=[sol y];
        end
    end
end

Z=newC*sol;
[value, ind]=max(Z);
bfs=sol(:,ind);
opt=[bfs' value];
array2table(opt,)




