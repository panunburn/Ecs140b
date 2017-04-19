/* ECS 140B Assignment 1 */
/* the simple version of Sudoku Solver */
/*	Name: Weiran Guo
		ID: 912916431
		test0 all work
		test1 works with approximately 28 seconds on csif machine
*/


/* For this assignment you will need to implement your 
own 9x9 Sudoku solver in SWI-Prolog.  Basically you 
have a 9x9 grid, and you must fill in the 
grid so that each row, each column, and each of 9 3x3 
grids all contain the numbers 1 through 9. */

/* You will need to fill in the sudoku predicate below, 
and also supply any helper predicates. You should think 
about what has to be true to make a sudoku table valid 
and work out how to check for each of these conditions. */

/* To test your program we will type "test." into 
SWI-Prolog and study the results. We will also attempt 
the further tests, 1, 2 and 3, if you have told us that 
they will work. (These may take too long to compute.) */

/* When grading we will be looking for solutions that 
work correctly, but we also want to see clearly commented 
code explaining what each predicate is doing. If 
your code does not work but appears to be close to the 
correct solution or your comments are along the correct 
lines, then you will receive some credit. If your code is not 
clearly commented showing an understanding of what is 
happening then you will receive considerably fewer points
than you might have otherwise. */

% WHAT YOU NEED TO HAND IN
/* You should use Canvas to submit a plain text file
named 'sudoku.pl' that contains your sudoku predicate and 
any helper predicates. We should be able to run this by 
using the tests provided. The file should contain your 
name and student numbers, plus a brief summary of 
which of the tests you think will work, or any 
extra information we will need. This is important, 
because if you think that the program should work on all 
the tests, but this information is not provided in your
submission (in some place up front where we can easily
see it), then we will assume that it doesn't work. */

/* Keep in mind that you may not use the Constraint
Logic Programming features supplied by SWI-Prolog. */

/* You must submit your solution no later than 6:00pm,
Friday, April 21, 2017. */

/* ----------- cut here ----------- */

/* include name and student number */

/* This runs all the simple tests. If it 
works correctly, you should see three identical 
and completed sudoku tables, and finally the 
word false (as test0c will fail.) */
test :-
	test0, nl,
	test0a, nl,
	test0b, nl,
	test0c.

/* This is a completly solved solution. */
test0 :-
	L = [
             [9,6,3,1,7,4,2,5,8],
             [1,7,8,3,2,5,6,4,9],
             [2,5,4,6,8,9,7,3,1],
             [8,2,1,4,3,7,5,9,6],
             [4,9,6,8,5,2,3,1,7],
             [7,3,5,9,6,1,8,2,4],
             [5,8,9,7,1,3,4,6,2],
             [3,1,7,2,4,6,9,8,5],
             [6,4,2,5,9,8,1,7,3]],
        sudoku(L),
        printsudoku(L).

/* This has a solution (the one in test0) which 
should be found very quickly. */
test0a :-
	L = [
             [9,_,3,1,7,4,2,5,8],
             [_,7,_,3,2,5,6,4,9],
             [2,5,4,6,8,9,7,3,1],
             [8,2,1,4,3,7,5,_,6],
             [4,9,6,8,5,2,3,1,7],
             [7,3,_,9,6,1,8,2,4],
             [5,8,9,7,1,3,4,6,2],
             [3,1,7,2,4,6,9,8,5],
             [6,4,2,5,9,8,1,7,3]],
        sudoku(L),
        printsudoku(L).

/* This has a solution (the one in test0) and 
may take a few seconds to find. */
test0b :-
	L = [
             [9,_,3,1,7,4,2,5,_],
             [_,7,_,3,2,5,6,4,9],
             [2,5,4,6,_,9,_,3,1],
             [_,2,1,4,3,_,5,_,6],
             [4,9,_,8,_,2,3,1,_],
             [_,3,_,9,6,_,8,2,_],
             [5,8,9,7,1,3,4,6,2],
             [_,1,7,2,_,6,_,8,5],
             [6,4,2,5,9,8,1,7,3]],
        sudoku(L),
        printsudoku(L).

/* This one obviously has no solution (column 2 has 
two nines in it.) and it may take a few seconds 
to deduce this. */
test0c :-
	L = [
             [_,9,3,1,7,4,2,5,8],
             [_,7,_,3,2,5,6,4,9],
             [2,5,4,6,8,9,7,3,1],
             [8,2,1,4,3,7,5,_,6],
	     [4,9,6,8,5,2,3,1,7],
             [7,3,_,9,6,1,8,2,4],
             [5,8,9,7,1,3,4,6,2],
             [3,1,7,2,4,6,9,8,5],
             [6,4,2,5,9,8,1,7,3]],
        sudoku(L),
        printsudoku(L).

/* Here is an extra test for you to try. It would be
nice if your program can solve this puzzle, but it's
not a requirement. */

