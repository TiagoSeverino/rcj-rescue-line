#DEFINE LineFollowing

goto inicio
#INCLUDE "Settings.bas"


#REGION Main-Loop

	Main:	
		serin d.4, n4800_4, b20,b21,b22,b23
		gosub Green
		
		if b23=1 then 
			gosub getSonarDir
			gosub getSonarEsq
			if w1<200 or w0<200 then 
				goto EvacuationZone
			endif
		endif
		if ObsSensor=1 then Obstacle
		goto FollowLine
#ENDREGION

#REGION Line-Following

	FollowLine:
	if mLeft=0 and mCenter=1 and mRight=0 then Front
	if mLeft=0 and mCenter=0 and mRight=1 then Right
	if mLeft=1 and mCenter=0 and mRight=0 then Left
	if mLeft=0 and mCenter=1 and mRight=1 then Right_1
	if mLeft=1 and mCenter=1 and mRight=0 then Left_1
	if mLeft=1 and mCenter=1 and mRight=1 then Intersection
	if mLeft=0 and mCenter=0 and mRight=0 then 
		if eLeft = 1 then RotateLeftFast
		if eRight = 1 then RotateRightFast
		goto Gap
	endif
	if mLeft=1 and mCenter=0 and mRight=1 then 
		m_22(26,26)
		pause 150
	endif
	goto Main

	Front:
	if mFront=1 then
		if eLeft=1 or eRight=1 then confirmaa
		if eLeft=0 and eRight=0 then MoveForward
	endif

	if eLeft=1 and eRight=1 then MoveForward
	if eLeft=1 and eRight=0 then RotateLeftFast
	if eLeft=0 and eRight=1 then RotateRightFast
	if eLeft=0 and eRight=0 then MoveForward
	goto Main
	
	confirmaa:
	m_11(27, 27)
	pause 180
	if mFront=1 then
		goto MoveForward
	else 
		if mLeft=0 and mCenter=0 and mRight=0 then
			m_22(27,27)
		else
			goto Main
		endif
	endif
	goto Main

	Intersection:
		if mFront=1 then MoveForward
		if eLeft=1 and eRight=1 then MoveForward
		if eLeft=1 and eRight=0 then RotateLeftFast
		if eLeft=0 and eRight=1 then RotateRightFast
		if eLeft=0 and eRight=0 then MoveForward
		goto Main
		
	Gap:
	m_00(0,0)
	pause 200
	if mLeft=1 or mCenter=1 or mRight=1 or eLeft=1 or eRight=1 then Main
	m_22(22,21)
	for w0=1 to 190
		if mRight=1 and mCenter=1 and mLeft=1 then
			gosub Green
		endif
		if eLeft=1 then
			gosub Green
			high b.2
			low b.2
			m_11(27,27)
			pause 180
			m_00(0,0)
			pause 200
			gosub rodar_esquerda2
			pause 100
			do while mLeft=0
				gosub rodar_esquerda2
			loop
			goto Main
		elseif eRight=1 then
			gosub Green
			high b.2
			low b.2
			m_11(27,27)
			pause 180
			m_00(0,0)
			pause 200
			gosub rodar_direita2
			pause 100
			do while mRight=0
				gosub rodar_direita2
			loop
			goto Main
		endif
		pause 1
	next w0
	
	
	if mCenter=0 and mLeft=0 and mRight=0 then
		do while mCenter=0 and mLeft=0 and mRight=0
			m_11(26,26)
		loop
	endif
	do while mCenter=1 or mLeft=1 or mRight=1 or eLeft=1 or eRight=1
		if mLeft=1 or eLeft = 1 then
			m_01(50,50)
		elseif mRight=1 or eRight = 1 then
			m_10(50,50)
		else
			m_11(23,23)
		endif
	loop
	
	do while mCenter=0 and mLeft=0 and mRight=0 and eLeft=0 and eRight=0
		m_11(26,26)
	loop
	goto Main

	rodar_esquerda2:
	low b.7, b.4
	high b.6, b.5
	pwmout c.2,10,27
	pwmout c.1,10,27
	return

	rodar_direita2:
	high b.7, b.4
	low b.6, b.5
	pwmout c.2,10,27
	pwmout c.1,10,27
	return

	Left:
		if eLeft=1 then RotateLeftFast
		if eLeft=0 then RotateLeft
		goto Main

	Right:
		if eRight=1 then RotateRightFast
		if eRight=0 then RotateRight
		goto Main

	Left_1:
		if eLeft=0 then RotateLeft
		if mFront=1 then
			goto MoveForward
		endif
		if eLeft=1 then RotateLeftFast
		goto Main

	Right_1:
		if eRight=0 then RotateRight
		if mFront=1 then
			goto MoveForward
		endif
		if eRight=1 then RotateRightFast
		goto Main

	MoveForward:
		
		m_11(26, 26)
		goto Main

	RotateLeft:
		m_21(22, 30)
		goto Main

	RotateRight:
		m_12(30, 22)
		goto Main

	RotateLeftFast:
		m_21(27, 27)
		goto Main

	RotateRightFast:
		m_12(27, 27)
		goto Main
		
