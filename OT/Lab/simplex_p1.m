clc
clear all
format short

%Input
noofvariables=3;
C=[3 3 5];
info=[1 2 1;1 4 0;3 0 2];
b=[430;460;420];
S=eye(size(info,1));
A=[info S b];
cost=zeros(1,size(A,2));
cost(1:noofvariables)=C;

%Basic Variable
BV=noofvariables+1:1:size(A,2)-1;

%Zj-Cj
ZjCj=cost(BV)*A-cost;

%print
ZCj=[ZjCj;A];
SimpTable=array2table(ZCj);
SimpTable.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','s1','s2','s3','sol'}

%Simplex Table
RUN = true;
while RUN
    if any (ZjCj<0)
        fprintf("The Current BFS is not Optimal \n");
        fprintf("Next Iteration \n");
        disp("Old Basic Variable(BV): ")
        disp(BV);
        %Entering Variable
        ZC=ZjCj(1:end-1);
        [Enter_col,pvt_col]=min(ZC);
    

        %Leaving Variable
        sol=A(:,end);
        column=A(:,pvt_col);
        if column<=0
            error("Values ");
        else
            for i=1:size(column,1)   %%%%%
                if column(i)>0
                    ratio(i)=sol(i)./column(i);
                else
                    ratio(i)=inf;
                end
            end
            [min_ratio,pvt_row]=min(ratio);
            
        end
        BV(pvt_row)=pvt_col;
        disp("New Basic Variable: ");
        disp(BV);
        %Pivot Key
        pvt_key=A(pvt_row,pvt_col);
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)    %%%%
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        ZjCj=ZjCj-ZjCj(pvt_col).*A(pvt_row,:);

        %print
ZCj=[ZjCj;A];
SimpTable=array2table(ZCj);
SimpTable.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','s1','s2','s3','sol'}

    else
        RUN=false;
        fprintf("The Current BFS is Optimal\n");
        fprintf("optimal soln is %d\n",ZjCj(end));
    end
    
end



