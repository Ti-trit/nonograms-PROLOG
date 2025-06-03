%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>HEADER>>>>>>>>>>>>>>>>>>>>>>>>>
% Autors: Daniel García Vázquez, Khaoula Ikkene.
% Data de començament: 20 Maig, 2025
% Dara d'entrega : 03 Juny, 2025
% Assignatura: 21721 - Llenguatges de Programació. 
% Grup: PF1-13
% Professors: Antoni Oliver Tomàs, Francesc Xavier Gayà Morey
% Convocatòria Ordinària
%Extres implementades:
%       - Resolució de nonograms no quadrats
%       - Resolució de nonograms de mida grossa
%       - Genereció de nonograms 
%       - S'ha afegit la part del frontend del joc utilitzant PHP i HTML,
%           encarregant-se de la representació visual del joc
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%----------------------- FUNCIONS AUXILIARS -----------------

%-----------------'afegir'---------------------------------------------------------------
% Descripció: Concatena dues llistes.
%             Retorna una nova llista que conté tots els elements
%             de la primera llista seguits dels de la segona.
%
% Arguments:
%   - L1: Primera llista (pot estar buida).
%   - L2: Segona llista.
%   - R: Resultat de concatenar L1 i L2.
%
% Cas base: concatenar una llista buida amb L2 dóna com a resultat L2.
% Cas recursiu: afegeix el cap de la primera llista al resultat i continua amb la cua.
%----------------------------------------------------------------------------------------
afegir([],L,L).
afegir([X|L1],L2,[X|L3]):-afegir(L1,L2,L3).

%-----------------'repeticions'----------------------------------------------------------
% Descripció: Calcula el nombre de vegades que ha aparegut el símbol X
%             a una llista i el retorna
%             
%
% Arguments:
%   - X: Símbol pel qual s'han de calcular les seves repeticions
%   - [Z|Y]: la llista per calcular el nombre de repeticions del símbol
%   - C: nombre de repeticions de X en L
%
% Cas base: La llista és buida, doncs el nombre de repeticions és zero.
% Cas recursiu: Si l'element actual és igual al símbol, s'incrementa el comptador
%               i continua la recerca en la resta de la llista
%               En cas contrari, només avança la recerca en la resta de la llista 
%----------------------------------------------------------------------------------------
repeticions(_, [], 0).
repeticions(X, [Z|Y], C):-
    Z is X, !,
    repeticions(X, Y, C1),
    C is C1+1.
repeticions(X, [Z|Y], C):-
    Z \= X,
    repeticions(X, Y, C).

%-----------------'repeticions'----------------------------------------------------------
% Descripció: crea una llista de mida igual a 'Tamany' i la inicialitza a 'Valor'
%             Retorna la llista creada i inicialitzada.
%             
% Arguments:
%   - Tamany: mida de la llista
%   - Valor: valor amb el qual inicialitzarem la llista 
%   - L: la llista creada
%
% Cas base: El tamany és zero, es retorna una llista buida.
% Cas recursiu: Mentre que el tamany sigui major que zero, 
%               afegeix un element de 'Valor' a la llista i va derecrementant
%               la mida de la llista
%----------------------------------------------------------------------------------------

genera_array(0, _,[]).
genera_array(Tamany,Valor, [Valor|L]):- Tamany > 0, !, Tamany1 is Tamany-1, genera_array(Tamany1, Valor, L).

%-----------------'suma_list'------------------------------------------------------------
% Descripció: Calcula la suma dels elements d'una llista, i el retorna.
%             
% Arguments:
%   - [X|Resta]: llista 
%   - Suma: Suma a retornar
%
% Cas base: La llista és buida, la suma dels seus elements és zero.
% Cas recursiu: Mentre hi hagi elements a la llista, es va sumant el seu valor a Suma
%               
%----------------------------------------------------------------------------------------
suma_list([], 0).
suma_list([X|Resta], Suma):- suma_list(Resta, Suma1), Suma is Suma1+X.

