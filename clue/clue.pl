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
	init,
	menu,
	play.

init :-
	assert(unknown(mustard)),
	assert(unknown(scarlet)),
	assert(unknown(plum)),
	assert(unknown(green)),
	assert(unknown(white)),
	assert(unknown(peacock)),
	assert(unknown(hall
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
        write("Are you the first one? (y/n)\n"),
        getValidChar(Char),
        ((Char = 'y',
	suggest,
	win);
        (Char = 'n',
	turn(1))).

suggest.
turn(Num) :-
	write("Does opponent "),write(Num), write( "reach a new room? (y/n)\n"),
	getValidChar(Char),
	((Char = 'y',
	write("What character did he guess? (e.g. 'green.')\n"),
	getValidCharacter(Name1),
	write("What room did he guess? (e.g. 'hall.'\n"),
	getValidRoom(Name2),
	write("What weapon did he guess? (e.g. 'knife.'\n"),
	getValidWeapon(Name3),
	(
	write("Does any player now need to/has reply to his/her suggestion? (y/n)\n"),
	getValidChar(Char2),
	((Char2 = 'y',
	write("Please enter his position relative to first player, you are number 0 whereever you position is, the person after you is the position of person before you plus 1')\n"),
	getValidNum(Num2),
	(Num2 = 0,
	write("if you have more than 1 card match").

getValidNum(Num) :-
	read(N),
	numplayer(Total),
	((N < Total,
	Num = N);
	(N >= Total,
	getValidNum(Num))).


getValidChar(Char) :-
	read(C),
	((C = 'y',
	Char = 'y');
	(C = 'n',
	Char = 'n');
	(write("enter 'y.' or 'n.'\n"),
	getValidChar(Char))).

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

getValidCharacter(Name) :-
	read(N),
	((character(N),
	Name = N);
	(\+ character(N),
	write("invalid character!\n"),
	getValidCharacter(Name))).

getValidRoom(Name) :-
	read(N),
	((room(N),
	Name = N);
	(\+ room(Name),
	write("invalid room!\n"),
	getValidRoom(Name))).

getValidWeapon(Name) :-
	read(N),
	((weapon(N),
	Name = N);
	(\+ weapon(N),
	write("invalid weapon!\n"),
	getValidWeapn(Name))).

validName(fin,_).
validName(Name,ID) :-
	character(Name),
	assert(my(Name)),
	
	getValidCards.
validName(Name.ID) :-
	room(Name),
	assert(my(Name)),
	getValidCards.
validName(Name,ID) :- 
	weapon(Name),
	assert(my(Name)),
	getValidCards.

validName2(fin,_).
validName2(ID) :-
        character(Name),
        assert(known(character(Name),ID)),
        getValidCards.
validName2(ID) :-
        room(Name),
        assert(known(room(Name),ID)),
        getValidCards.
validName2(ID) :-
        weapon(Name),
        assert(known(weapon(Name),ID)),

getValidNumPlayer(NumPlayer) :-
        write('How many players are there? (It is better to have 3-6 players)\n example input: "3."\n'),
        read(Num),
	((number(Num),
        NumPlayer = Num);
        (\+ number(Num),
        write("You should enter a number\n"),
	getValidNumPlayer(NumPlayer))).
