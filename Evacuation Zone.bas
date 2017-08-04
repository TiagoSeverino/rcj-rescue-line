#picaxe 40x2

#no_table
#no_data
#slot 1
;###########################################################
;Vari?veis
;###########################################################

symbol traseira=pina.0 		;Bot?o Traseiro
symbol calibrar=pina.1		;Bot?o Para Calibrar A Bussola
symbol wall=pina.2   		;Sensor De Obstaculos Direito(Fica A 1 Quando Est? A Tocar)
symbol obs=pina.3   		;Sensor De Obstaculos Esquerdo(Fica A 1 Quando Est? A Tocar)
symbol obsEvacuation=pina.5	;Sensor toque ver parede
symbol toca_esq=pina.6	;Sensor toque ver plataforma lado direito
symbol toca_dir=pina.7	;Sensor toque ver plataforma lado direito
symbol incSens=pinc.0		;Sensor De Inclina??o
symbol verdeDir=pind.0 		;Sensor Verde Lado Direito
symbol verdeEsq=pind.4 		;Sensor Verde Lado Esquerdo
symbol mFrente=pind.1  		;Sensor De Linha Frente
symbol lDir=pind.2     		;Sensor De Linha Extremo Direito
symbol lEsq=pind.3     		;Sensor De Linha Extremo Esquerdo
symbol prateado=pinc.7 		;Sensor Prateado
symbol mDir=pind.5     		;Sensor De Linha Direito
symbol mCentro=pind.6  		;Sensor De Linha Central
symbol mEsq=pind.7     		;Sensor De Linha Esquerdo
symbol abre_bolas=pinb.3	;Servo para abrir zona das bolas

symbol plataforma=b54		;indica qual o local da plataforma
symbol pista=b52 			;0 para pista direita, 1 para pista esquerda -- visto da parte mais alta para a mais baixa
symbol afasta=b51
symbol confirma=b50
symbol aux=b49
symbol parede=b48
symbol subiu=b47
symbol meio=b46
symbol change=b45
symbol changemeio=b44
symbol viuObs=b43
SYMBOL check=b42
symbol temp=w8
symbol temp_rodar=w9
symbol temp_avancar=w10
symbol temp_recuar=w11
symbol temp_ajeitar=w12

symbol LaserSide = b9
symbol Data_Byte = b1 'Holds 8 bit data
symbol Distance_mm = b11 'Holds distance reading in mm
symbol LaserConv = w6; Laser in Sonar Unit
symbol Address_16 = w7 'Holds 16 bit address for read/write
LaserSide = 255

goto inicio
#INCLUDE "Laser.bas"

;###########################################################
;C?digo
;###########################################################


inicio:
gosub m_00
servo 3, 250
pause 140
low b.3
pause 800
;do while parede_dir=0 and parede_esq=0
;loop

gosub avancar_l_ret
pause 900
;Descobre qual o tipo de pista que entrou
gosub sonar_Esq
gosub sonar_Dir
;w1 - esq
;w2 - dir

;ver se a pista come?a com parede do lado direita (=0) ou do lado esquerdo (=1)
if w1>130 and w2>130 then
	pista=0
	meio=1
else
	if w2<w1 then
		pista=0
		meio=0
	else
		pista=1
		meio=0
	endif
endif



;********************************************
;********************************************
;********************************************


plataforma=0
parede=1
change=0
temp=0
if meio=1 then
	parede=0
endif

bolas:
if meio=1 then
	gosub avancar_l_ret
	pause 750
	gosub m_33
	pause 200
	if pista=0 then gosub rodar_direita
	if pista=1 then gosub rodar_esquerda
	pause 1000
	gosub recuar_ret
	pause 200
endif
gosub pinca_aberta

var:
temp=0
aux=parede
if meio=1 then 
	aux=aux+1
endif
do while aux>0
	high b.2
	pause 200
	low b.2
	pause 200
	aux=aux-1
loop


