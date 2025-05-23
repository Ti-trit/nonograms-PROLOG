
%----------------------- FUNCIONS AUXILIARS -----------------

tamany([], 0).
tamany([_|L], P) :- tamany(L, P1), P is P1+1.

element(0, [X|_], X).
element(P, [_|L], X) :-  P > 0,P1 is P-1, element(P1, L, X).


insereix(E,L,[E|L]).
insereix(E,[X|Y],[X|Z]) :- insereix(E,Y,Z).

% usar disctinc()a
permuta([],[]).
permuta([X|Y],Z) :- permuta(Y,L), insereix(X,L,Z).

genArr(0, []).
genArr(P, [[]|L]) :- P > 0, P1 is P-1, genArr(P1, L).

afegir([],L,L).
afegir([X|L1],L2,[X|L3]):-afegir(L1,L2,L3).

repeticions(_, [], 0).
repeticions(X, [Z|Y], C):-
    Z is X,
    repeticions(X, Y, C1),
    C is C1+1.
repeticions(X, [Z|Y], C):-
    Z \= X,
    repeticions(X, Y, C).
%crea una llista de 'Tamany' i la inicialitza a 'Valor'
genera_array(0, _,[]).
genera_array(Tamany,Valor, [Valor|L]):- Tamany > 0, Tamany1 is Tamany-1, genera_array(Tamany1, Valor, L).

%Suma tots els elements d'una llista
suma_list([], 0).
suma_list([X|Resta], Suma):- suma_list(Resta, Suma1), Suma is Suma1+X.

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


%----------------------- TRANSPOSTA -----------------

%% transposta(Matriu, Transposada)
transposta([], []).
transposta([[]|_], []).
transposta(Matrix, [Row|Rows]) :-
    transposar_fila(Matrix, Row, RestMatrix),
    transposta(RestMatrix, Rows).

%% transposar_fila(Matrix, Column, RestMatrix)
transposar_fila([], [], []).
transposar_fila([[Elem|RestRow]|Rows], [Elem|Elems], [RestRow|RestRows]) :-
    transposar_fila(Rows, Elems, RestRows).


nonograma([], [], []).
%Comprovar solució
nonograma(PistesFila, PistesColumna, Caselles) :- nonvar(Caselles),nonograma_intern(PistesFila, Caselles),transposta(Caselles, TC), nonograma_intern(PistesColumna, TC).


%generar solució
nonograma(Pistes_fila,Pistes_columna, Caselles) :-
    var(Caselles),
   % length(Pistes_fila, NumFilas),
        length(Pistes_columna, NumColumnas),
    soluciona_nonograma_aux(Pistes_fila, NumColumnas, [], Caselles),
    transposta(Caselles, TC),
    nonograma_intern(Pistes_columna, TC).

   
soluciona_nonograma_aux([], _, Acc, Acc).
soluciona_nonograma_aux([Pista|RestaPistes], N, Acc, Caselles) :-
    genera_fila(Pista, N, Fila),
    append(Acc, [Fila], Acc_actual),
    soluciona_nonograma_aux(RestaPistes, N, Acc_actual, Caselles).

nonograma_intern([], []).
nonograma_intern([P |Pistes], [Fila|Caselles]) :- comprobarFila(P, Fila), nonograma_intern(Pistes, Caselles).


%---------------------GENERAR SOLUCIO------------------------------------
%generaFila([], N, Fila):
%case base: cap pista --> tot 0
genera_fila([], N, Fila):- genera_array(N, 0, Fila).
genera_fila(Pistes_fila, N, Fila):- Pistes_fila \=[],
    								suma_list(Pistes_fila, Sum),
    								length(Pistes_fila, Length), 
    								Min_cells is Sum+Length-1, 
    								Buits_extra is N-Min_cells,
    								Buits_extra >=0,
    								combinacio_espais(N, Buits_extra,Espais),
            						generar_seq_min(Pistes_fila, MinSeq),
    								juntar_fila_espais(Espais,MinSeq, Fila),
    								comprobarFila(Pistes_fila, Fila).

generar_seq_min([], []).
generar_seq_min([P1|Pistes], Fila):- Pistes\=[], genera_array(P1, 1, Arr), afegir(Arr, [0], Fila1), generar_seq_min(Pistes,Fila2), afegir(Fila1, Fila2, Fila). 
generar_seq_min([P1], Fila):- genera_array(P1, 1, Fila).



%Cae base: llistes buides
juntar_fila_espais([], [], []).
% si l'element actual d'espais no és un espacil, consumem un element de MinSeq
juntar_fila_espais([1|Espais], [X|MinSeq], [X|Fila]) :-
    juntar_fila_espais(Espais, MinSeq, Fila).

% si no hi ha cap element de la seqüència mínima, fiquem espais
juntar_fila_espais([0|Espais], [], [0|Fila]) :-
    juntar_fila_espais(Espais, [], Fila).

% si s'ha de posar un espai, l'element actual de Minseq no ha de ser 0, per evitar duplicats
juntar_fila_espais([0|Espais], [X|MinSeq], [0|Fila]) :-
    X =\= 0,
    juntar_fila_espais(Espais, [X|MinSeq], Fila).



combinacio_espais(N, K, Seq) :-
    length(Seq, N),
    generar_seq_binaria(Seq, K).

generar_seq_binaria([], 0).
generar_seq_binaria([1|T], K) :-
    generar_seq_binaria(T, K).
generar_seq_binaria([0|T], K) :-
    K > 0,
    K1 is K - 1,
    generar_seq_binaria(T, K1).



