%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Should be loaded from the data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int: nodesNumber;
array[1..nodesNumber, 1..nodesNumber] of bool: edges;
var int: colorsNumber;
array [1..nodesNumber] of var 1..nodesNumber: nodes;

%%%%%%%%%%%%%%%%
% CONSTRAINTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% tip:
% - number of used colors = the highest used color number                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint forall ([i==j \/ not edges[i, j] \/ (nodes[i] != nodes[j]) | i in 1..nodesNumber, j in 1..nodesNumber]);

colorsNumber = max(nodes);
solve minimize max(nodes);


output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber]