do while parede<=4
	;procura bolas no meio
	if check=1 then
		gosub procura_bola_meio
	endif
	
	;viu obstaculo
	if obsEvacuation=1 then
		gosub vira_obs
	endif
	
	;chegou ao canto
	if wall=1 then 
		temp=0
		gosub canto_var
	endif
	
	;viu a plataforma
	if toca_dir=1 or toca_esq=1 then
		parede=parede+1
		temp=0
		gosub afasta_plat
	endif
	
	;viu a porta
	if parede=4 then
		gosub sai_porta
	endif
	
	;voltou atras, e viu a porta
	if meio=1 and parede=0 then
		gosub sai_porta
	endif
	
	;voltou atras, e chegou de frente ao prateado
	if parede=1 or parede=4 then
		serin d.4, n4800_4, b20,b21,b22,b23
		if b23=1 then
			temp=0
			gosub frente_prata
		endif
	endif
		
	if temp>680 and check=0 then
		gosub endd
	endif
	if temp>80 and check=1 then
		gosub endd
	endif
	temp=temp+1
	gosub contorna_parede
loop


endd:
temp=0
for b0=0 to 3
gosub recuar_l_ret
pause 450
if pista=0 then
	gosub rodar_direita3
else
	gosub rodar_esquerda3
endif
pause 700
gosub avancar_r_ret
pause 1700

if wall=1 then
	exit
endif
next b0
gosub canto_var
goto var
return

canto_var:
if parede<4 then
	gosub recuar_l_ret
	pause 450
	if pista=0 then
		gosub rodar_direita3
	else
		gosub rodar_esquerda3
	endif
	pause 600
	do while wall=0
		gosub avancar_l_ret
	loop

endif

if meio=1 and parede<2 then
	gosub recuar_l_ret
	pause 15
endif
gosub agarra_rapido
gosub verifica_frente

if parede<4 then
w1=0
w2=0
	if pista=0 then
		do while w2<65
			gosub recuar_desencrava
			gosub verifica_frente
			gosub m_33
			pause 500
			gosub sonar_Dir
		loop
	else
		do while w1<65
			gosub recuar_desencrava
			gosub verifica_frente
			gosub m_33
			pause 500
			gosub sonar_Esq
		loop
	endif
endif

gosub recuar_ret
pause 70
high b.7, b.6, b.5, b.4
pause 500
if pista=0 then
	gosub rodar_esquerda4
else
	gosub rodar_direita4
endif
pause 1750

high b.7, b.6, b.5, b.4
pause 500

if parede<4 then
	temp=1
	gosub verifica_tras
	if change=0 then
		parede=parede+1 ;proxima parede
	else
		parede=parede-1
	endif
endif
if parede=4 and temp=0 then
	parede=1
	if meio=1 then
		parede=0
	endif
	change=0
endif

gosub avancar_l_ret
pause 100
gosub m_33
pause 300
gosub pinca_aberta

temp=0
return

;***********************************************************
;***********************************************************
;***********************************************************
;sonar_esq: 290/130/50
;sonar_dir: 320/160/50
procura_bola_meio:


if LaserSide <> pista then
	LaserSide = pista
	if pista = 0 then
		high d.0
		low c.7	
	else
		low d.0
		high c.7
	endif
	gosub setup
endif
GoSub Single_Shot_Read 

if pista=0 then
	gosub sonar_Esq
	w3=w1
else
	gosub sonar_Dir
	w3=w2
endif

if w3<350 and w3>210 then
	gosub avancar_l_ret
	pause 10
	
	if pista=0 then
		gosub sonar_Esq
		w3=w1
	else
		gosub sonar_Dir
		w3=w2
	endif
	if w3<350 and w3>210 then
		temp_rodar=w3*2+1100
		temp_avancar=w3*4+30
		temp_recuar=w3*2+370
		temp_ajeitar=w3*2+1220
		gosub bola_meio
		
	endif
endif
if Distance_mm > 20 and Distance_mm < 255 then
	high b.2
	LaserConv = Distance_mm / 50 * 58 
	temp_rodar=LaserConv*2+990
	temp_avancar=LaserConv*4+2
	temp_recuar=LaserConv*2+90
	temp_ajeitar=LaserConv*2+890
	low b.2
	gosub bola_meio
endif

return

bola_meio:
high b.2
low b.2

