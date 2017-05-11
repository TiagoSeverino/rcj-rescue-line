#picaxe 40x2
#com 5
#no_table
#no_data 

;Variáveis:
symbol metal=pina.0    		;Sensor De Metal
symbol calibrar=pina.1		;Botão Para Calibrar A Bussola
symbol obsEsq=pina.2   		;Sensor De Obstaculos Esquerdo(Fica A 1 Quando Está A Tocar)
symbol obsDir=pina.3   		;Sensor De Obstaculos Direito(Fica A 1 Quando Está A Tocar)
;pinA.4 Livre
;pinA.5 Livre
symbol irFrente=pina.6  	;Sensor De InfraVermelhos Para Ver Parede
;pinA.7 Livre



symbol traseira=pinc.0 		;Botão Traseiro
;C.1 PWM
;C.2 PWM
symbol verdeDir=pinc.7 		;Sensor Verde Lado Direito


symbol verdeEsq=pind.0 		;Sensor Verde Lado Esquerdo
symbol mFrente=pind.1  		;Sensor De Linha Frente
symbol lDir=pind.2     		;Sensor De Linha Extremo Direito
symbol lEsq=pind.3     		;Sensor De Linha Extremo Esquerdo
symbol prateado=pind.4 		;Sensor Prateado
symbol mDir=pind.5     		;Sensor De Linha Direito
symbol mCentro=pind.6  		;Sensor De Linha Central
symbol mEsq=pind.7     		;Sensor De Linha Esquerdo
;DISTANCIA PAREDE SLA VARRIMENTOl

;Vars
symbol flag=b55			;Ultima Rotina Feita Antes De Perder A Linha
symbol CONTORNA=b54		;Lado a Contornar(0 Por Adicionar, 1 Esquerda, 2 Direita)
symbol ENCOSTA=b53		;Lado Onde Vai Encostar Na Sala De Evacuação(1 Esquerda, 2 Direita)
symbol bDir=b52			;Sala Evacuação Bussola Máximo Direita
symbol bEsq=b51			;Sala Evacuação Bussola Máximo Esquerda
symbol bMeio=b50			;Sala Evacuação Bussola Meio
symbol comVitima=b49		;Fica A 1 Se Estiver A Transportar Vitima
symbol isRecuar=b48		;Fica A 1 Se Estiver A Recuar Na Sala De Evacuação
symbol obstaculoDir=b47		;fica a 1 quando estamos a contornar o obstaculo pelo lado direito
symbol obstaculoEsq=b46		;fica a 1 quando estamos a contornar o obstaculo pelo lado esquerdo
symbol pista=b45 			;0 para pista direita, 1 para pista esquerda -- visto da parte mais alta para a mais baixa
symbol fila=b44			;Ultima Fila Varrida Na Sala De Evacuação
symbol filaAgora=b43		;Fila Onde Está O Robo Na Sala De Evacuação
symbol procuraDir=b42		;fica a 1 se a ultima procura quando nao ha linha tiver sido para a direita
symbol procuraEsq=b41		;fica a 1 se a ultima procura quando nao ha linha tiver sido para a esquerda
symbol ladoDir=b40		;fica a 1 se estiver a questionar linha do lado direito
symbol ladoEsq=b39		;fica a 1 se estiver a questionar linha do lado esquerdo
symbol contacanto=b38
symbol i=w18			;Usada Para Os For's
symbol canto=b35
symbol final=b34
;B12-B33 Livres

;W0 Bussola
;W1 Sonar_Esq
;W2 Sonar_Dir
;W3 Sonar_Frente
;W4 SRF10
;W5 SRF02


; **************************************************************************************
; ************************************* Main *******************************************
; **************************************************************************************

gosub pincaCima

inicio:
if calibrar=1 then calibrarBussola
if prateado=1 then salaBolas
if verdeDir=1 or verdeEsq=1 then intersecao
if obsDir=1 or obsEsq=1 then obstaculo
goto seguirLinha

; **************************************************************************************
; ************************************ Debugar *****************************************
; **************************************************************************************

