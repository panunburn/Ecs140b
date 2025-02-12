<<<<<<< HEAD


/*character(mustard).
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
room(study).*/

clue :-
	init,
	menu,
	play.

init :-
	write("Please enter")
menu :-
	write('Clue Assistant V1.0\n'),
=======
dynamic suspect/1.
dynamic weapon/1.
dynamic room/1.
dynamic player/1.
dynamic nextPlayer/2.
dynamic ourPlayer/1.
dynamic hasCard/2.



clue :-
	init,
	play.

play:-
	write("Game has started.\n"),
	write(""),
	player(FirstPlayer),
	takeTurn(FirstPlayer).

displayTurnMenu :-
	write("\nThe following actions are available:\n"),
	write(" - checkDetectiveNotes\n"),
	write(" - makeSuggestion\n"),
	write(" - makeAccusation\n"),
	write(" - endTurn\n"),
	write(" - quitGame\n\n").

displayDetectiveNotes :-
	write("\n\nDetective Notes\n"),

    findall(S,suspect(S),Suspects),
    write("\n-- Suspects --\n"),
	printDNoteLines(Suspects),

	findall(W,weapon(W),Weapons),
    write("\n-- Weapons ---\n"),
	printDNoteLines(Weapons),

	findall(R,room(R),Rooms),
    write("\n--- Rooms ----\n"),
	printDNoteLines(Rooms),

	nl,
	nl.



printDNoteLines([]).
printDNoteLines([H|T]) :-
	write(H),
	write(": "),
	(hasCard(Owner,H) ->
		write(Owner);
		write("-")),
	nl,
	printDNoteLines(T).

takeTurn(Player) :-

	(ourPlayer(Player) ->
		takeOurTurn(Player);
		takeOpponentTurn(Player)).

takeOurTurn(Player) :-
	write("\nIts your turn.\n"),
	write('Enter "menu." to see available actions\n\n'),
	ourTurnLoop(Player).

ourTurnLoop(Player):-
	read(Action),
	(Action == menu ->
		displayTurnMenu,
		ourTurnLoop(Player);
	Action == checkDetectiveNotes ->
		displayDetectiveNotes,
		ourTurnLoop(Player);
	Action == makeSuggestion ->
		makeSuggestion(Player),
		ourTurnLoop(Player);
	Action == makeAccusation ->
		write("not implemented yet\n"),
		ourTurnLoop(Player);
	Action == endTurn ->
		nextPlayer(Player, Next),
		takeTurn(Next);
	Action == quitGame ->
		quitGame(quit);
	% else
		nl,
		write(Action),
		write(" is not a valid action.\n"),
		write('Enter "menu." to see available actions\n\n'),
		ourTurnLoop(Player)).


makeSuggestion(Player) :-
	displayDetectiveNotes,
	getSuspectSuggestion(S),
	getWeaponSuggestion(W),
	getRoomSuggestion(R),
	nextPlayer(Player, N),
	nl,
	write(Player),
	write(" suggests that it was\n"),
	write(S),
	write(" with the "),
	write(W),
	write(" in the "),
	write(R),
	nl,
	nl,
	disproveSuggestion(S, W, R, Player, N).

getSuspectSuggestion(S) :-
	write("Enter Supect:\n"),
	read(S2),
	(suspect(S2) ->
		S = S2;
		write("\nInvalid Suspect.\n"),
		getSuspectSuggestion(S)).

getWeaponSuggestion(W) :-
	write("Enter Weapon:\n"),
	read(W2),
	(weapon(W2) ->
		W = W2;
		write("\nInvalid Weapon.\n"),
		getWeaponSuggestion(W)).

getRoomSuggestion(R) :-
	write("Enter Room:\n"),
	read(R2),
	(room(R2) ->
		R = R2;
		write("\nInvalid Room.\n"),
		getRoomSuggestion(R)).

disproveSuggestion(_, _, _, P, P):-
	write("\nWow! Nobody could disprove the suggestion.\n\n").
disproveSuggestion(S, W, R, Suggester, Disprover):-
	(ourPlayer(Disprover) ->
		playerDisprove(S, W, R, Suggester, Disprover)
		;
		opponentDisprove(S, W, R, Suggester, Disprover)
		

		).


