% number of queens
include "alldifferent.mzn";
int: N;
constraint assert(N>0, "N has to be greater than 0");
array[1..N] of var 1..N: rows;

constraint forall (i,j in 1..N where i != j) (rows[i] != rows[j]);
constraint forall (i,j in 1..N where i !=j ) (rows[i] != rows[j] + j - i);
constraint forall (i,j in 1..N where i != j) (rows[i] != rows[j] - j + i);


solve satisfy; 
  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];