debugar:
gosub bussola		;B1
gosub sonar_esq		;W1
gosub sonar_dir		;W2
gosub sonar_frente	;W3
gosub srf10			;W4
gosub srf02			;W5
b35 = calibrar		;Botão Para Calibrar A Bussola
b34 = traseira 		;Botão Traseiro
b33 = prateado 		;Sensor Prateado
b32 = verdeDir 		;Sensor Verde Lado Direito
b31 = verdeEsq 		;Sensor Verde Lado Esquerdo
b30 = obsDir  		;Sensor De Obstaculos Direito
b29 = obsEsq   		;Sensor De Obstaculos Esquerdo
b28 = mEsq     		;Sensor De Linha Esquerdo
b27 = mCentro  		;Sensor De Linha Central
b26 = mDir     		;Sensor De Linha Direito
b25 = lEsq     		;Sensor De Linha Extremo Esquerdo
b24 = lDir     		;Sensor De Linha Extremo Direito
b23 = mFrente  		;Sensor De Linha Frente
b22 = irFrente  		;Sensor De InfraVermelhos Para Ver Parede
;b21 = obsDir1  		;Sensor De Obstaculos Direito Avançado
b20 = metal    		;Sensor De Metal
debug
return

; **************************************************************************************
; ************************* Leitura De Sensores Sensores *******************************
; **************************************************************************************

bussola:		;Guarda B1
i2cslave $C0,i2cfast,i2cbyte	' Define i2c slave address for the CMPS03 
readi2c 0,(b0)			' Read CMPS03 Software Revision
readi2c 1,(b1)			' Read compass bearing as a byte (0-255 for full circle)
return

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

sonar_frente:	;Guarda W3(b6, b7)
low b.3
PULSOUT b.3, 1
PULSIN b.3, 1, w3
low b.3
return

srf10:	;Guarda W4(b8, b9)
i2cslave $F2,i2cfast,i2cbyte 	' Join i2c with SRF10 
i2cwrite 0,(81) 			' Send command for ranging
pause 70 				' wait for ranging to complete 
i2cread 2,(b9, b8) 		' Read in high byte and low byte 
return

srf02:	;Guarda W5(b10, b11)
i2cslave $E4,i2cfast,i2cbyte  ' Join i2c with SRF10 
i2cwrite 0,(81) 			' Send command for ranging
pause 70 				' wait for ranging to complete 
i2cread 2,(b11, b10) 		' Read in high byte and low byte 
return

; **************************************************************************************
; ************************************ Bussola *****************************************
; **************************************************************************************

calibrarBussola:
gosub debugar
gosub bussola
if b1>116  and b1<137 then liga_led_amarelo
if b1>105  and b1<148 then pisca_led_amarelo
if b1<117 then desliga_led_amarelo
if b1>136 then desliga_led_amarelo
goto inicio

liga_led_amarelo:
high b.2
goto inicio

pisca_led_amarelo:
toggle b.2
pause 50
goto inicio

desliga_led_amarelo:
low b.2
goto inicio

; **************************************************************************************
; ****************************** Seguimento De Pista ***********************************
; **************************************************************************************

seguirLinha:
if mEsq=0 and mCentro=0 and mDir=0 then branco
if mEsq=1 and mCentro=1 and mDir=1 then cruzamento
if mEsq=1 and mCentro=0 and mDir=1 then branco

if mEsq=0 and mCentro=1 and mDir=0 then frt
if mEsq=0 and mCentro=1 and mDir=1 then dir_1
if mEsq=0 and mCentro=0 and mDir=1 then dir
if mEsq=1 and mCentro=1 and mDir=0 then esq_1
if mEsq=1 and mCentro=0 and mDir=0 then esq
goto inicio

frt:
if lEsq=1 and lDir=1 then avancar
;if lEsq=1 and lDir=0 then esquerda_r
;if lEsq=0 and lDir=1 then direita_r

if lEsq=1 then 
	gosub avancar_ret
	pause 80
	gosub rodarEsq135
	goto inicio
endif
if lDir=1 then 
	gosub avancar_ret
	pause 80
	gosub rodarDir135
	goto inicio
endif

if lEsq=0 and lDir=0 then avancar
goto inicio

