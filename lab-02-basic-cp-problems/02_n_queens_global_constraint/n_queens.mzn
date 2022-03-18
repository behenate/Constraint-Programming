% number of queens
int: N;

include "alldifferent.mzn";
constraint assert(N>0, "N has to be greater than 0");
array[1..N] of var 1..N: rows;
constraint alldifferent(rows);
% constraint forall ([i==j \/ rows[i]+i != rows[j]+j | i in 1..N, j in 1..N]);
% constraint forall ([i==j \/ rows[i]-i != rows[j]-j | i in 1..N, j in 1..N]);
constraint alldifferent([rows[i] + i | i in 1..N]);
constraint alldifferent([rows[i] - i | i in 1..N]);


solve satisfy; 
%%%%%%%%%%%%%%%%%%%
% OUTPUT EXAMPLE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - rows[i] - queen's position in the ith row 
% - N - number of queens                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];