%-----------------'comprobarFila'--------------------------------------------------------
% Descripció:
%   Comprova si una fila d'un nonograma compleix amb les pistes donades.
%   Cada número en la llista de pistes representa una seqüència de caselles
%    consecutives plenes (1s), separades per almenys una casella buida (0).
%   
%
% Arguments:
%   - [Pista|NextPista]: llista de pistes que indica la longitud
%                        de grups consecutius de caselles plenes a la fila.
%   - Fila: la fila a comprovar, representada com una llista de 0s i 1s.
%
% Cas base: Si la llista de pistes és buida, la fila ha de contenir només 0s.
% Cas recursiu: Per cada pista [X], es cerca que hi hagi un bloc de X elements consecutius a 1 
%               (saltant primer els 0s inicials), es comprova que és correcte,
%               i es continua amb la resta de la fila i les següents pistes.
%----------------------------------------------------------------------------------------
comprobarFila([], Fila):- repeticions(1, Fila, C), C is 0.
comprobarFila([Pista|NextPista], Fila):-
    comprobarFila_Base(Pista, Fila, Resta),
    comprobarFila(NextPista, Resta).

%-----------------'comprobarFila_Base'---------------------------------------------------
% Descripció:
%   Donada una pista, X, i la fila en qüestió, comprova que hi hagi una seqüència
%   de X uns consecutius i amb al menys un espai després. Es té en compte que
%   la seqüència pot estar al final de la llista.
%
% Arguments:
%   - X: nombre de 1s consecutius
%   - Fila: la fila a comprovar
%
% Cas base: Si la pista és buida, es comprova que la fila només tengui valors de 0s
% Cas recursiu: Es salten els primers zeros, i s'extreu la seqüència de mida X de 1s consecutius.
%               Després es comprova que aquesta seqüència la seguix un espai en blanc (0),
%               o que estigui ja al final de la fila.
%----------------------------------------------------------------------------------------
comprobarFila_Base([], Fila, Resta):- salta_zeros(Fila, F1),
    agafarXConsecutius(0, F1, Resta),
    verificarResta(Resta).

comprobarFila_Base(X, Fila, Resta) :-
    salta_zeros(Fila, F1),
    agafarXConsecutius(X, F1, Resta),
    verificarResta(Resta).

%-----------------'salta_zeros'----------------------------------------------------------
% Descripció:
%   Donada una fila d'un nonograma, es salten els zeros a l'inici de la fila.
%   Retorna la subseqüència de fila que comença amb 1.
%
% Arguments:
%   - Fila: fila d'un nonograma
%   - R: la subllista de Fila que no té zeros al començament
%
% Cas base: Si la fila és buida, es retorna una llisa buida.
% Cas recursiu: Mentre que no s'ha trobat encara un 1, es segueix el processament dels elements de fila.
%               En trobar un 1, es retorna la subllista en processament.
%----------------------------------------------------------------------------------------
salta_zeros([], []).
salta_zeros([0|T], R) :- salta_zeros(T, R).
salta_zeros([1|T], [1|T]).

%-----------------'agafarXConsecutius'---------------------------------------------------
% Descripció:
%   Agafa una seqüència consecutiva de N elements amb valor 1 des del començament 
%   de la llista donada (Fila). Retorna la resta de la llista un cop extrets aquests N elements.
%
% Arguments:
%   - N: nombre d'elements consecutius amb valor 1 que cal consumir
%   - Fila: llista d’entrada 
%   - R: la part restant de la llista després d’haver consumit els N uns consecutius.
%
% Cas base:
%   - Si N = 0 i la fila és buida, es retorna una lista buida
%   - Si N = 0 i la fila comença amb zero, es retorna tal qual.
%
% Cas recursiu:
%   - Si el primer element de la fila és un 1 i encara queden N > 0 a consumir,
%     es decreix N i es continua amb la cua de la llista.
%----------------------------------------------------------------------------------------
agafarXConsecutius(0, [], []).
agafarXConsecutius(0, [0|T], [0|T]).
agafarXConsecutius(N, [1|T], R) :-
    N > 0, !,
    N1 is N - 1,
    agafarXConsecutius(N1, T, R).

