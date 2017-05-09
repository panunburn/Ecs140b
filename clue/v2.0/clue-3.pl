%Weiran Guo(912916431)
%Allen Speers(912113700)
/*************************************************************************************
This is a Clue game assistant!
Clue is a popular board game which has many version of it,
This program is disigned to help players to win the game by making useful suggestions
To suffice the needs of different group of player, there are two built-in version of 
Clue, and you can set up cards by youself without a limitation!
*************************************************************************************/

dynamic suspect/1.
dynamic weapon/1.
dynamic room/1.
dynamic player/1.
dynamic nextPlayer/2.
dynamic ourPlayer/1.
dynamic hasCard/2.
dynamic hasno/2.
dynamic out/1.
dynamic reachroom/1.

%Start the program
clue :-
    init,          %initialize this game, functions are at the beginning of file
    play.	   %play this game, functions are after init part

/**************************************************
These are the initialization of the clue assistant,
since you might restart a game after finishing last
one, it is nessessary to clear all the older data
and reset the game version
**************************************************/
init :-
    write('Clue Assistant V2.0\n\n'),
    initVersion,
    initPlayers,
    initDetectiveNotes,
    initOut,
    write("\nGame setup finished.\n\n").
 
/***************************************************
initVersion is the part to retract all the old data,
and get the game version info from user, and build 
up new useful environment
***************************************************/
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
    write('------Character list:\n'),
    findall(N1,suspect(N1),L1),
    printline(L1),
    write('------Weapon list:\n'),
    findall(N2,weapon(N2),L2),
    printline(L2),
    write('------Room list\n'),
    findall(N3,room(N3),L3),
    printline(L3).

%build-in version
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

%get user desired version
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
    (suspect(Suspect) ->
	initSuspect;
    assert(suspect(Suspect)),
    initSuspect).


initWeapon :-
    read(Weapon),
    initWeapon(Weapon).

initWeapon(done).
initWeapon(Weapon) :-
    (weapon(Weapon) ->
	initWeapon;
    assert(weapon(Weapon)),
    initWeapon).


initRoom :-
    read(Room),
    initRoom(Room).

initRoom(done).
initRoom(Room) :-
    (room(Room) ->
	initRoom;
    assert(room(Room)),
    initRoom).

%The player who already lose the game, at the beginning, there is no loser,
%so set up the out predicate with a impossible name
initOut :-
    retractall(out(_)),
    assert(out(impossible_name233)).

%initialize player information, get there name, position
initPlayers :-
    % clears old initializations
    retractall(player(_)),
    retractall(ourPlayer(_)),
    retractall(nextPlayer(_,_)),
    write('\nEnter the name of all players in the order they play in.\n'),
    write('First enter the player who goes first,\n'),
    write('then the player who goes second, and continue until the last player.\n'),
    write('As before use only lowercase and single words per player.\n'),
    write('After entering all players, enter "done." to finish\n'),
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

%Initialize Detective Notes, it is useful to user - who has which card
initDetectiveNotes :-
    getOurPlayer(Player),
    recordOurCards(Player),
    assert(ourPlayer(Player)).

%knon which player is using this program
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

%get the initial dealt cards info
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

/***************************************************************************
Play part, by accepting living information, make suggestions to user to try
to help user win the game.
***************************************************************************/

play:-
    write("Game has started.\n"),
    write(""),
    player(FirstPlayer),  %get the first player by position
    takeTurn(FirstPlayer).%start from the first player

%if the game ends, ask if they start a new one

startNewGame :-
    write("Start a new game?\nEnter \"y.\" or \"n.\"\n"),
    read(A),
    (A == y ->
        write("Same game version?\nEnter \"y.\" or \"n.\"\n"),
        read(B),
        (B == y ->
            initPlayers,
            initDetectiveNotes,
	    initOut,
            write("\nGame setup finished.\n\n"),
            play;
        B == n ->
            clue)
        ;
    A == n ->
        quitGame(quit)).

%print available actions
%here are the display parts of program, which interacts with user frequently
displayTurnMenu :-
    write("\nThe following actions are available:\n"),
    write(" - checkDetectiveNotes\n"),
    write(" - makeSuggestion\n"),
    write(" - cheat (I will generate a suggestion for you)\n"),
    write(" - makeAccusation\n"),
    write(" - endTurn\n"),
    write(" - quitGame\n\n").

displayOppoMenu :-
    write("\nThe following actions are available:\n"),
    write(" - checkDetectiveNotes\n"),
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