#ENDREGION

#REGION Obstacle

	Obstacle:
;		contorna
		m_22(32,32)
		do while ObsSensor=1
		loop
		pause 100

		m_00(0,0)
		pause 500
		gosub GetSonarDir
		
;		escolhe o lado onde tem espa?o
;		if w1>280 then
;			LadoObs = 0
;		else
;			LadoObs = 1
;		endif

;		viciar
		;LadoObs=1
	
		if LadoObs = 1 then
			m_21(32,32)
		else
			m_12(40,40)
		endif
		pause 1000
		
		m_00(0,0)
		pause 500
		
		m_11(32,32)
		pause 250
		if LadoObs = 0 then
			gosub GetSonarEsq
			do while w0<300
				gosub GetSonarEsq
			loop
		else
			gosub GetSonarDir
			do while w1<300
				gosub GetSonarDir
			loop
		endif
		
		if LadoObs = 0 then
			m_01(40,40)
		else
			m_10(40,40)
		endif
		pause 2850

		m_00(0,0)
		pause 500
		
		m_11(32,32)
		pause 145
		
		if LadoObs = 0 then
			m_01(40,40)
		else
			m_10(40,40)
		endif
		pause 1800
		
		m_11(32,32)
		pause 90
		if LadoObs = 0 then
			do while eLeft=0
			loop
		else
			do while eRight=0
			loop
		endif
		
		m_11(32,32)
		pause 310
		
		if LadoObs = 1 then
			m_21(40,40)
		else
			m_12(40,40)
		endif
		pause 650
		
		m_22(32,32)
		pause 400
	
		m_00(0,0)
		pause 500

;		empurra
;		m_11(45,45)
;		pause 200
;		gosub pinca_baixa
;		pause 500
;		m_11(45,45)
;		pause 200
;		gosub pinca_fechada
;		m_22(30,30)
;		pause 220
		goto Main
		
		
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
		
		pinca_baixa:
		high c.5 ;Baixa Para Varrer
		low c.6
		high b.7, b.6, b.5, b.4
		pause 500
		return
		
#ENDREGION

#REGION Green
		Green:
		
		
		if b22=1 then virarTras
		if b20=1 then virarEsq
		if b21=1 then virarDir
		return
;			do while RightWall=0 and LeftWall=0
;				m_00(0,0)
;			loop
;			goto Main

		ae:
		if b22=1 or b20=1 or b21=1 then 
			m_00(0,0)
			pause 2000
		endif
		return
				
		virarTras:
		high b.2
		high b.7, b.6, b.5, b.4
		pause 1000
		
		
		
		gosub rodar_direita
		pause 1300
		low b.2
		do while mRight=0
			gosub rodar_direita
		loop
		goto Main

		virarDir:
		if mRight=0 then 
			gosub avancar_l_ret
			pause 100
			goto Main
		endif
		high b.2
		confirma=0
		if mLeft=1 and mCenter=1 and mRight=1 then
			if eLeft=1 and eRight=1 then
				high b.7, b.6, b.5, b.4
				pause 300
				confirma=1
				gosub confirma_dois
			endif
		endif
		if confirma=0 then
			gosub avancar_l_ret
			pause 20
			serin d.4, n4800_4, b20,b21,b22,b23
			if b21=0 then
				goto Main
			endif
		endif
		high b.7, b.6, b.5, b.4
		pause 500
		verdee=1
		if mFront=1 then ;cruz
			gosub avancar_l_ret
			pause 80
			