%-----------------'verificarResta'-----------------------------------
% Descripció:
%   Verficia que la llista estigui buida o que començi amb zero
%
% Arguments:
%   - llista: llista a comprovar
%
%-------------------------------------------------------------------
verificarResta([]).
verificarResta([0|_]).



%-----------------'transposta'-------------------------------------
% Descripció:
%  Calcula la transposta d'una matriu
%
% Arguments:
%   - Matriu: la matriu NxM a transposar
%   - Transposta: la matriu MxN transposta de Matriu
%
% Cas base:
%   - Si Matriu = Transposta = []
%
% Cas recursiu:
%   1. Genera la transposta de una columna de la matriu original
%   2. Opera recursivament amb la resta de columnes
%------------------------------------------------------------------
transposta([], []).
transposta([[]|_], []).
transposta(Matrix, [Row|Rows]) :-
    transposar_fila(Matrix, Row, RestMatrix),
    transposta(RestMatrix, Rows).

%-----------------'transposar_fila'------------------------------------------------------
% Descripció:
%   Agafa un element i el restant d'una fila del conjunt de files, després agafa l'element i
%   l'inserta a la fila transposada, finalment guarda el restant de les files apart i fa recursió a la següent
%
% Arguments:
%   - Matriu: la matriu NxM a transposar una columna
%   - Elems: la nova fila de la matriu transposada
%   - RestRows: la resta de columnes de la matriu original
%
% Cas base:
%   - Si Matriu = Elems = RestRows = []
%
% exemple:
%    Matrix,   Elems,   RestRows
%    [a, b, c]  ?           ?     
%    [c, d, e]  ?           ?
%    Matrix,   Elems,   RestRows
%       []       [a]      [b, c]     
%    [c, d, e]              ?
%    Matrix,   Elems,   RestRows
%      []        [a, c]   [b, c]     
%      []                 [d, e]
%----------------------------------------------------------------------------------------
transposar_fila([], [], []).
transposar_fila([[Elem|RestRow]|Rows], [Elem|Elems], [RestRow|RestRows]) :-
    transposar_fila(Rows, Elems, RestRows).

%-----------------'nonograma'------------------------------------------------------------
% Descripció:
%   Comprova o soluciona un nonograma segons l’estat de la variable Caselles.
%   Si Caselles ja està instanciada, es comprova que compleixi les pistes de 
%   files i columnes. Si Caselles és variable, es genera una solució que s’ajusti
%   a les pistes indicades.
%
% Arguments:
%   - PistesFila: llista de llistes amb les llistes de files
%   - PistesColumna: llista de llistes amb les pistes de columnes
%   - Caselles: matriu (llista de llistes de 0s i 1s) que representa un nonograma.
%
% Cas base:
%   - nonograma([], [], []): no hi ha ni pistes ni caselles.
%
% Cas 1 (comprovar solució):
%   - Si Caselles està instanciada (nonvar(Caselles)), es comprova cada fila amb
%     nonograma_intern i després es calcula la transposta de Caselles per comprovar
%     les pistes de columna.
%
% Cas 2 (generar solució):
%   - Si Caselles és variable (var(Caselles)), es construeix cada fila a partir de
%     les pistes de fila cridant soluciona_nonograma_aux. Un cop generades totes
%     les files, s’obté la matriu de caselles i es comproven les pistes de columna
%     sobre la matriu transposada.
%----------------------------------------------------------------------------------------
nonograma([], [], []).
%Comprovar solució
nonograma(PistesFila, PistesColumna, Caselles) :- nonvar(Caselles),!, nonograma_intern(PistesFila, Caselles),transposta(Caselles, TC), nonograma_intern(PistesColumna, TC).


