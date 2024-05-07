a = [1 2 1 0 0; 1 1 0 1 0; 1 -1 0 0 1];
b = [10; 6; 2]
A = [a b];
cost = [2 1 0 0 0 0];
var = {'x1','x2','x3','s1','s2','s3'}
BasicVariable = [3 4 5];
zjcj = cost(BasicVariable)*A - cost;

simplex_table = [A;zjcj]
array2table(simplex_table,'VariableNames',var)

RUN=true;
while(RUN)
    if any(zjcj(1:end-1)<0)
        fprintf('Current BFS is not optimal\n')
        zc = zjcj(1:end-1);
        [enter_val, pvt_col] = min(zc);
        if all(A(:,pvt_col)<=0)
            error('LPP is unbounded');
        else
            sol = A(:,end);
            column = A(:,pvt_col);
            for i = 1:size(A,1)
                if column(i) > 0
                    ratio(i) = sol(i)./column(i);
                else
                    ratio(i) = inf;
                end
            end
            [leaving_value, pvt_row] = min(ratio);
        end
        BasicVariable(pvt_row) = pvt_col;
        pvt_key = A(pvt_row, pvt_col);
        A(pvt_row,:) = A(pvt_row,:)./pvt_key;
        for i = 1:size(A,1)
            if i~= pvt_row
                A(i,:) = A(i,:) - A(i,pvt_col).*A(pvt_row,:);
            end
        end
        zjcj = cost(BasicVariable)*A - cost;
        next_table = [zjcj; A];
        array2table(next_table,'VariableNames',var)
    else
        RUN=false;
        fprintf('The final optimal value is %f \n', zjcj(end));
    end
end