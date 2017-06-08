% Weiran Guo(912916431)
% This is the warehouse process

-module(warehouse).
-export([loop/1]).
-export([getNum/1]).
-export([start/0]).

%the starting process
start() ->
	T = ets:new(goodtable,[]),
	%create a new table
	loop(T).
	%enter the loop with the identifier

loop(T) ->
	receive
		{inquire,Name,Office} ->
		%the inquire request from homeoffice
			Office ! getNum(ets:lookup(T,Name)),
			%send back the current number of goods in the warehouse
			loop(T);
		{add, Num, Name,Office} ->
			ets:insert(T, {Name,getNum(ets:lookup(T,Name))+ Num}),
			%add new goods to the warehouse
			Office ! getNum(ets:lookup(T,Name)),
			%send the current number of goods to the office
			loop(T);
		{sell, Num, Name, Office} ->
			case (getNum(ets:lookup(T,Name))- Num < 0) of
			%check if sells are more than goods in the house
				true ->
					Office ! -1;
					%send the error message to office
				false ->
					ets:insert(T, {Name,getNum(ets:lookup(T,Name))- Num}),
					%update the number of good
					Office ! getNum(ets:lookup(T,Name))
					%send back the number of good
			end,
			loop(T)
	end.

getNum([]) -> 0; %if empty list, then no matches
getNum([{_,B}|_]) -> B. %else return the second element in the tuple
