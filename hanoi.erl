-module(hanoi).
-export([create_tower/1,display_tower/1,move/3,solve/1]).

%Creates a set of three towers with the first holding N disks.
create_tower(0) -> io:format("The tower must start with at lest one disk.~n");
create_tower(N) -> [lists:reverse(generate_first(N)),[],[]].

%Creates the first tower(list) containing N elements.
generate_first(1) -> [1];
generate_first(N) -> [N | generate_first(N-1)].

%Outputs the status of all three towers.
display_tower(Towers) ->
	%Break down the list into sub lists for each tower.
	[First | [Second | [Third | _]]] = Towers,

	%Print out the results.
	io:format("--------------------------------------------------------------~n"),
	io:format("Tower1: ~w~nTower2: ~w~nTower3: ~w~n",[First,Second,Third]).
	
%Remove the top disk from the given tower.
remove_disk(1,Towers,N) -> [First | [Second | [Third | _]]] = Towers, [lists:delete(N,First),Second,Third];
remove_disk(2,Towers,N) -> [First | [Second | [Third | _]]] = Towers, [First,lists:delete(N,Second),Third];
remove_disk(3,Towers,N) -> [First | [Second | [Third | _]]] = Towers, [First,Second,lists:delete(N,Third)].

%Place a disk of specified size on the target tower.
add_disk(1,Towers,N) -> [First | [Second | [Third | _]]] = Towers, [[N] ++ First,Second,Third];
add_disk(2,Towers,N) -> [First | [Second | [Third | _]]] = Towers, [First,[N] ++ Second,Third];
add_disk(3,Towers,N) -> [First | [Second | [Third | _]]] = Towers, [First,Second,[N] ++ Third].

%Moves a single disk from one tower to another.
move(_,A,_) when A > 3; A =< 0 -> io:format("The first tower value was out of bounds.~n");
move(_,_,B) when B > 3; B =< 0 -> io:format("The second tower value was out of bounds.~n");
move(Towers,A,B) ->
	%Find the size of the disk on the given tower.
	N = lists:nth(1,lists:nth(A,Towers)),

	%Remove the disk from the designated tower and add it to the target tower.
	NewTowers = add_disk(B,remove_disk(A,Towers,N),N),
	
	%Update the display.
	display_tower(NewTowers),
	
	%return the new state of the towers
	NewTowers.

%Solves the puzzle by moving the disks from the left post to the right while observing the placement rules.
solve(Towers) ->
	%Show state of towers before recursive movement.
	display_tower(Towers),
	
	%Obtain the number of disks on the first tower.
	Disk = lists:max(lists:nth(1,Towers)),
	
	%Call the recursive move function for a starting tower of given size.
	recursive_move(Towers,Disk,1,3,2),
	
	io:format("--------------------------------------------------------------~n").

%Recursively move towers from right to left.
recursive_move(Towers,1,Source,Dest,_) -> move(Towers,Source,Dest);
recursive_move(Towers,Disk,Source,Dest,Aux) ->
	NewTowers1 = recursive_move(Towers,Disk-1,Source,Aux,Dest),
	NewTowers2 = move(NewTowers1,Source,Dest),
	recursive_move(NewTowers2,Disk-1,Aux,Dest,Source).
	
	

	


	