branco:
if lEsq=1 then esquerda_r
if lDir=1 then direita_r

if flag=0 or flag=1 or flag=2 then avancar
if flag=3 then esquerda_r
if flag=4 then direita_r
goto inicio

cruzamento:
if lEsq=1 and lDir=1 then avancar
if lEsq=1 and lDir=0 then esquerda_r
if lEsq=0 and lDir=1 then direita_r
if lEsq=0 and lDir=0 then avancar
goto inicio

esq:
if lEsq=1 then esquerda_r
if lEsq=0 then esquerda
goto inicio

dir:
if lDir=1 then direita_r
if lDir=0 then direita
goto inicio

esq_1:
;if mFrente=1 then avancar
if lEsq=1 then 
	ladoEsq=1
	ladoDir=0
	goto confirma_frente
endif
;esquerda_r
if lEsq=0 then esquerda
goto inicio

dir_1:
;if mFrente=1 then avancar
if lDir=1 then 
	if mFrente=1 then
		gosub avancar_ret
		pause 150
		if mEsq=0 or mCentro=0 or mDir=0 then
			gosub rodarDir135
			goto inicio
		endif
	else
		goto direita_r
	endif
endif
;direita_r
if lDir=0 then direita
goto inicio

confirma_frente:
if mFrente=1 then
		for i=1 to 10
			i=0
			if lEsq=0 and ladoEsq=1 then
				if mCentro=1 or mFrente=1 then seguirLinha
				endif
			endif
		next i
goto inicio

rodarEsq135:
gosub rodar_esquerda
pause 800
return

rodarDir135:
gosub rodar_direita
pause 800
return

avancar:  
gosub m_11
pwmout c.2,10,24     
pwmout c.1,10,23
flag=0
goto inicio

esquerda:
gosub m_31
pwmout c.2,10,31
pwmout c.1,10,31
flag=1
goto inicio

direita:
gosub m_13
pwmout c.2,10,31
pwmout c.1,10,31
flag=2
goto inicio

esquerda_r:
gosub m_21
pwmout c.2,10,45
pwmout c.1,10,45
flag=3
goto inicio

direita_r:
gosub m_12
pwmout c.2,10,45
pwmout c.1,10,45
flag=4
goto inicio

; **************************************************************************************
; *************************************** Verde ****************************************
; **************************************************************************************

intersecao:
if verdeEsq=0 and verdeDir=1 then interDir
if verdeEsq=1 and verdeDir=0 then interEsq
goto inicio

interDir:
if mFrente=1 then virarDir
if mDir=1 or lDir=1 then direita
goto avancar

interEsq:
if mFrente=1 then virarEsq
if  mEsq=1 or lEsq=1 then esquerda
goto avancar

virarDir:
if mDir=0 then seguirLinha
gosub para_ret
pause 500
gosub avancar_lento_ret
pause 350
gosub direita_rap_ret
pause 450
gosub direita_verde
goto inicio

virarEsq:
if mEsq=0 then seguirLinha 
gosub para_ret
pause 500
gosub avancar_lento_ret
pause 350
gosub esquerda_rap_ret
pause 450
gosub esquerda_verde
goto inicio

esquerda_verde:
if lEsq=1 or mEsq=1 or mCentro=1 or mDir=1 then inicio'or lDir=1 
gosub m_21
pwmout c.2,10,29
pwmout c.1,10,8
goto esquerda_verde

direita_verde:
if mEsq=1 or mCentro=1 or mDir=1 or lDir=1 then inicio'or lEsq=1 
gosub m_12
pwmout c.2,10,8
pwmout c.1,10,29
goto direita_verde

para_ret:
gosub m_00
return

; **************************************************************************************
; ************************************* Obstaculo **************************************
; **************************************************************************************


obstaculo:
obstaculoDir=0
obstaculoEsq=0
if obsEsq=0 and obsDir=1 then desvioEsquerda
if obsEsq=1 and obsDir=0 then desvioDireita
if obsEsq=1 and obsDir=1 then recuar
goto inicio

