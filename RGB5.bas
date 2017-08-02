
#picaxe 20x2
#no_table
#no_data



inicio:
setfreq m64

low b.1             ' VERDE DIREITA
low b.4
count b.3,50,w4
high b.4
count b.3,50,w5
high 1
count b.3,50,w6


low b.2             ' VERDE ESQUERDA
low b.5            
count b.6,50,w1
high b.5
count b.6,50,w2
high 2
count b.6,50,w3

readadc10 c.3,w7      '  ######   c.2  esquerda    c.3 - Direitay7

setfreq m8

;debug
pause 1

if w1>3 and w1<11 and w2>5 and w2<14 and w3>11 and w3<22 and w4>4 and w4<12 and w5>6 and w5<14 and w6>11 and w6<22 then verde_de
if w1>3 and w1<11 and w2>5 and w2<14 and w3>11 and w3<22 then verde_dir
if w4 >4 and w4<12 and w5>6 and w5<14 and w6>11 and w6<22 then verde_esq

if w7>510 then prateado

if w1<500 and w2<500 and w3<500 and w4<500 and w5<500 and w6<500 and w7<500 then apagado
serout c.5,n76800_64,(0,0,0,0)
goto inicio

verde_de:
high c.0
high c.1
low c.4
serout c.5,n76800_64,(0,0,1,0)
goto inicio

verde_dir:
b21=w1
b22=w2
b23=w3
low c.0
low c.4
high c.1
serout c.5,n76800_64,(0,1,0,0)
goto inicio


verde_esq:
b24=w4
b25=w5
b26=w6
high c.0
low c.1
low c.4
serout c.5,n76800_64,(1,0,0,0)
goto inicio

prateado:
low c.0
low c.1
high c.4
serout c.5,n76800_64,(0,0,0,1)
goto inicio

apagado:
low c.0
low c.1
low c.4
serout c.5,n76800_64,(0,0,0,0)
goto inicio