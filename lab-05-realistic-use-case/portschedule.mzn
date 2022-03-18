include "diffn.mzn";
include "cumulative.mzn";

int: nr; % number of reclaimers
           % number of rails = nr for stages A,B,C,D,E
           % number of rails = (nr + 1) div 2 for stage F
set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile
int: maxtime; % time considered
set of int: TIME = 0..maxtime;
int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time; % stack time per unit of coal
int: reclaim_time; % recliaim time per unit of coal
int: reclaim_speed; %


array[STOCKPILE] of var POSITION: westend;  % Start pos of stack
array[STOCKPILE] of var POSITION: eastend;  % End position of stack
array[STOCKPILE] of var TIME: stack;        % Time of stack start
array[STOCKPILE] of var TIME: endstack;     % Time of stack end
array[STOCKPILE] of var TIME: reclaim;      % Time of reclaim start
array[STOCKPILE] of var TIME: finished;     % Time of reclaim 
array[STOCKPILE] of var RECLAIMER: which;   % Which reclaimer for given stockpile
array[STOCKPILE] of var POSITION: pilelengths;
array[STOCKPILE] of var TIME: piletimes;
% Go crazy here

% Stage A - Packing Problem
% Two stockpiles can't overlap in "spacetime"

% 1) what's the relation between endstack and stack times
constraint forall(i in STOCKPILE)(endstack[i] = stack[i] + stack_time*size[i]);
% 2) what's the relation between finished and stack times
constraint forall(i in STOCKPILE)(finished[i] >= stack[i] + stack_time*size[i] + reclaim_time*size[i]);
% 3) what's the relation between reclaim and endstack times
constraint forall(i in STOCKPILE)(reclaim[i] >= endstack[i]);
% 4) what's the relation between finished and reclam times
constraint forall(i in STOCKPILE)(finished[i] = reclaim[i] + reclaim_time*size[i]);
% 5) what's the relation between eastend and westend offsets
constraint forall(i in STOCKPILE) (eastend[i] = westend[i]+size[i]);

% 6) packing problem
%    a) stockpiles should not overlap in "spacetime", treat them as rectangles
%    b) stockpiles can't use more space than there is available
%    c) we can't go beyond the time limit

constraint forall(i in STOCKPILE)(pilelengths[i] = eastend[i]-westend[i]);
constraint forall(i in STOCKPILE)(piletimes[i] = finished[i]-stack[i]);
constraint diffn(stack,westend,piletimes,pilelengths);

constraint cumulative(stack, piletimes, pilelengths, len);
constraint cumulative(westend, pilelengths, piletimes, maxtime);
  
  
  
% Stage B 
% Two stockpiles reclaimed by the same reclaimer do not overlap in time
%
% Tip: write your first custom predicate, i.e.
% predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2) =
% <something something> ;
predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2, var int:distance) =
     finished[s1]+distance*reclaim_speed <= reclaim[s2] 
  \/ finished[s2]+distance*reclaim_speed <= reclaim[s1];

constraint forall(i,j in STOCKPILE where which[i]==which[j] /\ i!=j)(not_overlap(i,j,0));

% Stage C
% 1) no stockpile can be reclaimed onto a ship before the arrival time of the ship
constraint forall(i in STOCKPILE)(reclaim[i] >= arrival[ship[i]]);
% 2) also no two stockpiles can be reclaimed onto the same ship at the same time. Make sure these reclaims do not overlap in time.
constraint forall(i,j in STOCKPILE where ship[i]==ship[j] /\ i!=j)(not_overlap(i,j,0));
% TIP: reuse your "not_overlap" predicate



% Stage D
% Add constraints to your model to ensure that if a reclaimer finishes reclaiming a stockpile with westend at x and then has to start reclaiming a stockpile with westend at y there is at least |y − x| ∗ reclaim speed time between these two events.
% TIP: just make your "not_overlap" predicate smarter
% TIP: you can introduce local variables in the constraints/predicates
% let {
%  <local variables>
% } in <then something>
constraint forall(i,j in STOCKPILE where which[i]==which[j] /\ i!=j)(not_overlap(i,j,abs(westend[i]-westend[j])));


% Stage E
% Add a definition of the objective to your model and change the model to minimize this value.
% You may well need to significantly change your search strategy to get good solutions for the objective.

% TIP: definetely change the line below

array[SHIP] of var TIME: maxy;
constraint forall(i in SHIP)(maxy[i] = max([finished[j]| j in STOCKPILE where ship[j] == i])-arrival[i]);

% Stage F
% Add constraints in your model so that the two reclaimers on rail i numbered 2i − 1 and 2i for i ∈ 1..nr div 2 remain so the western one 2i − 1 is never east of the eastern one 2i. Note they can legitimately be in the same position (this is for simplicity, its not very real). Note that if there are
% an odd number of reclaimers the last reclaimer is on its own rail and has no further constraints.
% TIP: do some "channeling" and model reclaimers' positions explicitely with a new array of variables.

% Bardzo wstępna i testowa wersja stage F (nie bierze w ogóle pod uwagę czy jest włączona czy nie itp.) , ponieważ nawet przykłady ze zmienną stageF=false nie wykonują się
array[RECLAIMER, TIME] of var -1..len: poshist;


constraint if stageF then forall(i in STOCKPILE, t in reclaim[i]..finished[i]) (poshist[which[i],t] = westend[i]) endif;

constraint if stageF then forall(i in RECLAIMER, t in TIME where i mod 2 == 0)(poshist[i,t] <= poshist[i-1,t]) endif;
var int: obj = sum(maxy);

% solve minimize obj;
solve :: seq_search([
  int_search(finished, smallest, indomain_min, complete),
  int_search(westend, first_fail, indomain_min, complete)
]) minimize obj; 

% don't change the output
output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"] ++
["obj = ",show(obj), ";\n"]
;
%output[show(poshist[i,j]) ++ if j = maxtime then "\n" else "" endif  | i in RECLAIMER, j in TIME];