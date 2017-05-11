#com 4
setfreq m64

inicio:
low b.1             ' VERDE DIREITA
low b.4
count b.3,50,w1
high b.4
count b.3,50,w2
high 1
count b.3,50,w3


low b.2             ' VERDE ESQUERDA
low b.5            
count b.6,50,w4    
high b.5
count b.6,50,w5
high 2
count b.6,50,w6

readadc10 c.3,w7      '  ######   c.2  esquerda    c.3 - Direita

debug

if w1>10 and w1<25 and w2>15 and w2<28 and w3>20 and w3<30 then verde_dir

if w4>10 and w4<25 and w5>15 and w5<27 and w6>28 and w6<42 then verde_esq

;if w1<500 and w2<500 and w3<500 and w4<500 and w5<500 and w6<500 and w7>500 then prateado

if w1<500 and w2<500 and w3<500 and w4<500 and w5<500 and w6<500 and w7>350 and w7<501 then apagado


goto inicio



verde_dir:
low c.0
high c.1
low c.4
low c.5
goto inicio2


verde_esq:
high c.0
low c.1
low c.4
low c.5
goto inicio3

prateado:
low c.0
low c.1
low c.4
high c.5
goto inicio

apagado:
low c.0
low c.1
low c.4
low c.5
goto inicio

preto:
low c.0
low c.1
high c.4
low c.5
goto inicio


inicio2:
if w7>500 then prateado2
if w7<351 then preto2 
if w7>350 and w7<501 then verde_dir2
goto inicio


prateado2:
low c.0
high c.1
low c.4
high c.5
goto inicio

preto2:
low c.0
high c.1
high c.4
low c.5
goto inicio

verde_dir2:
low c.0
high c.1
low c.4
low c.5
goto inicio


inicio3:
if w7>500 then prateado3
if w7<351 then preto3 
if w7>350 and w7<501 then verde_esq2
goto inicio


prateado3:
high c.0
low c.1
low c.4
high c.5
goto inicio

preto3:
high c.0
low c.1
high c.4
low c.5
goto inicio

verde_esq2:
high c.0
low c.1
low c.4
low c.5
goto inicio