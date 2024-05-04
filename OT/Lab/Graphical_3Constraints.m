%Step 1 Input Parameter
A=[1 2;1 1;0 1];
B=[2000;1500;600];
C=[3;5];

%Step 2 Plot graph
x1=0:max(B);
x21=(B(1)-A(1,1)*x1)/A(1,2);
x22=(B(2)-A(2,1)*x1)/A(2,2);
x23=(B(3)-A(3,1)*x1)/A(3,2);
plot(x1,x21,'r',x1,x22,'g',x1,x23,'b');
xlabel('value of x1');
ylabel('value of x2');
title('x1 vs x2');
legend('x1+2x2=2000','x1+x2=1500','x2=600');
grid on;
x21=max(0,x21);
x22=max(0,x22);
x23=max(0,x23);

%Step 3 Corner Points
cx1=find(x1==0);
c1=find(x21==0);
Line1=[x1(:,[c1 cx1]) ; x21(:,[c1 cx1])]';
c2=find(x22==0);
Line2=[x1(:,[c2 cx1]) ; x22(:,[c2 cx1])]';
c3=find(x23==0);
Line3=[x1(:,[c3 cx1]) ; x23(:,[c3 cx1])]';
cornerpts=unique([Line1;Line2;Line3],'rows');

%Step 4 Intersection Points
sol=[0;0];
for i=1:size(A,1)
    A1=A(i,:);
    B1=B(i,:);
    for j=i+1:size(A,1)
        A2=A(j,:);
        B2=B(j,:);
        A3=[A1;A2];
        B3=[B1;B2];
        X=A3\B3;
        sol=[sol X];
    end
end
solution=sol';

%Step 5 All points
Allpoints=[solution;cornerpts];
pts=unique(Allpoints,'rows');

%Step 6 Write constraints
X1=pts(:,1);
X2=pts(:,2);
constraint1=X1+2*X2-2000;
h1=find(constraint1>0);
pts(h1,:)=[];

X1=pts(:,1);
X2=pts(:,2);
constraint2=X1+X2-1500;
h2=find(constraint2>0);
pts(h2,:)=[];

X1=pts(:,1);
X2=pts(:,2);
constraint3=X2-600;
h3=find(constraint3>0);
pts(h3,:)=[];

%Step 7 Feasible region
Pts=unique(pts,'rows');

%Step 8 Objective fun
for i=1:size(Pts,1)
    fx(i,:)=sum(Pts(i,:)*C);
end
ans=[Pts fx];
[value,index]=max(fx);
optvalue=ans(index,:)
array2table(optvalue)