%in the turn of current player
takeTurn(Player) :-
	(out(Player) ->   %if this player is out, he can do nothing, so jump to next player
		nextPlayer(Player,Next),
    		takeTurn(Next);
	ourPlayer(Player) -> %if i am playing
		takeOurTurn(Player);
	takeOpponentTurn(Player)). %if it is opponent's turn '

%if it is my turn
takeOurTurn(Player) :-
    write("\nIts your turn.\n"),
    write('Enter "menu." to see available actions\n\n'),
    ourTurnLoop(Player).

%waiting for input from user, which can ask for menu, Notes, he might make suggestion by himself
%or he can ask the program to compute a suggestion that helps him win
%after each suggestion, the program will compute the possibility of winning of game by making a 
%accusation, however, user can make accusation by himself directly in the menu, he can end 
%turn or quit game anytime.
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
        write("Our turn ends.\n"),
        (checkWin ->
            startNewGame
            ;
            risky,
            nextPlayer(Player, Next),
            takeOpponentTurn(Next));    %can add accusation function, also endTurn
    Action == makeAccusation ->
        makeAccusation(Player),
        ourTurnLoop(Player);
    Action == endTurn ->
        nextPlayer(Player, Next),
        takeTurn(Next);
    Action == cheat ->
        cheat(Player),
	
	write("Our turn ends\n"),
	(checkWin ->
            startNewGame
            ;
            risky,
            nextPlayer(Player, Next),
            takeOpponentTurn(Next));
    Action == quitGame ->
        quitGame(quit);
    % else
        nl,
        write(Action),
        write(" is not a valid action.\n"),
        write('Enter "menu." to see available actions\n\n'),
        ourTurnLoop(Player)).

%generate the risky info to user
risky :-
    generatePossibility(P),
    write("There is "), write(P),write(" percent possibility to win this game by accusation, do you want to make it? y/n\n"),
    read(Char),
    (Char == y ->
        chooseFirst
    ;
    Char == n ->
        write("Let's continue\n");
    write("invalid input\n"),
    risky).

%when many items are available, and they are equally possible, user want to make a choice
chooseFirst :-
    findall(S1, checkSuspect(S1), Knownsus),
    findall(S2, suspect(S2), Allsus),

    findall(R1, checkRoom(R1), Knownroom),
    findall(R2, room(R2), Allroom),

    findall(W1, checkWeapon(W1), Knownweapon),
    findall(W2, weapon(W2), Allweapon),

    subtract(Allsus,Knownsus,A1),
    subtract(Allroom,Knownroom,A2),
    subtract(Allweapon,Knownweapon,A3),

    A1 = [Remnsus|_],
    A2 = [Remroom|_],
    A3 = [Remweapon|_],
    nl,nl,
    write("Make this accusation then you might win!\n"),nl,nl,
    write("---It was "), write(Remnsus), write(" with "), write(Remweapon), write(" in the "), write(Remroom),nl,
    followLoop.

%the computing part of each turn, generate suggestion to the user by known info
cheat(Player) :-
    displayDetectiveNotes,
    write("Which room can you reach? (type all, end with 'done.' or 'none' if you can't\n"),
    read(Action),
    (Action == done ->
   	suspect(S),
	allHasno(S),!,
    	weapon(W),
	allHasno(W),!,
	findall(R,reachroom(R),L1),
	(length(L1,1) ->
		L1 = [H|T],
		write("Make this suggestion so you can get more information:\n"),
		write("---It was "), write(S), write(" with "), write(W), write(" in the "), write(H),nl,
		R4 = H,
		retractall(reachroom(_));
	(bestroom(L1,R2) ->
		write("Make this suggestion so you can get more information:\n"),
    		write("---It was "), write(S), write(" with "), write(W), write(" in the "), write(R2),nl,
		R4 = R2,
		retractall(reachroom(_));
	L1 = [H3|T3],
	write("Make this suggestion so you can get more information:\n"),
	write("---It was "), write(S), write(" with "), write(W), write(" in the "), write(H3),nl)),
	followloop2,
	R4 = H3,
	nextPlayer(Player,N),
	disproveSuggestion(S,W,R4,Player,N),!,
	retractall(reachroom(_));
    Action == none ->
	true;
    room(Action) ->
	assert(reachroom(Action)),
	cheat(Player)).
	
%choose best room in available rooms
bestroom([H|T],R) :-
	allHasno(H),
	R = H.
bestroom([H|T],R) :-
	bestroom(T,R).

%if anyone has this card, then false --- this can lead to a card that no one holds
allHasno(Name) :-
    (\+ hasCard(_,Name)).