desvioDir1:
obstaculoDir=1
gosub recuar_ret
pause 50
gosub direita_rap_ret
pause 325
for b24= 1 to 50
gosub contorna_direita
next b24
for b24= 1 to 256
gosub pista_direita_avancar
next b24
goto inicio

desvioEsq1:
obstaculoEsq=1
gosub recuar_ret
pause 50
gosub esquerda_rap_ret
pause 325
for b24= 1 to 50
gosub contorna_esquerda
next b24
for b24= 1 to 256
gosub pista_esquerda_avancar
next b24
goto inicio

contorna_direita:
gosub sonar_Esq
if w1<76 then direita1rod_ret
if w1>75 then esquerda1rod_ret

contorna_esquerda:
gosub sonar_Dir
if w2<76 then esquerda1rod_ret
if w2>75 then direita1rod_ret

pista_direita_avancar:
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then contorna_direita 'c_avancar         
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=0 then direita_ret
if pind.7=0 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then avancar   
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then esquerda_ret
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar

if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=1 then direita_ret  
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=1 then direita_rap_ret   
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then direita_rap_ret  
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then avancar_ret
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=1 and pind.2=0 then esquerda_rap_ret
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then avancar_ret

if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then direita_rap_ret
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then roda_tudo_direita
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=0 then roda_tudo_direita
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=1 then roda_tudo_direita
return

pista_esquerda_avancar:
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then contorna_esquerda'c_avancar        
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=0 then direita_ret
if pind.7=0 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then avancar   
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then esquerda_ret
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar

if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=1 then avancar_ret  
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=1 then avancar_ret  
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then direita_rap_ret 
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then esquerda_ret
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=1 and pind.2=0 then esquerda_rap_ret
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then esquerda_rap_ret

if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then esquerda_rap_ret
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then roda_tudo_esquerda
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=0 then roda_tudo_esquerda
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=1 then roda_tudo_esquerda
return

roda_tudo_direita:
gosub avancar_ret
pause 60
gosub direita_rap_ret
pause 450
goto inicio

roda_tudo_esquerda:
gosub avancar_ret
pause 80
gosub esquerda_rap_ret
pause 450
goto inicio

; ************************************** Rotinas ***************************************
desvioDireita:
gosub m_00
gosub sonar_dir
if w2<191 then desvioDir1
if w2>190 then desvioDir1

desvioEsquerda:
gosub m_00
gosub sonar_esq
if w1<191 then desvioDireita
if w1>190 then desvioEsq1



direita1rod_ret: 
gosub m_10
pwmout c.2,10,27
pwmout c.1,10,27
return

esquerda1rod_ret: 
gosub m_01
pwmout c.2,10,27
pwmout c.1,10,27
return

; **************************************************************************************
; *********************************** Sala Evacuacao ***********************************
; **************************************************************************************

; ######################################################################################
; ##################################### Entrada ########################################
; ######################################################################################

salaBolas:
gosub m_00
gosub pincaVarre
pause 2000
gosub avancar_ret
pause 800



;Ver Para Que Lado Encostar
gosub sonar_Esq
gosub sonar_Dir

if w1>w2 then
	pista=0
else
	pista=1
endif

for i=1 to 2000

if pista=0 then
	gosub sonar_dir

	if w2>100 then gosub avancar_esq_ret
	if w2<=100 then gosub avancar_dir_ret
else
	gosub sonar_esq

	if w1>100 then gosub avancar_dir_ret
	if w1<=100 then gosub avancar_esq_ret
endif

pause 1

if irFrente=1 then
	i=2000
	gosub avancar_l_ret
	pause 2000
endif

next i

if irFrente=0 then
	gosub recuar_ret
	pause 300
	if pista=1 then
		gosub esquerda_ret
	else
		gosub direita_ret
	endif
	pause 1000
endif

gosub recuar_ret
pause 20

gosub parar_ret
pause 500

gosub pincaAgarra
pause 1000

for i=1 to 1200
	if metal=0 then
		comVitima=1
		i=1200
	else
		comVitima=0
	endif
	pause 1
next i 


