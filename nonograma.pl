
%----------------------- FUNCIONS AUXILIARS -----------------

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
    								genera_seq_aleatoria(N, Buits_extra,Espais),
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



genera_seq_aleatoria(N, K, Seq) :-
    length(Seq, N),
    generar_seq_binaria(Seq, K).

generar_seq_binaria([], 0).
generar_seq_binaria([1|T], K) :-
    generar_seq_binaria(T, K).
generar_seq_binaria([0|T], K) :-
    K > 0,
    K1 is K - 1,
    generar_seq_binaria(T, K1).

%---------------GENERA NONOGRAMA (OPCIONAL)---------------------

genera_nonograma(0, 0, [], [], []).
genera_nonograma(Num_Cols, Num_Files, C, F, Caselles):- genera_caselles(Num_Files,Num_Cols, Caselles), 
    genera_Pistes(Num_Files, Caselles, C),
    transposta(Caselles, Transpota_Caselles), 
    genera_Pistes(Num_Cols, Transpota_Caselles, F).

genera_caselles(0, _, []). 
genera_caselles(Num_Files, Num_Cols, [Fila|Resta]):- Num_Files > 0,
    %valor random de 0
    Limit_Superior is Num_Cols +1, 
    Num_zeros is random(Limit_Superior),
    genera_seq_aleatoria(Num_Cols, Num_zeros, Fila), 
    Num_Files1 is Num_Files -1, 
    genera_caselles(Num_Files1, Num_Cols, Resta).

genera_Pistes(0, [], []).
genera_Pistes(Num_Files, [Fila_Actual|Caselles], [Pistes_Fila_Actual|Resta]):- 
    Num_Files > 0, 
    genera_pistes_fila(Fila_Actual, Pistes_Fila_Actual), 
    Num_Files1 is Num_Files -1, 
    genera_Pistes(Num_Files1, Caselles, Resta).

%llista buida--> cap pista
genera_pistes_fila([], []).
genera_pistes_fila(Fila_Actual, Pistes_Fila_Actual):- genera_pistes_fila_auxiliar(Fila_Actual, 0, Pistes_Fila_Actual).

genera_pistes_fila_auxiliar([], 0, []).
genera_pistes_fila_auxiliar([], Contador, [Contador]) :-
    Contador > 0. 
genera_pistes_fila_auxiliar([1|Y], Contador, Pistes):-  Contador1 is Contador +1,
    genera_pistes_fila_auxiliar(Y, Contador1, Pistes).


genera_pistes_fila_auxiliar([0|Y], Contador, [Contador|Pistes]):- Contador>0,
    genera_pistes_fila_auxiliar(Y, 0, Pistes).


genera_pistes_fila_auxiliar([0|Y], 0, Pistes):-
    genera_pistes_fila_auxiliar(Y, 0, Pistes).