;if viuObs=1 then
;	viuObs=0
;	gosub m_00
;	pause 250
;	
;	do while w3<350
;		if pista=0 then
;			gosub sonar_Esq
;			w3=w1
;		else
;			gosub sonar_Dir
;			w3=w2
;		endif
;		
;		gosub avancar_l_ret
;	loop
;	gosub m_00
;	pause 250
;	return
;endif
	
gosub agarra_rapido
gosub m_33
pause 500
gosub recuar_ret
pause 380

if pista=0 then
	gosub recuar_dir
else
	gosub recuar_esq
endif
pause 250

if pista=0 then
	gosub rodar_esquerda2
else
	gosub rodar_direita2
endif
pause temp_rodar ;750-1250

gosub pinca_aberta

;temp_avancar=temp_avancar/3-200
;for w0=0 to temp_avancar
;	if obsEvacuation=1 then
;		high b.2
;		viuObs=1
;		low b.2
;		goto obss
;	endif
	gosub avancar_l_ret
	pause temp_avancar;1
;next w0

gosub agarra_rapido
gosub m_33
pause 500

obss:
gosub recuar_ret
pause temp_recuar ;350-800
gosub m_33
pause 300

if pista=0 then
	gosub recuar_esq
else
	gosub recuar_dir
endif
pause temp_ajeitar ;850-1350

gosub m_33
pause 500

if afasta=0 then
	gosub pinca_aberta
	gosub m_33
	pause 500
endif
gosub m_00
pause 1000
for w0=0 to 30
	serin d.4, n4800_4, b20,b21,b22,b23
	if b23=1 then
		gosub recuar_l_ret
		pause 100
		return
	endif
	gosub sai_porta
	if pista=0 then
		gosub avancar_vdir_ret
	else
		gosub avancar_vesq_ret
	endif
	pause 1
next w0
gosub m_00
pause 3000

return


;***********************************************************
;***********************************************************
;***********************************************************

afasta_plat:
afasta=1
gosub recuar_ret
pause 40
gosub agarra_rapido
gosub m_33
pause 500
gosub verifica_frente
gosub m_33
pause 200
gosub recuar_ret
pause 100
gosub m_33
pause 200

if pista=0 then
	gosub recuar_dir
	pause 400
	gosub rodar_esquerda2
	pause 1750
else
	gosub recuar_esq
	pause 400
	gosub rodar_direita2
	pause 1750
endif

gosub m_33
pause 300

if pista=0 then
	gosub rodar_esquerda
else
	gosub rodar_direita
endif
pause 720

gosub m_33
pause 300



gosub verifica_tras
gosub deixa_bolas

gosub avancar_ret
pause 100

if pista=0 then
	gosub rodar_direita
else
	gosub rodar_esquerda
endif
pause 900

gosub m_33
pause 500

b23=0
do while obs=0 and b23=0
	gosub procura_bola_meio
	gosub contorna_parede_longe
	serin d.4, n4800_4, b20,b21,b22,b23
	if b23=1 then
		temp=1
	endif
loop

if temp=1 then
	gosub recuar_ret
	pause 80
endif

gosub m_33
pause 500

if pista=0 then
	gosub recuar_dir
	pause 400
	gosub rodar_esquerda2
	pause 1020
else
	gosub recuar_esq
	pause 400
	gosub rodar_direita2
	pause 1020
endif


gosub m_33
pause 500
gosub pinca_aberta
pause 1000
afasta=0
temp=0
return


;********************************************
;********************************************
;********************************************
sai_porta:
if pista=0 and meio=0 then
	gosub sonar_Dir
	if w2>300 then
		gosub rodar_esquerda3
		pause 350
		do while wall=0
			gosub avancar_l_ret
		loop
	endif
elseif pista=1 and meio=0 then
	gosub sonar_Esq
	if w1>300 then
		gosub rodar_direita3
		pause 350
		do while wall=0
			gosub avancar_l_ret
		loop
	endif
endif

if changemeio=1 and pista=0 then cm0
if changemeio=1 and pista=1 then cm1

if meio=1 and pista=0 then
	cm0:
	gosub sonar_Dir
	if w2>200 then
		gosub rodar_esquerda3
		pause 700
		do while w2>200
			gosub avancar_l_ret
			gosub sonar_Dir
		loop