if comVitima=0 then
	gosub recuar_ret
	pause 30
	
	gosub parar_ret
	pause 3000
	gosub rodarPista
	gosub voltaUltimaFila

	
	gosub recuar_ret
	pause 150
	gosub rodarPista

	gosub encostaParede
else
	gosub rodarPista1
	gosub recuar_ret
	pause 500
	
	gosub meterBola
endif

gosub m_00
pause 500
gosub carregaValor
fila=0
goto procuraBola

encostaParede:
gosub m_22
pwmout c.2,10,31
pwmout c.1,10,30
if traseira=0 then encostaParede
gosub m_20
pause 250
gosub m_02
pause 250
gosub m_22
pause 800
return

carregaValor:
gosub bussola

let bMeio=b1
let bDir=bMeio+1; Para So Ter 2 Valores De Precisão
let bEsq=bMeio+1 
return


;Procura Bola
procuraBola:
if comVitima=0 then
	
	;Varre Fila
	if filaAgora=fila then
		gosub avancarParede
	endif
	
	if canto=1 and filaAgora>3 and comVitima=1 and final=0 then 
		gosub rodarPista1
		gosub avancar_ret
		pause 1500
	endif
	
	if comVitima=1 and filaAgora=0 and canto>=3 and final=0 or comVitima=1 and filaAgora=5 and canto=2 and final=0 then
		for i=1 to 400
			if obsEsq=1 or obsDir=1 and w4>3 then
				gosub encostaPlataforma
				gosub parar_ret
				pause 100
				
				gosub pincaLarga
				pause 3000
				comVitima=0
				gosub pincaCima
				pause 1000
				i=400
			endif
			gosub avancar_ret
			pause 1
		next i	
	endif
	
	if comVitima=1 and canto>1 and filaAgora>0 and filaAgora<5 and final=0 then
		gosub avancar_ret
		pause 600
			
		if canto>=2 then
			if canto=2 then
				gosub rodarPista
				gosub parar_ret
				pause 2000
				for i=0 to 200
					i=0
					if obsEsq=1 or obsDir=1 then 
						gosub encostaPlataforma
						
						gosub pincaLarga
						pause 3000
						gosub pincaCima
						pause 1000
						
						gosub voltaUltimaFila
						comVitima=0
						filaAgora=0
						gosub meterBola1
						goto procuraBola
					endif
					
					if pista=0 then
						gosub sonar_esq

						if w1>80 then gosub avancar_esq_ret1
						if w1<=80 then gosub avancar_dir_ret1
					else
						gosub sonar_dir

						if w2>80 then gosub avancar_dir_ret1
						if w2<=80 then gosub avancar_esq_ret1
					endif
				next i
			else ;canto=3
				gosub rodarPista1
				gosub parar_ret
				pause 2000
				for i=0 to 200
					i=0
					if obsEsq=1 or obsDir=1 then 
						gosub encostaPlataforma
						
						gosub pincaLarga
						pause 3000
						gosub pincaCima
						pause 1000
						
						gosub voltaUltimaFila
						comVitima=0
						filaAgora=0
						gosub meterBola1
						goto procuraBola
					endif
					
					if pista=1 then
						gosub sonar_esq

						if w1>80 then gosub avancar_esq_ret1
						if w1<=80 then gosub avancar_dir_ret1
					else
						gosub sonar_dir

						if w2>80 then gosub avancar_dir_ret1
						if w2<=80 then gosub avancar_esq_ret1
					endif
				next i
			endif
		endif	
	
	
	endif

	gosub recuarParede

	gosub avancar_ret
	pause 300
	
	if comVitima=0 then
		
		if filaAgora<fila then
			gosub rodarPista
		elseif filaAgora>fila then
			gosub rodarPista1
		endif
		
		gosub avancar_ret
		pause 500
		
		if filaAgora<fila then
			gosub rodarPista1
			inc filaAgora
		elseif filaAgora>fila then
			gosub rodarPista
			dec filaAgora
		endif
		
		gosub recuarParede
	else
		if canto=1 and final=1 then 
			gosub rodarPista1
		else
			gosub rodarPista
		endif
	endif
	
else
	gosub meterBola
endif
goto procuraBola


rodarPista:

if pista=0 then
	gosub rodar_direita