test0d :-
	L = [
             [9,_,3,1,_,4,2,5,_],
             [_,7,_,3,2,5,6,4,9],
             [2,5,4,6,_,9,_,3,1],
             [_,2,1,4,3,_,5,_,6],
             [4,9,_,8,_,2,3,1,_],
             [_,3,_,9,6,_,8,2,_],
             [5,8,9,7,1,3,4,6,2],
             [_,1,7,2,_,6,_,8,5],
             [6,4,2,5,_,8,1,7,3]],
        sudoku(L),
        printsudoku(L).


/* The next 3 tests are supposed to be progressively 
harder to solve. The solver we demonstrated in class
did not find a solution in a reasonable length of time for 
any of these, so if you manage to write a solver 
that does them in a reasonable length of time, 
expect to receive bonus points (what’s a reasonable
length of time?  Let’s call it 5 minutes. (BUT YOU 
MUST TELL US IN YOUR SUBMISSION THAT YOUR SOLVER
WORKS ON THESE TESTS OR WE WON'T RUN THESE TESTS
AND YOU WON’T GET THE BONUS POINTS YOU DESERVE.) */
test1 :-
	L = [
             [_,6,_,1,_,4,_,5,_],
             [_,_,8,3,_,5,6,_,_],
             [2,_,_,_,_,_,_,_,1],
             [8,_,_,4,_,7,_,_,6],
             [_,_,6,_,_,_,3,_,_],
             [7,_,_,9,_,1,_,_,4],
             [5,_,_,_,_,_,_,_,2],
             [_,_,7,2,_,6,9,_,_],
             [_,4,_,5,_,8,_,7,_]],
        sudoku(L),
        printsudoku(L).

test2 :-
	L = [
             [_,_,4,_,_,3,_,7,_],
             [_,8,_,_,7,_,_,_,_],
             [_,7,_,_,_,8,2,_,5],
             [4,_,_,_,_,_,3,1,_],
             [9,_,_,_,_,_,_,_,8],
             [_,1,5,_,_,_,_,_,4],
             [1,_,6,9,_,_,_,3,_],
             [_,_,_,_,2,_,_,6,_],
             [_,2,_,4,_,_,5,_,_]],
        sudoku(L),
        printsudoku(L).

test3 :-
	L = [
             [_,4,3,_,8,_,2,5,_],
             [6,_,_,_,_,_,_,_,_],
             [_,_,_,_,_,1,_,9,4],
             [9,_,_,_,_,4,_,7,_],
             [_,_,_,6,_,8,_,_,_],
             [_,1,_,2,_,_,_,_,3],
             [8,2,_,5,_,_,_,_,_],
             [_,_,_,_,_,_,_,_,5],
             [_,3,4,_,9,_,7,1,_]],
        sudoku(L),
        printsudoku(L).


% print sudoku table
printsudoku([]).
printsudoku([H|T]) :-
	write(H),nl,
	printsudoku(T).


