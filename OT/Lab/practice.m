format short
clc
clear all
A=[6 4;1 2;-1 1;0 1];
B=[24;6;1;2];
C=[5;4];

x1=0:1:max(B);
x21=(B(1)-A(1,1)*x1)/A(1,2);
x22=(B(2)-A(2,1)*x1)/A(2,2);
x23=(B(3)-A(3,1)*x1)/A(3,2);
x24=(B(4)-A(4,1)*x1)/A(4,2);
plot(x1,x21,'r',x1,x22,'g',x1,x23,'b',x1,x24,'y');
x21=max(0,x21);
x22=max(0,x22);
x23=max(0,x23);
x24=max(0,x24);

cx1=find(x1==0);
c1=find(x21==0);
Line1=[x1(:,[c1 cx1]);x21(:,[c1 cx1])]';
c2=find(x22==0);
Line2=[x1(:,[c2 cx1]);x22(:,[c2 cx1])]';
c3=find(x23==0);
Line3=[x1(:,[c3 cx1]);x23(:,[c3 cx1])]';
c4=find(x24==0);
Line4=[x1(:,[c4 cx1]);x24(:,[c4 cx1])]';
cornerpts=unique([Line1;Line2;Line3;Line4],'rows');


sol=[0;0];
for i=1:size(A,1)
    A1=A(i,:);
    B1=B(i,:);
    for j=i+1:size(A,1)
        A2=A(i,:);
        B2=B(i,:);
        A3=[A1;A2];
        B3=[B1;B2];
        X=A3\B3;
        sol=[sol X];
    end
end
solution=sol';
allpoints=[solution;cornerpts];
pts=unique(allpoints,'rows');

X1=pts(:,1);
X2=pts(:,2);
constraint1=6*X1+4*X2-24;
h1=find(constraint1>0);
pts(h1,:)=[];

X1=pts(:,1);
X2=pts(:,2);
constraint2=X1+2*X2-6;
h2=find(constraint2>0);
pts(h2,:)=[];

X1=pts(:,1);
X2=pts(:,2);
constraint3=-X1+X2-1;
h3=find(constraint3>0);
pts(h3,:)=[];

X1=pts(:,1);
X2=pts(:,2);
constraint4=X2-2;
h4=find(constraint4>0);
pts(h4,:)=[];

for i=1:size(pts,1)
    fx(i,:)=sum(pts(i,:)*C);
end
ans1=[pts fx];
[value, index]=max(fx);
optvalue=ans1(index,:);
table=array2table(optvalue,);

