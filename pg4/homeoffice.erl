% Weiran Guo(912916431)
% Programming Assignment 4
% This is the homeoffice module

-module(homeoffice).
-export([loop/0]).
-export([inquireall/2]).
-export([inquiresingle/2]).


loop() ->
	receive
		startup ->
			%create a new table for storing names of warehouse
			ets:new(nametable,[named_table]),
			io:format("home office started~n"),
			loop();
		{createwh,Name} ->
			io:format("warehouse ~p initialized~n",[Name]),
			%register the name with a spawning process
			register(Name,spawn_link(fun warehouse:start/0)),
			%insert the name to the nametable
			ets:insert(nametable,{Name,0}),
			loop();
		{inquire,Name} ->
			%inquire for each warehouse process
			inquireall(ets:first(nametable),Name),
			loop();
		{add, House, Num, Name} ->
			%send the add message to the warehouse process
			House ! {add, Num, Name, self()},
			receive
				%wait for the latest number of good in the warehouse
				Newnum -> io:format("warehouse ~p now has ~p ~p~n",[House,Newnum,Name])
			end,
			loop();
		{sell, House, Num, Name} ->
			%send the selling message to the warehouse
			House ! {sell, Num, Name, self()},
			%get the latest number in the warehouse
			receive
				Newnum ->
					case (Newnum == -1) of %invalid number, do nothing
						true -> io:format("warehouse ~p does not has such many ~p~n",[House,Name]);
						%if valid, then print the latest number
						false -> io:format("warehouse ~p now has ~p ~p~n",[House,Newnum,Name])
					end
			end,
			loop();
		{transfer, House1, House2, Num, Name} ->
			%same as selling process, send selling message to house1
			House1 ! {sell, Num, Name, self()},
			receive
				Newnum ->
                                        case (Newnum == -1) of %invalid number
                                                true -> io:format("warehouse ~p does not has such many ~p~n",[House1,Name]);
                                                false ->
							House2 ! {add, Num, Name, self()},
                        				receive
                                				Newnum2 -> io:format("warehouse ~p now has ~p ~p~n",[House2,Newnum2,Name])
                        				end,
							io:format("warehouse ~p now has ~p ~p~n",[House1,Newnum,Name])
                                        end
			end,
			loop()
	end.

inquireall('$end_of_table',_) -> []; %end of table, so return
inquireall(House,Name) ->
	io:format("warehouse ~p has ~p ~p~n",[House, inquiresingle(House,Name), Name]),
	inquireall(ets:next(nametable,House),Name). %go to next warehouse


inquiresingle(House,Name) ->
	House ! {inquire, Name, self()},
	receive
		Number ->
			Number
	end.

