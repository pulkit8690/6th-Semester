format short 
clear all
clc
syms x1 x2
%function
f1=x1-x2+2*x1^2+2*x1*x2+x2^2;
fx=inline(f1);
fobj=@(x) fx(x(:,1),x(:,2));

% gradient
grad=gradient(f1);
G=inline(grad);
gradx=@(x) G(x(:,1),x(:,2));

%Hesian Matrix
H1=hessian(f1);
Hx=inline(H1);

X=[];
x0=[0,0];
tol=0.001;
max_iter=4;
iter=0;
while norm(gradx(x0))>tol && iter<max_iter
    X=[X;x0];
    S=-gradx(x0);
    H=Hx(x0);
    lambda=S'*S./(S'*H*S);
    x_new=x0+lambda.*S';
    x0=x_new
    iter=iter+1;
end
x0
fobj(x0)




