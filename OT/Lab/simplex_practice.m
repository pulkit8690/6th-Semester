% Max Z=3x1+2x2+5x3
%st, x1+2x2+1x3<=430;
%    x1+4x2<=460;
%    3x1+2x3<=420;
clc
clear all
format short

%1 Input
noofvariables=3;
C=[3 3 5];
info=[1 2 1;1 4 0;3 0 2];
b=[430;460;420];
S=eye(size(info,1));
A=[info S b];
cost=zeros(1,size(A,2));
cost(1:noofvariables)=C;

%2 Constraint on BV
BV=noofvariables+1:1:size(A,2)-1;

%3 Zj-Cj
ZjCj=cost(BV)*A-cost;

%4 Print
ZCj=[ZjCj;A];
SimpTable=array2table(ZCj);
SimpTable.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','s1','s2','s3','sol'}

%5 Simplex Table Starts
RUN=true;
while RUN
    if any(ZjCj<0)
    
    % Check any Negative Value
    fprintf("The Current BFS is Not optimal \n")
    fprintf("******  Next Iterations Results  ****** \n")
    disp("Old Basic Variables (BV)=  ");
    disp(BV);
        
        % 6 Finding Entering Variable
    ZC=ZjCj(1:end-1);
    [Entercol,pvt_col]=min(ZC);
    fprintf("The Minimum Element in Zj-cj is %d corresponding to column %d \n",Entercol,pvt_col);
    fprintf("Entering Variable is %d \n",pvt_col);

        %7 Find Leaving Variable
        sol=A(:,end);
    column=A(:,pvt_col);
        if all (column<=0)
            error("LPP is unbounded and all values of Zj-Cj are <=0 in col %d \n",pvt_col);
        else
            for i=1:size(column,1)
            if column(i)>0
                ratio(i)=sol(i)./column(i);
            else
                ratio(i)=inf;
            end
            end
            [Min_Ratio, pvt_row]=min(ratio);
            fprintf("Minimum Ratio Corresponding to Pivot Row is %d \n",Min_Ratio);
            fprintf("Entering Variable is %d  \n",BV(pvt_row));
        end
        BV(pvt_row)=pvt_col;
    disp("New Basic Variable (BV)= ");
    disp(BV);
        %8 Pivot Key
        pvt_key=A(pvt_row,pvt_row);
        %9 Update Table for Next Iterations
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)
            if  i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        ZjCj=ZjCj-ZjCj(pvt_col).*A(pvt_row,:);

        %10 Print
        ZCj=[ZjCj;A];
        SimpTable=array2table(ZCj);
        SimpTable.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','s1','s2','s3','sol'}
    else
        RUN=false;
        fprintf("The Current Solution is Optimal \n");
        fprintf("Optimal Value is %d \n",ZjCj(end));
    end
end





