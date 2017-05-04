character(mustard).
character(scarlet).
character(plum).
character(green).
character(white).
character(peacock).

weapon(pipe).
weapen(knife).
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
	init,
	menu,
	play.

menu :-
	write('Clue Assistant V1.0\n'),
	write('Character list:\n'),
	findall(N1,character(N1),L1),
	printline(L1),
	write('Weapon list:'),
	findall(N2,weapon(N2),L2),
	printline(L2),
	write('Room list'),
	findall(N3,room(N2),L3),
	printline(L3).

printline([]).
printline(H|T) :-
	write(H),nl,
	printline(T).

play :-
	getValidNumPlayer(NumP),	
	assert(numplayer(NumP)),
	write('What are the cards you have right now? (eg."pipe." You can enter one at a time, enter "fin." to next step)\n'),
	read(CardName).

getValidNumPlayer(NumPlayer) :-
        write('How many players are there? (It's better to have 3-6 players)\n example input: "3."\n'),
        read(Num);
        (\+ number(Num),
        write("You should enter a number\n",
	getValidNumPlayer(NumPlayer));
	(number(Num),
	NumPlayer = Num).



	