%generate possibility
generatePossibility(P) :-
    findall(S1, checkSuspect(S1), Knownsus),
    findall(S2, suspect(S2), Allsus),
    length(Knownsus,N1),
    length(Allsus,N2),

    findall(R1, checkRoom(R1), Knownroom),
    findall(R2, room(R2), Allroom),
    length(Knownroom,N3),
    length(Allroom,N4),

    findall(W1, checkWeapon(W1), Knownweapon),
    findall(W2, weapon(W2), Allweapon),
    length(Knownweapon,N5),
    length(Allweapon,N6),

    P is 100/((N2 - N1) *(N4 - N3) * (N6 - N5)).

%at each turn, after the suggestion part, the program will automatically check if user
%can win this game with 100 percent possibility
checkWin :-
    findall(S1, checkSuspect(S1), Knownsus),
    findall(S2, suspect(S2), Allsus),
    length(Knownsus,N1),
    length(Allsus,N2),
    N2 is N1 + 1,
    findall(R1, checkRoom(R1), Knownroom),
    findall(R2, room(R2), Allroom),
    length(Knownroom,N3),
    length(Allroom,N4),
    N4 is N3 + 1,
    findall(W1, checkWeapon(W1), Knownweapon),
    findall(W2, weapon(W2), Allweapon),
    length(Knownweapon,N5),
    length(Allweapon,N6),
    N6 is N5 + 1,
    subtract(Allsus,Knownsus,A1),
    subtract(Allroom,Knownroom,A2),
    subtract(Allweapon,Knownweapon,A3),
    A1 = [Remnsus|_],
    A2 = [Remroom|_],
    A3 = [Remweapon|_],
    nl,nl,
    write("Make this accusation then you could win!\n"),nl,nl,
    write("---It was "), write(Remnsus), write(" with "), write(Remweapon), write(" in the "), write(Remroom),nl,
    followLoop.

%Force the user to follow the best instruction
followLoop :-
    write("Did you follow my instruction?\n y/n"),
    read(D),
    (D == y ->
        write("Did you win? Type \"y.\" or \"n.\"\n"),
        read(C),
        (C == y ->
            write("Congratulations!\n");
        C == n ->
            write("Unfortunately, you lose\n"),
            startNewGame;
        followLoop);
    D == n ->
        write("Please don't do that\n"),
        followLoop;
    %else
    followLoop).

followloop2 :-
    write("Did you follow my instruction?\n y/n"),
    read(D),
    (D == y ->
        write("Well done!\n");
    D == n ->
        write("Please don't do that\n"),
        followloop2;
    %else
    followloop2).

%subtract a list from another list, get the remaining list
subtract([], _, []).
subtract([Head|Tail], L2, L3) :-
    member(Head, L2),
    !,
    subtract(Tail, L2, L3).
subtract([Head|Tail1], L2, [Head|Tail3]) :-
    subtract(Tail1, L2, Tail3).

checkSuspect(Item) :-
    hasCard(_,Suspect),
    suspect(Suspect),
    Item = Suspect.

checkRoom(Item) :-
    hasCard(_,Room),
    room(Room),
    Item = Room.

checkWeapon(Item) :-
    hasCard(_,Weapon),
    weapon(Weapon),
    Item = Weapon.

%make accusation if player desires
makeAccusation(Player) :-
    displayDetectiveNotes,
    getSuspectSuggestion(S),
    getWeaponSuggestion(W),
    getRoomSuggestion(R),
    nextPlayer(Player, N),
    nl,
    write(Player),
    write(" accuses that it was\n"),
    write(S),
    write(" with the "),
    write(W),
    write(R),
    nl,
    nl,
    disproveAccusation(S, W, R, Player, N).

%check if accusation is correct
disproveAccusation(S, W, R, Accusator, Next) :-
    write("Is it true?\nEnter \"y.\" or \"n.\"\n"),
    read(B),
    (B == y ->
        write("Player "), write(Accusator), write(" wins the game!"),nl,nl,nl,nl,
        startNewGame;
    B == n ->
        disproveAccusationHelper(S, W, R, Accusator, Next)).

disproveAccusationHelper(S, W, R, Accusator, Next) :-
    (ourPlayer(Accusator) ->
        write("You are out!\n"),
        startNewGame

        ;

        write("Player "), write(Accusator), write(" out!\n"),
        nextPlayer(P1,Accusator),
        assert(out(Accusator)),
        takeTurn(Next)).

