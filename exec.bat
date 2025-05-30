@echo off
rem esto es una prueba
echo tamany
swipl -q -g "tamany([1,2,3], P), write(P), nl." -t halt test.pl
echo permuta
swipl -q -g "bagof([P], permuta([1,0,1], P), P), write(P)." -t halt test.pl
echo %1
swipl -q -g %1 -t halt nonograma.pl
rem nonograma([[]], [[]], [])
rem nonograma([[5], [], [2, 1], [1], [1, 2]],  [[1, 1], [1, 1], [1, 1, 1], [1, 2], [1, 1]], [[1, 1, 1, 1, 1],[0, 0, 0, 0, 0],[0, 1, 1, 0, 1],[0, 0, 0, 1, 0],[1, 0, 1, 1, 0]]).
rem nonograma([[2], [1]], [[2], [1], []], [[1, 1, 0], [1, 0, 0]]).