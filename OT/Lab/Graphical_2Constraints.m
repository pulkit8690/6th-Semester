clc
clear all
format short
%Step 1 Input Parameter
A=[3 5;5 2];
B=[15;10];
C=[5 3];

%Step 2 Plot the Graph
x1=0:1: max(B);
x21=(B(1)-A(1,1)*x1)/A(1,2);
x22=(B(2)-A(2,1)*x1)/A(2,2);

plot(x1,x21,'r',x1,x22,'b');
xlabel('vlaue of x1');
ylabel('value of x2');
legend('2x1 +4x2 = 8','3x1 + 5x2= 15');
title('x1 vs x2');

x21=max(0,x21);
x22=max(0,x22);

% Step 3 Find corner points
cx1=find(x1==0);
c1=find(x21==0);
c2=find(x22==0);
line1=[x1(:,[c1 cx1]);x21(:,[c1 cx1])]';
line2=[x1(:,[c2 cx1]);x22(:,[c2 cx1])]';
cornerpts=unique([line1;line2],'rows');

% Step4 Find Intersection Points
sol=[0;0];
for i=1:size(A,1)
    A1=A(i,:);
    B1=B(i);
    for j=i+1:size(A,1)
        A2=A(j,:);
        B2=B(j);
        A3=[A1;A2];
        B3=[B1;B2];
        X=inv(A3)*B3;
        sol=[sol X];
    end 
end
solution=sol';
allpoints=[solution;cornerpts];
pts=unique(allpoints,'rows');

%Step 5 Write Constraints
X1=pts(:,1);
X2=pts(:,2);
const1=3*X1+5*X2-15;
h1=find(const1>0);
pts(h1,:)=[];

X1=pts(:,1);
X2=pts(:,2);
const2=5*X1+2*X2-10;
h2=find(const2>0);
pts(h2,:)=[];

%Step 6 Find Feasible Region
Pts = unique(pts, 'rows');

%Step 7 Compute Objective Function
for i=1:size(Pts,1)
    fx(i,:)=sum(Pts(i,:).*C);
end
ans=[Pts fx];

%Step 8 Find Optimal Soln
[value index]=max(fx);
opt=ans(index,:);
array2table(opt)