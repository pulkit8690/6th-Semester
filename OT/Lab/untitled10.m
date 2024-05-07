clc
clear
format short
syms x1 x2
%objective function
f1=x1-x2+2*x1^2+2*x1*x2+x2^2;
fx=inline(f1);
fobj=@(x) fx(x(:,1),x(:,2));

%gradient
grad=gradient(f1);
G=inline(grad);
gradx=@(x) G(x(:,1),x(:,2));

%hessian matrix
H1=hessian(f1);
Hx=inline(H1);

x0=[1 1];
N=4;  % no of iteration
tol=0.001;
iter=0;
X=[];

while norm(gradx(x0))> tol && iter<N
    X=[X;x0];
    S=-gradx(x0);
    H=Hx(x0);
    lam=S'*S./(S'*H*S);
    Xnew=x0+lam.*S';
    x0=Xnew;
    iter=iter+1;
end

x0;
fobj(x0)