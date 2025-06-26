tamany([], 0).
tamany([_|L], P) :- tamany(L, P1), P is P1+1.

insereix(E,L,[E|L]).
insereix(E,[X|Y],[X|Z]) :- insereix(E,Y,Z).

permuta([],[]).
permuta([X|Y],Z) :- permuta(Y,L), insereix(X,L,Z).

