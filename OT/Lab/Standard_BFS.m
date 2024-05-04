format short
clc
clear all

%Step1 Input parameter
A=[2 5;1 1];
B=[80 ; 20];
C=[0.5 -0.01]; 

%Step2 ineq sign
Ineqn=[0 0];

%Step3 
s=eye(size(A,1));
index=find(Ineqn>0);
s(index,:)=-s(index,:);
%Step 4
objfn=array2table(C);
objfn.Properties.VariableNames(1:size(C,2))={'x1','x2'};
%Step 5
mat=[A s];
constraint=array2table(mat);
constraint.Properties.VariableNames(1:size(mat,2))={'x1','x2','s1','s2'}

% BFS

%Step1 Input Parameter
New_C=[0.5 -0.01 0 0];

n=size(mat,2);
m=size(mat,1);
nCm=nchoosek(n,m);
p=nchoosek(1:n,m);

sol=[];
if(n>m)
    for i=1:nCm
        y=zeros(n,1);
        A1=mat(:,p(i,:));
        X=A1\B;
        if(X>0 & X~=inf & X~=-inf)
            y(p(i,:))=X;
            sol=[sol y];
            if any(X==0)
                disp('Degenrate')
            end
        end
    end
else
    error("n is less than m");
end

Z=New_C*sol;
[value, index]=max(Z);
bfs=sol(:,index);
optval = [bfs', value];
array2table(optval)








