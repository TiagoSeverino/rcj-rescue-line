symbol agarrou=b3
;Abre Pinça E Depois Fecha Para Não Ficar PResa
servo 0, 250' pinça lado esquerdo aberta
pause 5
servo 2,65' pinça lado direito aberta
pause 300
servo 0, 165' pinça lado esquerdo fechada
pause 300
servo 2,135' pinça lado direito fechada
pause 300

inicio:
if pin4=0 and pin3=1 then pinca_agarra

agarrou=0
if pin4=0 and pin3=0 then pinca_fecha_cima
if pin4=1 and pin3=0 then pinca_aberta_baixo
if pin4=1 and pin3=1 then pinca_larga
goto inicio


pinca_agarra:
if agarrou=0 then
	gosub elev_baixo
	gosub levanta_laterais1
	pause 600	
else
	gosub pinca_fechada_agarra
	pause 500
endif
gosub elev_cima2
pause 100
gosub pinca_fechada
pause 100
goto inicio


elev_baixo:
servo 1,117 'elevador baixo
pause 10
return

levanta_laterais1:
agarrou=1
b0=250

for b1=60 to 120
if b0>=170 then
dec b0
servo 0,b0 'lado esquerdo
pause 8
servo 2,b1 'lado direito
pause 8
endif
next b1
;pause 10
return

subir_meio:
servo 1,60
pause 10
return

pinca_fecha_cima:
gosub pinca_fechada
pause 100
gosub elev_cima
pause 100
goto inicio

pinca_aberta_baixo:
gosub pinca_aberta
pause 100
gosub elev_baixo
pause 100
goto inicio

pinca_larga:
gosub elev_meio
pause 100
gosub pinca_meio
pause 100
goto inicio

pinca_meio:  
servo 0, 235' pinça lado esquerdo aberta
pause 10
servo 2,80' pinça lado direito aberta
pause 10
return

pinca_aberta:  
servo 0, 250' pinça lado esquerdo aberta
pause 70
servo 2,65' pinça lado direito aberta
pause 20
return

pinca_fechada_agarra:
servo 0, 130' pinça lado esquerdo fechada
pause 10
servo 2,170' pinça lado direito fechada
pause 80
return

pinca_fechada:
servo 0, 145' pinça lado esquerdo fechada
pause 10
servo 2,140' pinça lado direito fechada
pause 80
return


elev_cima:
servo 1,55'90  'elevador cima
pause 10
return

elev_cima2:
servo 1,50'90  'elevador cima
pause 10
return

elev_meio:
servo 1,65  'elevador a meio
pause 10
return