
%----------------------- FUNCIONS AUXILIARS -----------------

tamany([], 0).
tamany([_|L], P) :- tamany(L, P1), P is P1+1.

insereix(E,L,[E|L]).
insereix(E,[X|Y],[X|Z]) :- insereix(E,Y,Z).

permuta([],[]).
permuta([X|Y],Z) :- permuta(Y,L), insereix(X,L,Z).

repeticions(_, [], 0).
repeticions(X, [Z|Y], C):- 
    Z is X, 
    repeticions(X, Y, C1), 
    C is C1+1.
repeticions(X, [Z|Y], C):- 
    Z \= X, 
    repeticions(X, Y, C).

%----------------------- COMRPOBARFILA -----------------
comprobarFila([], Fila):- repeticions(1, Fila, C), C is 0.
comprobarFila([Pista|NextPista], Fila):-
    comprobarFila_Base(Pista, Fila, Resta), 
    comprobarFila(NextPista, Resta).

comprobarFila_Base([], Fila, Resta):- skipZeros(Fila, F1), 
    agafarXConsecutius(0, F1, Resta), 
    verificarResta(Resta).

comprobarFila_Base(X, Fila, Resta) :-
    skipZeros(Fila, F1),
    agafarXConsecutius(X, F1, Resta), 
    verificarResta(Resta).


skipZeros([], []).
skipZeros([0|T], R) :- skipZeros(T, R).
skipZeros([1|T], [1|T]).  

agafarXConsecutius(0, [], []).
agafarXConsecutius(0, [0|T], [0|T]).
agafarXConsecutius(N, [1|T], R) :-
    N > 0,
    N1 is N - 1,
    agafarXConsecutius(N1, T, R).


verificarResta([]).
verificarResta([0|_]).




