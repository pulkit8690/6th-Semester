clc 
clear all
format short

%Input
nov=3;
info=[3 -1 2;-2 4 0;-4 3 8];
b=[7;12;10];
C=[1 -3 2];
S=eye(size(info,1));
A=[info S b];
cost=zeros(1,size(A,2));
cost(1:nov)=C;

% Basic Variable
BV=nov+1:1:size(A,2)-1;

%Zj-Cj
ZjCj=cost(BV)*A-cost;

%Print
ZCj=[ZjCj;A];
SimpTable=array2table(ZCj);
SimpTable.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','s1','s2','s3','sol'}

%Simplex Table
Run =true;
while Run
    if any (ZjCj<0)
        fprintf("The Current BFS is not Optimal\n");
        fprintf("Next Iteration\n")
        disp("old Basic Variable: ")
        disp(BV);

        %Entering Variable
        ZC=ZjCj(1:end-1);
        [enter_col, pvt_col]=min(ZC);
        
        %leaving Variable
        sol=A(:,end);
        column=A(:,pvt_col);
        if all (column<=0)
            error(" fdc");
        else
            for i=1:size(column,1)
                if column(i)>0
                    ratio(i)=sol(i)./column(i);
                else
                    ratio(i)=inf;
                end
            end
            [Min_ratio,pvt_row]=min(ratio);
        end
        BV(pvt_row,:)=pvt_col;
        disp(BV);
        %pivot key
        pvt_key=A(pvt_row,pvt_col);
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        ZjCj=ZjCj-ZjCj(pvt_col).*A(pvt_row,:);
        ZCj=[ZjCj;A];
        SimpTable=array2table(ZCj);
        SimpTable.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','s1','s2','s3','sol'}
    else
        Run=false;
        fprintf("The Current BFS is Optimal");
        disp(ZjCj(end));
    end

end




