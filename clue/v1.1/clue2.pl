
dynamic suspect/1.
dynamic weapon/1.
dynamic room/1.
dynamic player/1.
dynamic nextPlayer/2.
dynamic ourPlayer/1.
dynamic hasCard/2.
dynamic hasno/2.
dynamic out/1.


clue :-
    init,
    play.

play:-
    write("Game has started.\n"),
    write(""),
    player(FirstPlayer),
    takeTurn(FirstPlayer).

startNewGame :-
    write("Start a new game?\nEnter \"y.\" or \"n.\"\n"),
    read(A),
    (A == y ->
        write("Same game version?\nEnter \"y.\" or \"n.\"\n"),
        read(B),
        (B == y ->
            initPlayer,
            initDetectiveNotes,
            write("\nGame setup finished.\n\n"),
            play;
        B == n ->
            clue)
        ;
    A == n ->
        quitGame(quit)).

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

takeTurn(Player) :-
	(out(Player) ->
		nextPlayer(Player,Next),
    		takeTurn(Next);
	(ourPlayer(Player) ->
		takeOurTurn(Player);
	takeOpponentTurn(Player))).

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
        write("Our turn ends.\n"),
        (checkWin ->
            startNewGame
            ;
            risky,
            nextPlayer(Player, Next),
            takeOpponentTurn(Next));    %can add accusation function, also endTurn
    Action == makeAccusation ->
        makeAccusation,
        ourTurnLoop(Player);
    Action == endTurn ->
        nextPlayer(Player, Next),
        takeTurn(Next);
    Action == cheat ->
        cheat(Player);
    Action == quitGame ->
        quitGame(quit);
    % else
        nl,
        write(Action),
        write(" is not a valid action.\n"),
        write('Enter "menu." to see available actions\n\n'),
        ourTurnLoop(Player)).

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

cheat(Player) :-

    dealRoom(Player),
   
    nextPlayer(Player, N),
    disproveSuggestion(S, W, R, Player, N).

dealRoom(Player) :-
    displayDetectiveNotes,
    write("Which room can you reach? (type all, end with 'done.' or 'none' if you can't\n"),
    read(Action),
    (Action == done ->
   	suspect(S),
	allHasno(S),
    	weapon(W),
	allHasno(W),
	findall(R,reachroom(R),L1),
	(length(L1,1) ->
		L1 = [H|T],
		R1 = H;
	(bestroom(L1,R2) ->
		write("Make this suggestion so you can get more information:\n"),
    		write("---It was "), write(S), write(" with "), write(W), write(" in the "), write(R2),nl;
	L1 = [H3|T3],
	write("Make this suggestion so you can get more information:\n"),
	write("---It was "), write(S), write(" with "), write(W), write(" in the "), write(R2),nl
	
bestroom([H|T],R) :-
	allHasno(H),
	R = H.
bestroom([H|T],R) :-
	allHasno(T,R).

allHasno(Name) :-
    (\+ hasCard(_,Name)).


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
    write(" in the "),
    write(R),
    nl,
    nl,
    disproveAccusation(S, W, R, Player, N).

disproveAccusation(S, W, R, Accusator, Next) :-
    write("Is it true?\nEnter \"y.\" or \"n.\"\n"),
    read(B),
    (B == y ->
        write("Player"), write(Accusator), write("wins the game!"),nl,
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

disproveAll(_,_,_,[]).
disproveAll(S,W,R,[H|T]) :-
    assert(hasno(H,S)),
    assert(hasno(H,W)),
    assert(hasno(H,R)),
    disproveAll(S,W,R,T).

playerDisprove(S, W, R, Suggester, Disprover):-
    write("we would select a card to show here\n"),
    %write("can you disprove him\nEnter \"y.\" or \"n.\"\n"),
    (hasCard(Disprover,S) ->
        write("show him "), write(S),nl,nl;
    hasCard(Disprover,W) ->
        write("show him "), write(W),nl,nl;
    hasCard(Disprover,R) ->
        write("show him "), write(R),nl,nl;
    write("You don't have any of card, so do nothing\n"),
    nextPlayer(Disprover, N),
    disproveSuggestion(S, W, R, Suggester, N)).


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
        opponentDisproveHelp(Suggester, Disprover)).


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
        quitGame(quit);
    % else
        nl,
        write(Action),
        write(" is not a valid action.\n"),
        write('Enter "menu." to see available actions\n'),
        opponentTurnLoop(Player)).

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
        quitGame(quit);
    % else
        nl,
        write(Action),
        write(" is not a valid action.\n"),
        opponentAccusation(Player)).

quitGame(quit) :-
    write("Thank you for your playing!\n").

init :-
    write('Clue Assistant V1.0\n\n'),
    initVersion,
    initPlayers,
    initDetectiveNotes,
    initOut,
    write("\nGame setup finished.\n\n").

initOut :-
    retractall(out(_)),
    assert(out(none)).

    
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

