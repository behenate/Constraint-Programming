include "globals.mzn";

int: Nodes;
set of int: NUM = 1..Nodes;
array[NUM,NUM] of int: Dist;
array[NUM] of var NUM: route;
array[NUM] of 0..Nodes: initial_route;
var int: total_distance;

constraint alldifferent(route);
constraint route[1] = 1;
constraint forall(i in NUM)(initial_route[i]==0 \/ route[i]==initial_route[i]);
total_distance = sum([Dist[route[i], route[(i+1)]] | i in 1..Nodes-1]) + Dist[route[Nodes], 1];
solve minimize total_distance;
/*
TODO: 
- it's the same as `tsp_naive.mzn` b bobooout uses the `initial_route` like sudoku
  the zeros in `initial_route` mark variables that are "free" to be optimized
  the rest is fixed
*/

output ["distance: \(total_distance)\nroute = \(route)"];
