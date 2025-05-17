@echo off
rem esto es una prueba
echo tamany
swipl -q -g "tamany([1,2,3], P), write(P), nl." -t halt test.pl
echo permuta
swipl -q -g "bagof([P], permuta([1,0,1], P), P), write(P)." -t halt test.pl