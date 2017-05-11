' no verde w1, w2,w3, 10unidades abaixo e 10unidades para cima
' w4 no prateado 50unidades para cima do branco
setfreq m8
inicio:
readadc10 0,w4
if w4>800 then prateado
if w4<800 then apagado
goto inicio

prateado:
low 5
high 3
low 2
goto inicio

apagado:
low 5
low 3
low 2
goto inicio