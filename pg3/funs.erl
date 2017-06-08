% Weiran Guo(912916431)
% Programmign Assignment 3
-module(funs).
-export([myremoveduplicates/1]).
-export([myappend/2]).
-export([mymember/2]).
-export([myintersection/2]).
-export([mylast/1]).
-export([myreverse/1]).
-export([myreplaceall/3]).

myremoveduplicates([]) -> [];
myremoveduplicates([H|T]) ->
	case mymember(H,T) of
		true -> myremoveduplicates(T);
		false ->
			myappend([H],myremoveduplicates(T))
	end.

myappend([H|T], Tail) ->
    [H|myappend(T, Tail)];
myappend([], Tail) ->
    Tail.

mymember(_,[]) -> false;
mymember(H,[H|_]) -> true;
mymember(H,[_|T]) -> mymember(H,T).


myintersection([],_) -> "";
myintersection(_,[]) -> "";
myintersection([H1|T1],L2) ->
	case mymember(H1,L2) of
		true ->	myremoveduplicates(myappend([H1],myintersection(T1,L2)));
		false -> myremoveduplicates(myintersection(T1,L2))
	end.

mylast("") -> "";
mylast([H]) -> H;
mylast([_|T]) -> mylast(T).

myreverse("") -> "";
myreverse([H]) -> [H];
myreverse([H|T]) -> myappend(myreverse(T),[H]).

myreplaceall(_,_,"") -> "";
myreplaceall(N1,N2,[N2|T]) ->
	[N1|myreplaceall(N1,N2,T)];
myreplaceall(N1,N2,[H|T]) ->
	[H|myreplaceall(N1,N2,T)].