%if player want to make suggestion himself
makeSuggestion(Player) :-
    displayDetectiveNotes,
    getSuspectSuggestion(S),
    getWeaponSuggestion(W),
    getRoomSuggestion(R),
    nextPlayer(Player, N),
    nl,
    write(Player),
    write(" suggests that it was\n"),   % can add a loop W.G
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

%get the reaction of players after a suggestion has been made
disproveSuggestion(S, W, R, P, P):-
    write("\nWow! Nobody could disprove the suggestion, we know no one (exclude "), write(P), write(" has "),
    write(S), write(" "), write(W), write(" and "), write(R), write("!\n\n"),
    findall(M,player(M),L1),
    subtract(L1,[P],I1),
    disproveAll(S,W,R,I1).

disproveSuggestion(S, W, R, Suggester, Disprover):-
    (ourPlayer(Disprover) ->
        playerDisprove(S, W, R, Suggester, Disprover)
        ;
        opponentDisprove(S, W, R, Suggester, Disprover)
        

        ).

%if no one make a disproval
disproveAll(_,_,_,[]).
disproveAll(S,W,R,[H|T]) :-
    assert(hasno(H,S)),
    assert(hasno(H,W)),
    assert(hasno(H,R)),
    disproveAll(S,W,R,T).

%check if user should make a disproval when no one makes before him,
%generate the best disproval choice if nessessary
playerDisprove(S, W, R, Suggester, Disprover):-
    write("we would select a card to show here\n"),
                                  %write("can you disprove him\nEnter \"y.\" or \"n.\"\n"),
    followloop2,
    (hasCard(Disprover,S) ->
        write("show him "), write(S),nl,nl;
    hasCard(Disprover,W) ->
        write("show him "), write(W),nl,nl;
    hasCard(Disprover,R) ->
        write("show him "), write(R),nl,nl;
    write("You don't have any of card, so do nothing\n"),
    nextPlayer(Disprover, N),
    disproveSuggestion(S, W, R, Suggester, N)).

%check if opponent disprove the suggestion
opponentDisprove(S, W, R, Suggester, Disprover):-
    write("Can "),
    write(Disprover),
    write(' disprove the suggestion?\nEnter "y." or "n."\n'),
    read(B),
    (B == n ->
        disproveAll(S,W,R,[Disprover]),
        nextPlayer(Disprover, N),
        disproveSuggestion(S, W, R, Suggester, N);
    B == y ->
        opponentDisproveHelp(Suggester, Disprover);
    opponentDisprove(S, W, R, Suggester, Disprover)).


opponentDisproveHelp(Suggester, Disprover):-
    (ourPlayer(Suggester) -> 
        write("Enter card shown\n"),
        read(C), 
        assert(hasCard(Disprover, C))
        ;

        write(Disprover),
        write(" showed card to "),
        write(Suggester), %can add guess function
        nl
    ).

%the opponents turn, when they are playing, player can check menu anytime
takeOpponentTurn(Player) :-
    write("\nIts "),
    write(Player),
    write("'s turn.\n"),
    write('Enter "menu." anytime to see available actions\n'),
    opponentTurnLoop(Player).

opponentTurnLoop(Player):-
    write("Does "), write(Player), write(" make a suggestion?\n enter y/n \n"),

    read(Action),
    (Action == menu ->
        displayOppoMenu,
        opponentTurnLoop(Player);
    Action == checkDetectiveNotes ->
        displayDetectiveNotes,
        opponentTurnLoop(Player);
    Action == y ->
        makeSuggestion(Player),
        opponentAccusation(Player),
        opponentTurnLoop(Player);
    Action == n ->
        opponentAccusation(Player),
        nextPlayer(Player, Next),
        takeTurn(Next);

    Action == quitGame ->
        quitGame(quit),!;
    % else
        nl,
        write(Action),
        write(" is not a valid action.\n"),
        write('Enter "menu." to see available actions\n'),
        opponentTurnLoop(Player)).


%if opponent makes an accusation
opponentAccusation(Player) :-
    write("Does "), write(Player), write(" make an accusation? y/n\n"),
    read(Action),
    (Action == menu ->
        displayOppoMenu,
        opponentAccusation(Player);
    Action == y ->
        makeAccusation(Player);
    Action == n ->
        nextPlayer(Player, Next),
        takeTurn(Next);
    Action == quitGame ->
        quitGame(quit),!;
    % else
        nl,
        write(Action),
        write(" is not a valid action.\n"),
        opponentAccusation(Player)).

%quit game peacefully
quitGame(quit) :-
    write("Thank you for your playing!\n"),
    halt.



%useful predicate
printline([]).
printline([H|T]) :-
    write(H),nl,
    printline(T).

