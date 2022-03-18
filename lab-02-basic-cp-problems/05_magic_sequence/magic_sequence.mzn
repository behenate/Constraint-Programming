% Length of the sequence
int: N;

%%%%%%%%%%%%%% 
% TODO: VARIABLES        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The sequence itself, call it 'magic'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
array[1..N] of var int: magic;
%%%%%%%%%%%%%%%%%%%%
% TODO: Constraints 
%%%%%%%%%%%%%%%%%%%%
constraint forall(i in 1..N) (count(magic, i-1)==magic[i]);
solve satisfy;
  
%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE OUTPUT  
%%%%%%%%%%%%%%%%%%%%%%%%
% - magic - magic sequence     
%%%%%%%%%%%%%%%%%%%%%%%%
output [ "magic sequence = ", show(magic),";\n"];