%generar solució
nonograma(Pistes_fila,Pistes_columna, Caselles) :-
    var(Caselles), !, 
   % length(Pistes_fila, NumFilas),
        length(Pistes_columna, NumColumnas),
    soluciona_nonograma_aux(Pistes_fila, NumColumnas, [], Caselles),
    transposta(Caselles, TC),
    nonograma_intern(Pistes_columna, TC).


%-----------------'soluciona_nonograma_aux'----------------------------------------------
% Descripció:
%   Construeix recursivament la matriu de caselles a partir de les pistes de fila.
%   Cada fila es genera amb genera_fila, assegurant que s’ajusti a la pista corresponent.
%
% Arguments:
%   - [Pista|RestaPistes]: llista de pistes de fila 
%   - N: nombre de columnes (longitud de cada fila).
%   - Acc: acumulador amb les files ja generades.
%   - Caselles: resultat final; matriu completa un cop processades totes les pistes.
%
% Cas base:
%   - Si no queden pistes de fila per processar (PistesF = []), llavors Acc ja conté
%     totes les files i es retorna com a Caselles.
%
% Cas recursiu:
%   1. Pren la primera pista de fila (Pista) i genera una fila de longitud N que
%      s’ajusti a Pista cridant genera_fila.
%   2. Afegeix la fila generada a l’acumulador (Acc) amb append.
%   3. Crida recursivament amb la resta de pistes de fila i l’acumulador actualitzat.
%----------------------------------------------------------------------------------------
soluciona_nonograma_aux([], _, Acc, Acc).
soluciona_nonograma_aux([Pista|RestaPistes], N, Acc, Caselles) :-
    genera_fila(Pista, N, Fila),
    append(Acc, [Fila], Acc_actual),
    soluciona_nonograma_aux(RestaPistes, N, Acc_actual, Caselles).

%-----------------'nonograma_intern'-----------------------------------------------------
% Descripció:
%   Comprova que cada fila (o columna) d’una matriu s’ajusti a la seva llista de pistes.

%
% Arguments:
%   - [P |Pistes]: llista de llistes de pistes
%   - [Fila|Caselles]: el nonograma a comprovar
%
% Cas base:
%   - Si no queden elements per verificar (ambdues llistes buides), retorna true.
%
% Cas recursiu:
%   1. Pren la primera pista (P) i la primera fila/columna binària (Fila).
%   2. Comprova que Fila s’ajusti a P mitjançant comprobarFila
%   3. Continua amb la resta de pistes i files recursivament.
%----------------------------------------------------------------------------------------
nonograma_intern([], []).
nonograma_intern([P |Pistes], [Fila|Caselles]) :- comprobarFila(P, Fila), nonograma_intern(Pistes, Caselles).



%-----------------'genera_fila'----------------------------------------------------------
% Descripció:
%   Genera una fila vàlida d’un nonograma, donades les pistes 
%   de fila i la mida total de la fila (N).
%
% Arguments:
%   - Pistes_fila: llista de nombres que representen la longitud de grups consecutius
%                  de caselles plenes (1s).
%   - N: longitud total de la fila 
%   - Fila: la fila generada
%
% Cas base:
%   - Si no hi ha cap pista, la fila generada és tota de zeros.
%
% Cas general:
%   1. Es calcula el nombre mínim de caselles necessàries per complir les pistes:
%      la suma de les pistes més els espais mínims entre blocs (Length - 1).
%   2. Es calcula quants buits extra hi ha (caselles de més que es poden repartir).
%   3. Es genera una distribució aleatòria d'aquests buits.
%   4. Es genera la seqüència mínima de blocs (amb 1s i buits mínims).
%   5. Es junten els espais addicionals amb la seqüència mínima per formar la fila completa.
%   6. Es comprova que la fila final compleix realment les pistes.
%----------------------------------------------------------------------------------------
genera_fila([], N, Fila):- genera_array(N, 0, Fila).
genera_fila(Pistes_fila, N, Fila):- Pistes_fila \=[],
    								suma_list(Pistes_fila, Sum),
    								length(Pistes_fila, Length), 
    								Min_cells is Sum+Length-1, 
    								Buits_extra is N-Min_cells,
    								Buits_extra >=0, !,
    								genera_seq_aleatoria(N, Buits_extra,Espais),
            						generar_seq_min(Pistes_fila, MinSeq),
    								juntar_fila_espais(Espais,MinSeq, Fila),
    								comprobarFila(Pistes_fila, Fila).