else
	gosub rodar_esquerda
endif
pause 680
return

rodarPista1:

if pista=0 then
	gosub rodar_esquerda
else
	gosub rodar_direita
endif
pause 680
return

avancarParede:
gosub pincaVarre
pause 500

avancarParede1:
for i=1 to 2000
	pause 1
	gosub bussola

	if b1>bEsq and b1<bDir then
		gosub avancar_l_ret
	else
		if b1<bMeio then
			gosub avancar_esq_ret
		else
			gosub avancar_dir_ret
		endif
	endif


if irFrente=1 then
	i=2000
	gosub avancar_l_ret
	pause 2000
endif

next i


if filaAgora=0 and irFrente=0 then
	gosub recuar_ret
	pause 300
	if pista=0 then
		gosub esquerda_ret
	else
		gosub direita_ret
	endif
	pause 1000
endif
if filaAgora=5 and irFrente=0 then
	gosub recuar_ret
	pause 300
	if pista=1 then
		gosub esquerda_ret
	else
		gosub direita_ret
	endif
	pause 1000
endif


gosub recuar_ret
pause 20

gosub parar_ret
pause 1000

gosub pincaAgarra
pause 2000

for i=1 to 1000
		if metal=0 then
			comVitima=1
			i=1000
		endif
		pause 1
	next i

	if comVitima=0 then
		inc fila
	endif

return


recuarParede:
for i=1 to 1000
gosub bussola

if b1>bEsq and b1<bDir then 
	gosub recuar_ret
else
	if b1<bMeio then 
		gosub recuar_esq_ret
	else
		gosub recuar_dir_ret
	endif
endif
pause 1
if traseira=1 then
	i=1000
endif
next i
gosub m_20
pause 250
gosub m_02
pause 250
gosub m_22
pause 800

if final=1 and fila=0 then 
	gosub rodarPista
	
	gosub avancar_ret
	pause 2000
	gosub rodarPista1
	goto final1
endif
if filaAgora>5 and final=0 then final1
return


meterBola:

	if canto=1 and final=1 then
		procuraPlataforma_esp:
		if pista=1 then
			gosub sonar_dir
			
			if w2<68 then gosub avancar_esq_ret1
			if w2>=68 then gosub avancar_dir_ret1
		else
			gosub sonar_esq

			if w1<68 then gosub avancar_dir_ret1
			if w1>=68 then gosub avancar_esq_ret1
		endif
		gosub procuraPlataforma1
	endif
	gosub procuraPlataforma
	
	gosub parar_ret
	pause 1000
	
	if canto=0 then
		canto=contacanto+1
	endif
	
	
	gosub pincaLarga
	pause 3000
	gosub pincaCima
	pause 1000

	comVitima=0
	gosub voltaUltimaFila
	filaAgora=0
	
	meterBola1:
	if final=0 then
		gosub parar_ret
		pause 2000
		gosub recuar_ret
		pause 100
		gosub rodarPista
	
		gosub encostaParede
	else
		gosub recuarParede
	endif
	inc fila

return

procuraPlataforma:
if pista=0 then
	gosub sonar_dir
	
	if w2<68 then gosub avancar_esq_ret1
	if w2>=68 then gosub avancar_dir_ret1
else
	gosub sonar_esq

	if w1<68 then gosub avancar_dir_ret1
	if w1>=68 then gosub avancar_esq_ret1
endif

procuraPlataforma1:
gosub srf10

if w4>6 and obsEsq=0 and obsDir=0 and final=0 then procuraPlataforma
if w4>6 and obsEsq=0 and obsDir=0 and final=1 then procuraPlataforma_esp
if obsEsq=1 or obsDir=1 then
	encostaPlataforma:
	gosub avancar_ret
	
	if obsEsq=1 and obsDir=0 then
		gosub esquerda_ret
	endif

	if obsEsq=0 and obsDir=1 then
		gosub direita_ret
	endif

	pause 2000

	
	gosub parar_ret
	pause 1000
	
	return
else
	if canto=0 then 
		inc contacanto
	endif
	gosub rodarPista1
	
	goto procuraPlataforma