playerDisprove(S, W, R, Suggester, Disprover):-
	write("we would select a card to show here"),
	write("can you disprove him\nEnter \"y.\" or \"n.\"\n"),
	read(B),
	(B == n ->
		nextPlayer(Disprover, N),
		disproveSuggestion(S, W, R, Suggester, N);
	B == y ->
		write("we disproved him\n")).

opponentDisprove(S, W, R, Suggester, Disprover):-
	write("Can "),
	write(Disprover),
	write(' disprove the suggestion?\nEnter "y." or "n."\n'),
	read(B),
	(B == n ->
		nextPlayer(Disprover, N),
		disproveSuggestion(S, W, R, Suggester, N);
	B == y ->
		opponentDisproveHelp(Suggester, Disprover)).


opponentDisproveHelp(Suggester, Disprover):-
	(ourPlayer(Suggester) -> 
		write("Enter card shown\n"),
		read(C), 
		assert(hasCard(Disprover, C))
		;

		write(Disprover),
		write(" showed card to "),
		write(Suggester),
		nl
	).

takeOpponentTurn(Player) :-
	write("\nIts "),
	write(Player),
	write("'s turn.\n"),
	write('Enter "menu." to see available actions\n'),
	opponentTurnLoop(Player).

opponentTurnLoop(Player):-
	read(Action),
	(Action == menu ->
		displayTurnMenu,
		opponentTurnLoop(Player);
	Action == checkDetectiveNotes ->
		displayDetectiveNotes,
		opponentTurnLoop(Player);
	Action == makeSuggestion ->
		makeSuggestion(Player),
		opponentTurnLoop(Player);
	Action == makeAccusation ->
		write("not implemented yet\n"),
		opponentTurnLoop(Player);
	Action == endTurn ->
		nextPlayer(Player, Next),
		takeTurn(Next);
	Action == quitGame ->
		quitGame(quit);
	% else
		nl,
		write(Action),
		write(" is not a valid action.\n"),
		write('Enter "menu." to see available actions\n'),
		opponentTurnLoop(Player)).

quitGame(quit).

init :-
	write('Clue Assistant V1.0\n\n'),
	initVersion,
	initPlayers,
	initDetectiveNotes,
	write("\nGame setup finished.\n\n").



	
initVersion :-
	% clears old initializations
	retractall(suspect(_)),
	retractall(weapon(_)),
	retractall(room(_)),
	write('\nAre you playing the classic version, modern version, or other version?\n'),
	write('Enter one of "classic." "modern." or "other." to make your choice\n'),
	read(Version),
	initVersion(Version),
	write("\nThe game is set up as follows:\n\n"),
	displayCardLising,
	write('\nIs this correct? Type "y." or "n."\n'),
	read(X),
	reInitVersion(X).

reInitVersion(n):- initVersion.
reInitVersion(y).

displayCardLising() :-
>>>>>>> 8989d1f9d7a91e2c2dc36818b1ba2d8952edeb7c
	write('------Character list:\n'),
	findall(N1,suspect(N1),L1),
	printline(L1),
	write('------Weapon list:\n'),
	findall(N2,weapon(N2),L2),
	printline(L2),
	write('------Room list\n'),
	findall(N3,room(N3),L3),
	printline(L3).

initVersion(classic) :-
	assert(suspect(mustard)),
	assert(suspect(scarlet)),
	assert(suspect(plum)),
	assert(suspect(green)),
	assert(suspect(white)),
	assert(suspect(peacock)),

	assert(weapon(lead_pipe)),
	assert(weapon(knife)),
	assert(weapon(wrench)),
	assert(weapon(candlestick)),
	assert(weapon(rope)),
	assert(weapon(revolver)),

	assert(room(hall)),
	assert(room(lounge)),
	assert(room(dining_room)),
	assert(room(kitchen)),
	assert(room(ballroom)),
	assert(room(conservatory)),
	assert(room(billiard_room)),
	assert(room(library)),
	assert(room(study)).


initVersion(modern) :-
	assert(suspect(mustard)),
	assert(suspect(scarlet)),
	assert(suspect(plum)),
	assert(suspect(green)),
	assert(suspect(white)),
	assert(suspect(peacock)),

	assert(weapon(bat)),
	assert(weapon(knife)),
	assert(weapon(ax)),
	assert(weapon(candlestick)),
	assert(weapon(rope)),
	assert(weapon(pistol)),

	assert(room(hall)),
	assert(room(guest_house)),
	assert(room(dining_room)),
	assert(room(kitchen)),
	assert(room(patio)),
	assert(room(spa)),
	assert(room(theatre)),
	assert(room(living_room)),
	assert(room(observatory)).