% Expects a list of lists 9 by 9 grid.
sudoku(L) :-                                       % the simple version of sudoku solver
	L = [																						 % match each item in matrix with a variable name
	      [A1, A2, A3, A4, A5, A6, A7, A8, A9],
	      [B1, B2, B3, B4, B5, B6, B7, B8, B9],
        [C1, C2, C3, C4, C5, C6, C7, C8, C9],
        [D1, D2, D3, D4, D5, D6, D7, D8, D9],
        [E1, E2, E3, E4, E5, E6, E7, E8, E9],
        [F1, F2, F3, F4, F5, F6, F7, F8, F9],
        [G1, G2, G3, G4, G5, G6, G7, G8, G9],
        [H1, H2, H3, H4, H5, H6, H7, H8, H9],
        [I1, I2, I3, I4, I5, I6, I7, I8, I9]
			],

	Values = [1,2,3,4,5,6,7,8,9], 									 % 9 possible values

	/*Square1 = [A1, A2, A3,B1, B2, B3,C1, C2, C3],
	Square2 = [A4, A5, A6,B4, B5, B6,C4, C5, C6],
	Square3 = [A7, A8, A9,B7, B8, B9,C7, C8, C9],
	Square4 = [D1, D2, D3,E1, E2, E3,F1, F2, F3],
	Square5 = [D4, D5, D6,E4, E5, E6,F4, F5, F6],
	Square6 = [D7, D8, D9,E7, E8, E9,F7, F8, F9],
	Square7 = [G1, G2, G3,H1, H2, H3,I1, I2, I3],
	Square8 = [G4, G5, G6,H4, H5, H6,I4, I5, I6],
	Square9 = [G7, G8, G9,H7, H8, H9,I7, I8, I9],*/

	minidoku(A1, A2, A3,B1, B2, B3,C1, C2, C3,Values,Values,Values,Values,Values,Values,Values, RR1,RR2,RR3,CR1,CR2,CR3), % attemp Square1 with no constraint, i.e all 9 values in the list
	minidoku(A4, A5, A6,B4, B5, B6,C4, C5, C6,RR1,RR2,RR3,Values,Values,Values,Values, RR11,RR12,RR13,CR11,CR12,CR13),    % attemp Square2 with row constraints that were generate from Square1
	minidoku(A7, A8, A9,B7, B8, B9,C7, C8, C9,RR11,RR12,RR13,Values,Values,Values,Values,RR21,RR22,RR23,CR21,CR22,CR23),  % attemp Square3 with row constraints that were generate from Square2
	minidoku(D1, D2, D3,E1, E2, E3,F1, F2, F3,Values,Values,Values,CR1,CR2,CR3,Values,RR31,RR32,RR33,CR31,CR32,CR33),     % attemp Square4 with col constraints that were generate from Square1
	minidoku(D4, D5, D6,E4, E5, E6,F4, F5, F6,RR31,RR32,RR33,CR11,CR12,CR13,Values,RR41,RR42,RR43,CR41,CR42,CR43),        % attemp Square5 with both row(Square4) and col(Square2) constraints
	minidoku(D7, D8, D9,E7, E8, E9,F7, F8, F9,RR41,RR42,RR43,CR21,CR22,CR23,Values,RR51,RR52,RR53,CR51,CR52,CR53),				% attemp Square6 with both row(Square5) amd col(Square3) constraints
	minidoku(G1, G2, G3,H1, H2, H3,I1, I2, I3,Values,Values,Values,CR31,CR32,CR33,Values,RR61,RR62,RR63,CR61,CR62,CR63),  % attemp Square7 with col constraints that were generate from Square4
	minidoku(G4, G5, G6,H4, H5, H6,I4, I5, I6,RR61,RR62,RR63,CR41,CR42,CR43,Values,RR71,RR72,RR73,CR71,CR72,CR73),				% attemp Square8 with both row(Square7) and col(Square5) constraints
	minidoku(G7, G8, G9,H7, H8, H9,I7, I8, I9,RR71,RR72,RR73,CR51,CR52,CR53,Values,RR81,RR82,RR83,CR81,CR82,CR83).				% attemp Square9 with both row(Square8) and col(Square6) constraints

% YOU NEED TO COMPLETE THIS PREDICATE, PLUS PROVIDE ANY HELPER PREDICATES BELOW.
minidoku(A1, A2, A3,B1, B2, B3,C1, C2, C3, RG1,RG2,RG3,CG1,CG2,CG3,SG1, RR1,RR2,RR3,CR1,CR2,CR3) :-        % try to solve the minidoku 3*3 with row, colume and square constraints
	remain(RG1,CG1,SG1,A1,Rowrem11,Colrem11,Sqrrem1),           % three elements in row 1
	remain(Rowrem11,CG2,Sqrrem1,A2,Rowrem12,Colrem12,Sqrrem2),
	remain(Rowrem12,CG3,Sqrrem2,A3,Rowrem13,Colrem13,Sqrrem3),

	remain(RG2,Colrem11,Sqrrem3,B1,Rowrem21,Colrem21,Sqrrem4),  % three elements in row 2
	remain(Rowrem21,Colrem12,Sqrrem4,B2,Rowrem22,Colrem22,Sqrrem5),
	remain(Rowrem22,Colrem13,Sqrrem5,B3,Rowrem23,Colrem23,Sqrrem6),

	remain(RG3,Colrem21,Sqrrem6,C1,Rowrem31,Colrem31,Sqrrem7),  % three elements in row 3
	remain(Rowrem31,Colrem22,Sqrrem7,C2,Rowrem32,Colrem32,Sqrrem8),
	remain(Rowrem32,Colrem23,Sqrrem8,C3,Rowrem33,Colrem33,Sqrrem9),
	RR1 = Rowrem13,    %return the corresponding remain list
	RR2 = Rowrem23,
	RR3 = Rowrem33,
	CR1 = Colrem31,
	CR2 = Colrem32,
	CR3 = Colrem33,
	SR1 = Sqrrem9.

remain(Rows,Cols,Sqrs,Val,Rowrem,Colrem,Sqrrem):-      %this predicate find the remaining possible list by excluding the current guess variable
	exclude(Rows,Val,Rowrem),
	exclude(Cols,Val,Colrem),
	exclude(Sqrs,Val,Sqrrem).

exclude([H|T],H,T).        % if guess variable is the head
exclude([H|T],Val,[H|R]):- % if not on the head
	exclude(T,Val,R).        % check body list

/*alldifferent([]).
alldifferent([X|Xs]) :-
	different(X,Xs),
	alldiffrent(Xs).

different(X,[]).
different(X,[H|T]) :-
	\+ X = H,
	different(X,T).

validrow(Val,Row):-
	value(Val),
	Row = [H|T],


validcol(Val,Col):-

validsquarr(Val,Square):-

transpose([],[]).
transpose([F|R],Tm).*/