%-----------------'generar_seq_min'------------------------------------------------------
% Descripció:
%   Genera la seqüència mínima d’una fila a partir d’una llista de pistes.
%  Una seqüència mínimia té només els espais necessaris per separar les 
%  seqüencies de 1s.
%
% Arguments:
%   - [P1|Pistes]: llista de pistes
%   - Fila: la llista resultant amb la seqüència mínima corresponent als blocs.
%
% Cas base:
%   - Si no hi ha cap pista, la seqüència mínima és una llista buida.
%   - Si la llista té només una pista, es genera una seqüència de 1, sense cap espai, i es retorna
%
% Cas recursiu:
%   - Si hi ha més d’una pista, es genera un bloc de P1 elements amb 1s, se li afegeix un 0
%     com a separador, i es continua recursivament amb la resta de pistes.
%----------------------------------------------------------------------------------------
generar_seq_min([], []).
generar_seq_min([P1], Fila):- genera_array(P1, 1, Fila).
generar_seq_min([P1|Pistes], Fila):- Pistes\=[], !, genera_array(P1, 1, Arr), afegir(Arr, [0], Fila1), generar_seq_min(Pistes,Fila2), afegir(Fila1, Fila2, Fila). 


%-----------------'juntar_fila_espais'---------------------------------------------------
% Descripció:
%   Combina una seqüència mínima `MinSeq` amb una llista d'espais `Espais`
%   per generar una fila. Els espais addicionals  es distribueixen entre
%   els blocs de la seqüència mínima segons la seva posició.
%
% Arguments:
%   - Espais: llista de 0s i 1s que indica on s'han d'afegir espais extra (0) o 
%             elements de la seqüència mínima (1).
%   - MinSeq: seqüència mínima de la fila
%   - Fila: resultat final de la combinació
%
% Cas base:
%   - Quan ambdues llistes estan buides, es retorna una llista buida.
%
% Casos recursius:
%   1. Si l'element actual d'`Espais` és 1 → es consumeix un element de `MinSeq` i es col·loca a la `Fila`.
%   2. Si `MinSeq` està buida però queda un 0 a `Espais` → es posa un 0 a la `Fila` (espai addicional).
%   3. Si l'element actual d'`Espais` és 0 i `MinSeq` no està buida:
%        - Només s'insereix un espai (0) si el següent valor de `MinSeq` no és ja un 0,
%          per evitar espais duplicats entre blocs.
%----------------------------------------------------------------------------------------
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


%-----------------'genera_seq_aleatoria'----------------------------------
% Descripció:
%   Genera una seqüència binària de longitud N amb exactament K zeros.
%
% Arguments:
%   - N: longitud total de la seqüència 
%   - K: nombre de zeros en la seqüència
%   - Seq: la seqüència binària generada, amb K zeros i N-K uns
%-------------------------------------------------------------------------

genera_seq_aleatoria(N, K, Seq) :-
    length(Seq, N),
    generar_seq_binaria_k_zeros(Seq, K).