endif
elseif meio=1 and pista=1 then
	cm1:
	gosub sonar_Esq
	if w1>200 then
		gosub rodar_direita3
		pause 700
		do while w1>200
			gosub avancar_l_ret
			gosub sonar_Esq
		loop
	endif
endif

if meio=1 then
	change=0
	parede=0
endif
return

frente_prata:
gosub agarra_rapido
gosub recuar_desencrava
gosub m_33
pause 200
gosub avancar_ret
pause 220
gosub m_33
pause 200
if pista=0 then
	gosub rodar_esquerda4
else
	gosub rodar_direita4
endif
pause 1350
gosub verifica_tras
gosub pinca_aberta
gosub avancar_l_ret
pause 1000

parede=1
change=0
return

;********************************************
;********************************************
;********************************************

vira_obs:
gosub agarra_rapido

if pista=0 then
	gosub recuar_desencrava
	gosub rodar_esquerda
	pause 2350
else
	gosub recuar_desencrava
	gosub rodar_direita
	pause 2350
endif
if pista=0 then
	pista=1
else
	pista=0
endif
change=1
if changemeio=0 then
	changemeio=1
else
	changemeio=0
endif

gosub m_33
pause 200
gosub pinca_aberta
gosub m_33
pause 200
temp=0
return
;********************************************
;********************************************
;********************************************

deixa_bolas:
servo 3, 90
pause 1000
for b0=1 to 5
servo 3, 70
pause 250
servo 3, 90
pause 250
next b0
servo 3, 250
pause 140
low b.3
pause 1000
return

; **************************************************************************************
;M?todos
; **************************************************************************************



recuar_desencrava:
if pista=0 then
	gosub recuar_esq
else
	gosub recuar_dir
endif
pause 780
high b.7, b.6, b.5, b.4
pause 250
if pista=0 then
	gosub recuar_dir
else
	gosub recuar_esq
endif
pause 780
high b.7, b.6, b.5, b.4
pause 250
return

verifica_frente:
do while obs=0
	gosub avancar_ret
loop

if afasta=0 then
	gosub avancar_ret
	pause 600
endif
return

verifica_frente_procura:
do while obs=0
	gosub avancar_ret
	gosub procura_bola_meio
loop

return

verifica_tras:
temp=0
subiu=1
do while traseira=0 and temp<500
	gosub recuar_ret
	temp=temp+1
	if traseira=1 then
		subiu=0
	endif
loop
if subiu=0 then
	gosub recuar_ret
	pause 1000
else
	gosub avancar_ret
	pause 300
	gosub recuar_ret
	pause 1000
	if pista=0 then
		gosub recuar_dir
	else
		gosub recuar_esq
	endif
	pause 1000
	if traseira=0 then
		gosub avancar_ret
		pause 300
		gosub recuar_ret
		pause 1000
	endif
endif

high b.7, b.6, b.5, b.4
pause 300
return


contorna_parede:
if pista=0 then
	gosub sonar_dir
	if w2>=25 then gosub avancar_vdir_ret
	if w2<=15 then gosub avancar_vesq_ret
	if w2<25 and w2>15 then gosub avancar_l_ret
else 
	gosub sonar_esq
	if w1>=25 then gosub avancar_vesq_ret
	if w1<=15 then gosub avancar_vdir_ret
	if w1<25 and w1>15 then gosub avancar_l_ret
endif
return

contorna_parede_longe:
if pista=0 then
	gosub sonar_dir
	if w2>=75 then gosub avancar_vdir_ret
	if w2<=65 then gosub avancar_vesq_ret
	if w2<75 and w2>65 then gosub avancar_l_ret
else 
	gosub sonar_esq
	if w1>=75 then gosub avancar_vesq_ret
	if w1<=65 then gosub avancar_vdir_ret
	if w1<75 and w1>65 then gosub avancar_l_ret
endif
return

goto bolas


; **************************************************************************************
;Rotinas
; **************************************************************************************


rodar_esquerda:
low b.7, b.4
high b.6, b.5
pwmout c.2,10,38 
pwmout c.1,10,38 
return

rodar_direita:
high b.7, b.4
low b.6, b.5
pwmout c.2,10,38
pwmout c.1,10,38
return

