clc
clear all
format short

%1. Input
noofvariables=3;
info=[3 -1 2;-2 4 0;-4 3 8];
b=[7;12;10];
C=[1 -3 2];
S=eye(size(info,1));
A=[info S b];
cost=zeros(1,size(A,2));
cost(1:noofvariables)=C;

%2Contraint on BV
BV=noofvariables+1:1:size(A,2)-1;

%3 Zj-Cj
ZjCj=cost(BV)*A-cost;

%4 Print Table
Zcj=[ZjCj;A];
SimpTable=array2table(Zcj);
SimpTable.Properties.VariableNames(1:size(Zcj,2))={'x1','x2','x3','s1','s2','s3','sol'}


% Simplex Table Starts 
RUN=true;
while RUN
if any(ZjCj<0)
    
    % Check any Negative Value
    fprintf("The Current BFS is Not optimal \n")
    fprintf("Next Iterations Results\n")
    disp("Old Basic Variables (BV)=  ");
    disp(BV);

    %Finding the entering variable
    ZC=ZjCj(1:end-1);
    [Entercol,pvt_col]=min(ZC);
    fprintf("The Minimum Element in Zj-cj is %d corresponding to column %d \n",Entercol,pvt_col);
    fprintf("Entering Variable is %d \n",pvt_col);

    % Find Leaving Variable
    sol=A(:,end);
    column=A(:,pvt_col);
    if all(column<=0)
        error("LPP is Unbounded and All enteries are<=0 in column %d",pvt_col)
    else
        for i=1:size(column,1)
            if column(i)>0
                ratio(i)=sol(i)./column(i);
            else
                ratio(i)=inf;
            end
        end
        % Finding the Minimum
        [MinRatio,pvt_row]=min(ratio);
    fprintf("Minimum Ratio Corresponding to PIVOT Row is %d \n,",pvt_row);
    fprintf("Leaving Variable is %d \n",BV(pvt_row));
    end
    BV(pvt_row)=pvt_col;
    disp("New Basic Variable (BV)= ");
    disp(BV);

    % Pivot Key
    pvt_key=A(pvt_row,pvt_col);

    %Update table for next iteration
    A(pvt_row,:)=A(pvt_row,:)./pvt_key;
    for i=1:size(A,1)
        if i~=pvt_row
            A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:); %%%
        end
    end
    ZjCj=ZjCj-ZjCj(pvt_col).*A(pvt_row,:);

    %4 Print Table
    Zcj=[ZjCj;A];
    SimpTable=array2table(Zcj);
    SimpTable.Properties.VariableNames(1:size(Zcj,2))={'x1','x2','x3','s1','s2','s3','sol'}
else
    RUN=false;
    fprintf("The Current BFS is Optimal \n");
    fprintf("Optimal soln is %d\n",ZjCj(end));
    
end
end