%-----------------'generar_seq_binaria_k_zeros'------------------------------------------
% Descripció:
%   Instancia una llista de longitud fixa prèviament amb exactament K ceros 
%   i la resta d’elements com un 1. 
%
% Arguments:
%   - Seq: la llista binària resultant (ja amb longitud N si s’ha cridat des
%          de genera_seq_aleatoria/3). Els elements es poden instanciar com
%          0 o 1 segons la recursió.
%   - K: nombre de zeros que s’han de col·locar dins de Seq.
%
% Cas base:
%   - Si Seq = [] i K = 0: no queden posicions i s’han col·locat tots els zeros.
%
% Casos recursius:
%   1. Si el cap de Seq s’instancia a 1: no es veu afectat el comptador de zeros;
%      crida recursiva amb la cua i el mateix K.
%   2. Si el cap de Seq pot ser 0 i K > 0: decrementar K (un zero assignat) i
%      continuar amb la cua i K1 is K-1.
%----------------------------------------------------------------------------------------
generar_seq_binaria_k_zeros([], 0).
generar_seq_binaria_k_zeros([1|T], K) :-
    generar_seq_binaria_k_zeros(T, K).
generar_seq_binaria_k_zeros([0|T], K) :-
    K > 0, !,
    K1 is K - 1,
    generar_seq_binaria_k_zeros(T, K1).


%-----------------'genera_nonograma'-----------------------------------------------------
% Descripció:
%   Generar un nonograma donades les dimensions de fila i columna.
%   Primer genera caselles aleatoris de 0s i 1s
%   Crea les llistes de pistes de C usant les caselles generadaes
%   Transposa Caselles i genera les pistes de fila
%   Retorna les pistes de files, les de columns i les caselles generades
%
% Arguments:
%   - Num_Cols: longitud de columnes
%   - Num_Files: longitud de files
%   - C: pistes de columnes
%   - F : pistes de files
%   - Caselles: les caselles del nonograma
%
% Cas base:
%   -Si el nonograma és de 0 files i 0 columnes, la resta d'arguments són llistes buides.
%   -En cas contrari, es segueix el plantejament descrit a la descripció del predicat
%
%----------------------------------------------------------------------------------------
genera_nonograma(0, 0, [], [], []).
genera_nonograma(Num_Cols, Num_Files, C, F, Caselles):- genera_caselles(Num_Files,Num_Cols, Caselles), 
    genera_Pistes(Num_Files, Caselles, C),
    transposta(Caselles, Transpota_Caselles), 
    genera_Pistes(Num_Cols, Transpota_Caselles, F).

%-----------------'genera_caselles'------------------------------------------------------
% Descripció:
%   Genera una llista de llistes de 0 i 1 de forma aleatoria
%
% Arguments:
%   - Num_Cols: longitud de columnes
%   - Num_Files: longitud de files
%   - C: pistes de columnes
%   - [Fila|Resta] : el nongrama generat
%
% Cas base:
%   -Si el nonograma és de 0 files la llista de caselles és buida.
%   -En cas contrari,per cada fila es genera una seqüència binaria aleatòria, i 
%    es crida al mateix metòde per generar la resta de files
%
%----------------------------------------------------------------------------------------
genera_caselles(0, _, []). 
genera_caselles(Num_Files, Num_Cols, [Fila|Resta]):- Num_Files > 0,
    genera_binari(Num_Cols, Fila),
    Num_Files1 is Num_Files -1, 
    genera_caselles(Num_Files1, Num_Cols, Resta).

%-----------------'genera_Pistes'--------------------------------------------------------
% Descripció:
%   Genera una llista de pistes per un nonograma donat.
%
% Arguments:
%   - Num_Files: longitud de files
%   - [Fila_Actual|Caselles] : el nongrama pel qual es generen les pistes
%   - [Pistes_Fila_Actual|Resta] : llista de pistes que es genera

