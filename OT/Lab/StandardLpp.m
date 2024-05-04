format short
clc
clear all

%Step1 Input Parameter
C = [1 2];
A = [-1 1;1 1];
B = [1;2];

%Step2 Inequality Sign
InqSign=[0 0];
s=eye(size(A,1));
index=find(InqSign>0);
s(index,:)=-s(index,:);

%Step3 Objective Function
objfn=array2table(C);
objfn.Properties.VariableNames(1:size(C,2))={'x_1','x_2'};

%Step4 Constraints
mat=[A s B];
constraint= array2table(mat);
constraint.Properties.VariableNames(1:size(mat,2))={'x1','x2','s1','s_2','B'}