endif

return

voltaUltimaFila:

gosub recuar_ret
pause 50

gosub rodarPista

voltaUltimaFila1:

if pista=1 then
	gosub sonar_dir
	
	if w2<68 then gosub avancar_esq_ret1
	if w2>=68 then gosub avancar_dir_ret1
else
	gosub sonar_esq

	if w1<68 then gosub avancar_dir_ret1
	if w1>=68 then gosub avancar_esq_ret1
endif

gosub srf10
if w4>6 and prateado=0 then voltaUltimaFila1
if w4<=6 and prateado=0 then
	gosub rodarPista
	goto voltaUltimaFila1
endif
	

return

pincaCima:
low c.5 ;Cima 
low c.6
pause 500
return

pincaAgarra:
low c.5 ;Agarra
high c.6
pause 500
return

pincaVarre:
high c.5 ;Baixa Para Varrer
low c.6
pause 500
return

pincaLarga:
high c.5 ;Larga Bola
high c.6
pause 500
return

; **************************************************************************************
; ********************************** Rotinas Gerais ************************************
; **************************************************************************************

avancar_ret:
gosub m_11
pwmout c.2,10,26
pwmout c.1,10,25'Acerto dos motores
return

avancar_l_ret:
gosub m_11
pwmout c.2,10,20
pwmout c.1,10,20'Acerto dos motores
return

avancar_r_ret:
gosub m_11
pwmout c.2,10,35
pwmout c.1,10,35'Acerto dos motores
return

avancar_esq_ret1:
gosub m_01
pwmout c.2,10,30
pwmout c.1,10,30'Acerto dos motores
return

avancar_esq_ret:
gosub m_11
pwmout c.2,10,5
pwmout c.1,10,20'Acerto dos motores
return

avancar_dir_ret1:
gosub m_10
pwmout c.2,10,30
pwmout c.1,10,30'Acerto dos motores
return

avancar_dir_ret:
gosub m_11
pwmout c.2,10,20
pwmout c.1,10,5'Acerto dos motores
return

recuar_dir_ret:
gosub m_22
pwmout c.2,10,25
pwmout c.1,10,41'Acerto dos motores
return

recuar_esq_ret:
gosub m_22
pwmout c.2,10,41
pwmout c.1,10,25'Acerto dos motores
return

recuar_dir_ret1:
gosub m_02
pwmout c.2,10,18
pwmout c.1,10,18
return

recuar_esq_ret1:
gosub m_20
pwmout c.2,10,18
pwmout c.1,10,18
return

avancar_lento_ret:
gosub m_11
pwmout c.2,10,26
pwmout c.1,10,25
return

parar_ret:
gosub m_00
return

recuar_ret:
gosub m_22
pwmout c.2,10,28
pwmout c.1,10,28
return

recuar:
gosub m_22
pwmout c.2,10,32
pwmout c.1,10,32
goto inicio


esquerda_rap_ret:
gosub m_21
pwmout c.2,10,30
pwmout c.1,10,30
return

direita_rap_ret:
gosub m_12
pwmout c.2,10,30
pwmout c.1,10,30
return

esquerda_l_ret:
gosub m_21
pwmout c.2,10,15
pwmout c.1,10,15
return

direita_l_ret:
gosub m_12
pwmout c.2,10,15
pwmout c.1,10,15
return

direita_ret: 
gosub m_10
pwmout c.2,10,35
pwmout c.1,10,35
return

esquerda_ret: 
gosub m_01
pwmout c.2,10,35
pwmout c.1,10,35
return

rodar_esquerda:
gosub m_21
pwmout c.2,10,25 
pwmout c.1,10,25 
return

rodar_direita:
gosub m_12
pwmout c.2,10,25
pwmout c.1,10,25
return

; **************************************************************************************
; ************************************ Motores *****************************************
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




;FINAL

final1:
if final=0 then ;para só reiniciar valores apenas uma vez
	filaAgora=0
	fila=0
	final=1
	
	gosub avancar_ret
	pause 2000
	gosub rodarPista1
	gosub encostaParede
	gosub carregaValor
endif
inc fila
goto procuraBola





