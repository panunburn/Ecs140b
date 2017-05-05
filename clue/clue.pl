character(mustard).
character(scarlet).
character(plum).
character(green).
character(white).
character(peacock).

weapon(pipe).
weapon(knife).
weapon(wrench).
weapon(candlestick).
weapon(rope).
weapon(revolver).

room(hall).
room(lounge).
room(diningroom).
room(kitchen).
room(ballroom).
room(conservatory).
room(billiard).
room(library).
room(study).

clue :-
	%init,
	menu,
	play.

menu :-
	write('Clue Assistant V1.0\n'),
	write('------Character list:\n'),
	findall(N1,character(N1),L1),
	printline(L1),
	write('------Weapon list:\n'),
	findall(N2,weapon(N2),L2),
	printline(L2),
	write('------Room list\n'),
	findall(N3,room(N3),L3),
	printline(L3).

printline([]).
printline([H|T]) :-
	write(H),nl,
	printline(T).

play :-
	getValidNumPlayer(NumP),	
	assert(numplayer(NumP)),
	iD,
	getValidCards,
	turns.

turns :-
	write("Who's turn right now? e.g. 'green'\n"),
	read(Name),

iD :-
	write("Which character did you choose?\n"),
	read(Name),
	((character(Name),
	assert(id(Name)));
	(\+ character(Name),
	write("invalid name, please enter again\n"),
	iD)).

getValidCards :-
	write('What are the cards you have right now? (eg."pipe." or "green." You can enter one at a time, enter "fin." if done)\n'),
	read(Name),
	(validName(Name,0)
	;
	(\+ validName(Name,0),
	write("Please enter a valid card name\n"),
	getValidCards)).

validName(fin,_).
validName(Name,ID) :-
	character(Name),
	assert(known(character(Name),ID)),
	getValidCards.
validName(Name,ID) :-
	room(Name),
	assert(known(room(Name),ID)),
	getValidCards.
validName(Name,ID) :- 
	weapon(Name),
	assert(known(weapon(Name),ID)),
	getValidCards.

getValidNumPlayer(NumPlayer) :-
        write('How many players are there? (It is better to have 3-6 players)\n example input: "3."\n'),
        read(Num),
	((number(Num),
        NumPlayer = Num);
        (\+ number(Num),
        write("You should enter a number\n"),
	getValidNumPlayer(NumPlayer))).
