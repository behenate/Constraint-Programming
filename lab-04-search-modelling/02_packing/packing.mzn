include "diffn.mzn";
include "cumulative.mzn";
% Parameters
%%%%%%%%%%%
int: n;                      % How many squares do we have?
set of int: SQUARES = 1..n;  % Set of the available squares

% Variables
%%%%%%%%%%%
var n..sum([i | i in SQUARES]): height;    % height of the container
var n..sum([i | i in SQUARES]): width;     % width of the conainer
var (sum([i*i | i in SQUARES]))..(sum([i | i in SQUARES])*n): area = height * width; % container's area
array[SQUARES] of var 0..sum([i | i in SQUARES])-1: x; % squares' coordinates in the container
array[SQUARES] of var 0..sum([i | i in SQUARES])-1: y; % squares' coordinated in the container
array[SQUARES] of int: sizes = [i | i in SQUARES];
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Constraint 1: Squares should fit inside the container
constraint forall (i in SQUARES)(x[i]+i <= width /\ y[i]+i <= height);
  
% Constraint 2: Squares should not overlap
% constraint forall(i, j in SQUARES where i!=j) ((x[i] + i <= x[j]) \/ (x[j] + j <= x[i]) \/ (y[i] + i <= y[j]) \/ (y[j]+j <= y[i]));
constraint diffn(x,y,sizes,sizes);

constraint(width >= height);
constraint cumulative(x, sizes, sizes, height);
constraint cumulative(y, sizes, sizes, width);
% Goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve ::int_search([height, width], smallest, indomain_min, complete) minimize area; 
solve :: seq_search([
  int_search([height, width], smallest, indomain_min, complete),
  int_search([x[i] | i in reverse(SQUARES)] ++ [y[i] | i in reverse(SQUARES)], input_order, indomain_min, complete)
]) minimize area; 
%   solve minimize area;

% Boring output  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(area)];