initVersion(other) :-
	write('\nEnter all suspect names one at a time,\n'),
	write('as one word, in lowercase followed by a period.\n'),
	write('ie, to enter "Mustard", type "mustard."\n'),
	write('when finished, enter "done."\n'),
	initSuspect,
	write('\nEnter all weapon names one at a time,\n'),
	write('as one word, in lowercase followed by a period.\n'),
	write('ie, to enter "lead pipe", type "lead_pipe."\n'),
	write('when finished, enter "done."\n'),
	initWeapon,
	write('\nEnter all room names one at a time, \n'),
	write('as one word, in lowercase followed by a period.\n'),
	write('ie, to enter "dining room", type "dining_room."\n'),
	write('when finished, enter "done."\n'),
	initRoom.


initVersion(_) :-
	write('Invalid selection.\n'),
	initVersion.


initSuspect :-
	read(Suspect),
	initSuspect(Suspect).

initSuspect(done).
initSuspect(Suspect) :-
	assert(suspect(Suspect)),
	initSuspect.


initWeapon :-
	read(Weapon),
	initWeapon(Weapon).

initWeapon(done).
initWeapon(Weapon) :-
	assert(weapon(Weapon)),
	initWeapon.


initRoom :-
	read(Room),
	initRoom(Room).

initRoom(done).
initRoom(Room) :-
	assert(room(Room)),
	initRoom.


initPlayers :-
	% clears old initializations
	retractall(player(_)),
	retractall(ourPlayer(_)),
	retractall(nextPlayer(_,_)),
	write('\nEnter the name of all players in the order they play in.\n'),
	write('First enter the player who goes first,\n'),
	write('then the player who goes second, and continue until the last player.\n'),
	write('As before use only lowercase and single words per player.\n'),
	write('After entering all players, enter "done." to finish.\n'),
	read(StartPlayer),
	initPlayer(StartPlayer),
	retract(nextPlayer(LastPlayer, done)),
	assert(nextPlayer(LastPlayer, StartPlayer)),
	write('\nPlayer Order:\n'),
	findall(N,player(N),L),
	printline(L),
	write('\nIs this correct? Type "y." or "n."\n'),
	read(X),
	reInitPlayers(X).

reInitPlayers(n):- initPlayers.
reInitPlayers(y).




initPlayer(done).
initPlayer(PrevPlayer) :-
	assert(player(PrevPlayer)),
	read(Player),
	assert(nextPlayer(PrevPlayer,Player)),
	initPlayer(Player).


initDetectiveNotes :-
	getOurPlayer(Player),
	recordOurCards(Player),
	assert(ourPlayer(Player)).


getOurPlayer(Player) :-
	write("\nWhich player is you?\n"),
	read(Player2),
	(\+player(Player2)->
		write("\nThat player is not in this game\n"),
		write("Need to select one of the following:\n"),
		findall(N,player(N),L),
	    printline(L),
	    getOurPlayer(Player);
	    Player = Player2).

recordOurCards(Player) :-
	% clears old initializations
	retractall(hasCard(_,_)),
	write("\nEnter the cards that you've been dealt.\n"),
	write('When finished, enter "done."\n'),
	write("Names must exactly match this program's game setup.\n"),
	write('To see this setup, enter "showSetup."\n'),
	read(Card),
	recordCards(Player, Card).

recordCards(_, done).
recordCards(Player, Card) :-
	(suspect(Card)->
		assert(hasCard(Player, Card)); 
	weapon(Card)->
		assert(hasCard(Player, Card)); 
	room(Card)->
		assert(hasCard(Player, Card));
	 Card == showSetup ->
	 	write("\n"),
	 	displayCardLising,
	 	write("\n");
	 Card \== done -> 
		write('Card "'),
		write(Card),
		write('" is not in this game\n'),
		write('To see which cards are, enter "showSetup"\n')),
	read(Card2),
	recordCards(Player, Card2).


printline([]).
printline([H|T]) :-
	write(H),nl,
	printline(T).

<<<<<<< HEAD
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
=======

>>>>>>> 8989d1f9d7a91e2c2dc36818b1ba2d8952edeb7c
