tamany([], 0).
tamany([_|L], P) :- tamany(L, P1), P is P1+1.

element(0, [X|_], X).
element(P, [_|L], X) :-  P > 0,P1 is P-1, element(P1, L, X).


insereix(E,L,[E|L]).
insereix(E,[X|Y],[X|Z]) :- insereix(E,Y,Z).

permuta([],[]).
permuta([X|Y],Z) :- permuta(Y,L), insereix(X,L,Z).

genArr(0, []).
genArr(P, [[]|L]) :- P > 0, P1 is P-1, genArr(P1, L).

afegir([],L,L).
afegir([X|L1],L2,[X|L3]):-afegir(L1,L2,L3).

%% transposta(Matriu, Transposada)
transposta([], []).
transposta([[]|_], []).
transposta(Matrix, [Row|Rows]) :-
    transposar_fila(Matrix, Row, RestMatrix),
    transposta(RestMatrix, Rows).

%% transpose_column(Matrix, Column, RestMatrix)
transposar_fila([], [], []).
transposar_fila([[Elem|RestRow]|Rows], [Elem|Elems], [RestRow|RestRows]) :-
    transposar_fila(Rows, Elems, RestRows).