;			if mLeft=0 and mCenter=0 and mRight=0 then voltar_pista
			gosub rodar_direita3
			pause 300

			do while mFront=0
				gosub rodar_direita3
			loop
			gosub avancar_l_ret
			pause 100
			if mCenter=0 and mLeft=0 and mRight=0 then
				do while mCenter=0 and mLeft=0 and mRight=0
					gosub rodar_direita3	
				loop
			endif
			
		else ;T
			gosub avancar_l_ret
			pause 80
			do while mFront=0
				gosub rodar_direita3
			loop
		
		endif
		
		
		low b.2
		gosub confirma_dois_verdes
		goto Main


		virarEsq:
		if mLeft=0 then 
			gosub avancar_l_ret
			pause 100
			goto Main
		endif
		high b.2
		confirma=0
		if mLeft=1 and mCenter=1 and mRight=1 then
			if eLeft=1 and eRight=1 then
				high b.7, b.6, b.5, b.4
				pause 300
				confirma=1
				gosub confirma_dois
			endif
		endif
		if confirma=0 then
			gosub avancar_l_ret
			pause 20
			serin d.4, n4800_4, b20,b21,b22,b23
			
			if b20=0 then 
				goto Main
			endif
		endif
		verdee=2
		high b.7,b.6,b.5,b.4
		pause 300
		if mFront=1 then ;cruz
			gosub avancar_l_ret
			pause 80
;			if mLeft=0 and mCenter=0 and mRight=0 then voltar_pista
			gosub rodar_esquerda3
			pause 300
			do while mFront=0
				gosub rodar_esquerda3
			loop
			gosub avancar_l_ret
			pause 100
			if mCenter=0 and mLeft=0 and mRight=0 then
				do while mCenter=0 and mLeft=0 and mRight=0
					gosub rodar_esquerda3	
				loop
			endif
			
		else ;T
			gosub avancar_l_ret
			pause 80
			do while mFront=0
				gosub rodar_esquerda3
			loop
		
		endif
		
		
		low b.2
		gosub confirma_dois_verdes
		goto Main

		confirma_dois:
		high b.7, b.6, b.5, b.4
		pause 300
		
		gosub recuar_l_ret
		pause 100

		high b.7, b.6, b.5, b.4
		pause 500
		do while mLeft=0 or mCenter=0 or mRight=0	
			gosub c_frente
			if b22=1 then
				gosub virarTras
			endif
		loop

		do while mLeft=1 and mCenter=1 and mRight=1
			gosub c_frente
			if b22=1 then
				gosub virarTras
			endif
		loop
		gosub c_frente
			if b22=1 then
				gosub virarTras
			endif
		return
		
		confirma_dois_verdes:
		m_11(25,25)
		pause 200
		serin d.4, n4800_4, b20,b21,b22,b23
		if b21=1 or b20=1 then
			high b.2
			gosub avancar_l_ret
			pause 150
			low b.2
		endif
		return

		c_frente:
		gosub avancar_l_ret
		pause 10
		high b.7, b.6, b.5, b.4
		pause 70
		serin d.4, n4800_4, b20,b21,b22,b23
		return

		voltar_pista:
		if verdee=2 then
			gosub rodar_direita2
		else
			gosub rodar_esquerda2
		endif
		pause 310
		goto Main
		
				
		recuar_l_ret:
		low b.7, b.5
		high b.6, b.4
		pwmout c.2,10,26
		pwmout c.1,10,26
		return
		
				
		avancar_l_ret:
		high b.7, b.5
		low b.6, b.4
		pwmout c.2,10,26
		pwmout c.1,10,26
		return
		
		rodar_esquerda:
		low b.7, b.4
		high b.6, b.5
		pwmout c.2,10,35
		pwmout c.1,10,35 
		return

		rodar_direita:
		high b.7, b.4
		low b.6, b.5
		pwmout c.2,10,35
		pwmout c.1,10,35
		return
		
		rodar_esquerda3:
		low b.7, b.4
		high b.6, b.5
		pwmout c.2,10,35
		pwmout c.1,10,27 
		return

		rodar_direita3:
		high b.7, b.4
		low b.6, b.5
		pwmout c.2,10,27
		pwmout c.1,10,35
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
#ENDREGION

#REGION Evacuation-Zone

	EvacuationZone:
		RUN 1
		goto main
#ENDREGION