% Cas base:
%   -Si la longitud de files és zero, no es generen cap pistes.
%
% Cas recursiu:   
%   Per cada fila del nonograma crida al metòde 'genera_pistes_fila' per obtenir la llista de pistes
%   per aquella fila. Concatena aquestes pistes a la llista de pistes, i segueix processant la resta
%   de files del nonograma.
%
%----------------------------------------------------------------------------------------
genera_Pistes(0, [], []).
genera_Pistes(Num_Files, [Fila_Actual|Caselles], [Pistes_Fila_Actual|Resta]):- 
    Num_Files > 0, !, 
    genera_pistes_fila(Fila_Actual, Pistes_Fila_Actual), 
    Num_Files1 is Num_Files -1, 
    genera_Pistes(Num_Files1, Caselles, Resta).


%-----------------'genera_pistes_fila'---------------------------------------------------
% Descripció:
%   Genera una llista de pistes per una fila d'un nonograma
%
% Arguments:
%   - Fila_Actual: fila pel qual es generen les pistes
%   - Pistes_Fila_Actual : llista de pistes 

% Cas base:
%   -Si la fila és buida, la llista de pistes també ho serà.
%   - En cas contrari, es crida al metòde genera_pistes_fila_auxiliar

%----------------------------------------------------------------------------------------
genera_pistes_fila([], []).
genera_pistes_fila(Fila_Actual, Pistes_Fila_Actual):- genera_pistes_fila_auxiliar(Fila_Actual, 0, Pistes_Fila_Actual).

%-----------------'genera_pistes_fila_auxiliar'------------------------------------------
% Descripció:
%   Genera les pistes d'una fila concreta del nonograma a partir d'una llista 
%   binària (0s i 1s), comptant la longitud dels blocs consecutius de 1s.
%   Les pistes resultants són una llista de nombres enters que indiquen la 
%   mida de cada bloc de caselles plenes (1s).
%
% Arguments:
%   - Fila:  fila del nonograma.
%   - Contador:  compta els 1s consecutius
%   - Pistes: llista de pistes construïda
% Casos base:
%   -  Si la fila és buida i el contador és 0, es retorna una llista buida.
%   -  Si la fila és buida però el contador > 0, significa que ha acabat un bloc
%                 i s'ha d'afegir aquest valor a la llista de pistes.
%
% Casos recursius:
%   - Si hi ha un 1 s'incrementa el contador i continua cercant en la resta de fila.
%   - Si hi ha un 0 i contador > 0 : acaba un bloc → s’afegeix el contador 
%                 a la llista de pistes i es reinicia el contador.
%   - Si hi ha un 0 i contador = 0: continua amb el comptador a 0
%----------------------------------------------------------------------------------------
genera_pistes_fila_auxiliar([], 0, []).
genera_pistes_fila_auxiliar([], Contador, [Contador]) :-
    Contador > 0. 
genera_pistes_fila_auxiliar([1|Y], Contador, Pistes):-  Contador1 is Contador +1,
    genera_pistes_fila_auxiliar(Y, Contador1, Pistes).


genera_pistes_fila_auxiliar([0|Y], Contador, [Contador|Pistes]):- Contador>0,
    genera_pistes_fila_auxiliar(Y, 0, Pistes).


genera_pistes_fila_auxiliar([0|Y], 0, Pistes):-
    genera_pistes_fila_auxiliar(Y, 0, Pistes).

%-----------------'genera_binari'--------------------------------------------------------
% Descripció:
%   Genera una llista de longitud N amb valors binaris (0 o 1) generats aleatòriament.
%
% Arguments:
%   - N: longitud de la llista a generar.
%   - Llista: llista resultant amb una seqüència binària aleatoria.
%
% Cas base:
%   - Si N és 0, la llista generada és buida.
%
% Cas recursiu:
%   - Es genera un valor aleatori entre 0 i 1 per al primer element, es decrementa N i es repeteix
%       el mateix procés fins que N sigui 0
%----------------------------------------------------------------------------------------
genera_binari(0, []).

genera_binari(N, [Bit|Resta]) :-
    N > 0, !,
    random_between(0, 1, Bit),
    N1 is N - 1,
    genera_binari(N1, Resta).