rodar_esquerda2:
low b.7, b.6, b.4
high b.5
pwmout c.2,10,32 
pwmout c.1,10,32 
return

rodar_direita2:
high b.7
low b.6, b.5, b.4
pwmout c.2,10,32
pwmout c.1,10,32
return


rodar_esquerda3:
low b.7, b.6, b.4
high b.5
pwmout c.2,10,25 
pwmout c.1,10,25 
return

rodar_direita3:
high b.7
low b.6, b.5, b.4
pwmout c.2,10,25
pwmout c.1,10,25
return

rodar_esquerda4:
low b.7, b.4
high b.6, b.5
pwmout c.2,10,35 
pwmout c.1,10,25 
return

rodar_direita4:
high b.7, b.4
low b.6, b.5
pwmout c.2,10,25
pwmout c.1,10,35
return



avancar_ret:
high b.7, b.5
low b.6, b.4
pwmout c.2,10,35
pwmout c.1,10,35'Acerto dos motores
return


avancar_l_ret:
high b.7, b.5
low b.6, b.4
pwmout c.2,10,23
pwmout c.1,10,23'Acerto dos motores
return

avancar_r_ret:
high b.7, b.5
low b.6, b.4
pwmout c.2,10,45
pwmout c.1,10,45'Acerto dos motores
return

recuar_ret:
low b.7, b.5
high b.6, b.4
pwmout c.2,10,40
pwmout c.1,10,40
return

recuar_l_ret:
low b.7, b.5
high b.6, b.4
pwmout c.2,10,26
pwmout c.1,10,26
return

avancar_vesq_ret:
high b.7, b.5
low b.6, b.4
pwmout c.2,10,28
pwmout c.1,10,22
return

avancar_vdir_ret:
high b.7, b.5
low b.6, b.4
pwmout c.2,10,22
pwmout c.1,10,28
return

recuar_esq:
high b.7, b.6, b.4
low b.5
pwmout c.2,10,32
pwmout c.1,10,22
return

recuar_dir:
low b.7
high b.6, b.5, b.4
pwmout c.2,10,22
pwmout c.1,10,32
return


; **************************************************************************************
;Servos
; **************************************************************************************

agarra:
low c.5 ;Agarra
high c.6
high b.7, b.6, b.5, b.4
pause 1000
gosub pinca_fechada
high b.7, b.6, b.5, b.4
pause 1000
return


pinca_fechada:
low c.5 ;Cima 
low c.6
high b.7, b.6, b.5, b.4
pause 1000
return

agarra_rapido:
high c.5
high c.6
high b.7, b.6, b.5, b.4
pause 1000
low c.5
low c.6
return

pinca_aberta:
low c.5 ;Baixa Para Varrer
high c.6
high b.7, b.6, b.5, b.4
pause 1000
return

; **************************************************************************************
;Sensores
; **************************************************************************************

sonar_esq:		;Guarda W1(b2, b3)
low b.1
PULSOUT b.1, 1
PULSIN b.1, 1, w1
low b.1
return

sonar_dir:		;Guarda W2(b4, b5)
low b.0
PULSOUT b.0, 1
PULSIN b.0, 1, w2
low b.0
return


; **************************************************************************************
;Motores
; **************************************************************************************

m_00:
low b.7, b.6, b.5, b.4
return

m_01:
low b.7, b.6, b.4
high b.5
return

m_02:
low b.7, b.6, b.5
high b.4
return

m_03:
low b.7, b.6
high b.5, b.4
return

m_10:
high b.7
low b.6, b.5, b.4
return

m_11:
high b.7, b.5
low b.6, b.4
return

m_12:
high b.7, b.4
low b.6, b.5
return

m_13:
high b.7, b.5, b.4
low b.6
return

m_20:
low b.7, b.5, b.4
high b.6
return

m_21:
low b.7, b.4
high b.6, b.5
return

m_22:
low b.7, b.5
high b.6, b.4
return

m_23:
low b.7
high b.6, b.5, b.4
return

m_30:
high b.7, b.6
low b.5, b.4
return

m_31:
high b.7, b.6, b.5
low b.4
return

m_32:
high b.7, b.6, b.4
low b.5
return

m_33:
high b.7, b.6, b.5, b.4
return