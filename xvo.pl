% Kristine Johnson
% Comp 360 Final Project
% http://en.wikipedia.org/wiki/Tic_tac_toe
% http://patorjk.com/software/taag/

% The board layout looks like this:
%  _____
% |1|2|3|
% |4|5|6|
% |7|8|9|
%  ‾‾‾‾‾
% Player is X; always goes first. Computer is O.

%===============================================================================

% The guts of the game.

% Spaces needed to get a winning three-in-a-row combination.
win(1,2,3).	% rows
win(4,5,6).
win(7,8,9).
win(1,4,7).	% columns
win(2,5,8).
win(3,6,9).
win(1,5,9).	% diagonals
win(3,5,7).

% Allows spaces to be played in any order to get three-in-a-row.
line(S1,S2,S3) :-
	win(T1,T2,T3),
	permutation([T1,T2,T3],[S1,S2,S3]).

% A space is taken (played) if a player has marked it.
taken(S) :- x(S).
taken(S) :- o(S).

% Conversely, a space is empty if no player has marked it!
empty(S) :- \+ taken(S).

% The game must end when the board has no more empty spaces.
fullboard :-
	taken(1), taken(2), taken(3),
	taken(4), taken(5), taken(6),
	taken(7), taken(8), taken(9).

% Game over. Determines who wins!
gameover :-
	fullboard,
	nl,
	writeln('It\'s a draw!'),
	nl.
gameover :-
	win(S1,S2,S3),
	x(S1), x(S2), x(S3),
	nl,
	writeln('You win! Congratulations!'),
	nl.
% Unfortunately, the best you can ever do against this AI is get a draw...
gameover :-
	win(S1,S2,S3),
	o(S1), o(S2), o(S3),
	nl,
	writeln('Computer wins. Sorry; good game!'),
	nl.

%------------------------------------------------------------------------------

% AI for playing a perfect game of tic-tac-toe. Thanks, Wikipedia (and MIT)!
move(S) :-
	strategy(S),
	empty(S).
strategy(S) :- goftw(S).
strategy(S) :- block(S).
strategy(S) :- fork(S).
strategy(S) :- blockfork(S).
strategy(S) :- center(S).
strategy(S) :- oppcorner(S).
strategy(S) :- corner(S).
strategy(S) :- middleside(S).

% Plays the third space to win!
goftw(S) :-
	o(S1),
	o(S2),
	line(S,S1,S2).

% Blocks the player from getting three-in-a-row!
block(S) :-
	x(S1),
	x(S2),
	line(S,S1,S2).

% Creates a fork, or two "intersecting" lines, which forces the player
% into unsuccessfully blocking.
fork(S) :-
	o(S1),
	o(S2),
	S1 \== S2,
	line(S,S1,T1),
	empty(T1),
	line(S,S2,T2),
	empty(T2).

% Blocks the player from creating a fork.
blockfork(S) :-
	x(S1),
	x(S2),
	S1 \== S2,
	line(S,S1,T1),
	empty(T1),
	line(S,S2,T2),
	empty(T2).

% Nabs the center spot!
center(5).

% Takes the opposite corner if/when the player takes a corner space.
oppcorner(1) :- x(9).
oppcorner(3) :- x(7).
oppcorner(7) :- x(3).
oppcorner(9) :- x(1).

% Plays an empty corner.
corner(1).
corner(3).
corner(7).
corner(9).

% Plays the middle square of a side.
middleside(2).
middleside(4).
middleside(6).
middleside(8).

%-------------------------------------------------------------------------------

% For pretty printing.

printspace(S) :-
	empty(S),
	write('_|').
printspace(S) :-
	x(S),
	write('x|').
printspace(S) :-
	o(S),
	write('o|').

printboard :-
	write(' _____ '),
	nl,
	write('|'),
	printspace(1), printspace(2), printspace(3),
	nl,
	write('|'),
	printspace(4), printspace(5), printspace(6),
	nl,
	write('|'),
	printspace(7), printspace(8), printspace(9),
	nl.

%-------------------------------------------------------------------------------

% Let's play some tic-tac-toe!

% One round. Player goes first; get input, mark desired space.
playerturn :-
	nl,
	write('Your turn. Enter space # to mark, followed by a period: '),
	read(S),
	S >= 1, % We don't want the player trying to play a non-existant space!
	S =< 9, % This is why using numbers for spaces is so convenient...
	empty(S),
	assert(x(S)). % Dynamic binding!

% Computer's turn. Plays the best move (according to the given algorithm).
compturn :- fullboard. % Can't do anything if the board is full!
% Fortunately, the player will never run into this problem due to going first.
compturn :-
	writeln('Computer\'s turn...'),
	move(S),
	!, % We only want to make one move per turn!
	assert(o(S)).

start :-
	% Sweet ASCII art! :)
	writeln(' _______________     _________  _____     __________  _____ '),
	writeln('/_  __/  _/ ___/____/_  __/ _ |/ ___/____/_  __/ __ \\/ __(_)'),
	writeln(' / / _/ // /__ /___/ / / / __ / /__ /___/ / / / /_/ / _/_   '),
	writeln('/_/ /___/\\___/      /_/ /_/ |_\\___/      /_/  \\____/___(_)  '),
	writeln('           __   __                     _____      '),
	writeln('          /\\ \\ /\\ \\                   /\\  __`\\    '),
	writeln('          \\ `\\`\\/\'/\'      __  __      \\ \\ \\/\\ \\   '),
	writeln('           `\\/ > <       /\\ \\/\\ \\      \\ \\ \\ \\ \\  '),
	writeln('              \\/\'/\\`\\    \\ \\ \\_/ |__    \\ \\ \\_\\ \\ '),
	writeln('              /\\_\\\\ \\_\\   \\ \\___//\\_\\    \\ \\_____\\'),
	writeln('              \\/_/ \\/_/    \\/__/ \\/_/     \\/_____/'),
				% Dealing with escape characters is a pain. :(
	writeln('The board layout is as follows:'),
	writeln(' _____'),
	writeln('|1|2|3|'),
	writeln('|4|5|6|'),
	writeln('|7|8|9|'),
	writeln(' ‾‾‾‾‾'),
	writeln('Player is X...  Who will prevail?').
	% It can't hurt to repeat the instructions again.

% Informs the interpreter that the definition of the predicates may change
% during execution. (Thanks, SWI-Prolog Library!)
:- dynamic x/1.
:- dynamic o/1.

% Clears a marked space.
clearspace :-
	x(S),
	retract(x(S)),
	fail. % Needed so ALL marked spaces are cleared!
clearspace :-
	o(S),
	retract(o(S)),
	fail. % Ditto. Because of repeat used in initboard.

% Initializes the board by clearing all marked spaces.
initboard :-
	repeat,
	\+ clearspace.

% Controls the flow of play.
play :-
	repeat,
	playerturn,
	compturn,
	printboard, % Can't print in-between turns, lest repeat acts weird. :(
	gameover. % Repeats until the game is over.

% START THE GAME ALREADY!
:-
	start,
	initboard,
	play.
	