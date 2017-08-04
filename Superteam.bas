#DEFINE LineFollowing

goto inicio
#INCLUDE "Settings.bas"


#REGION Main-Loop

	Main:	
	
	if whitee=0 then
		line=1
		noline=0
	elseif whitee=1 then
		line=0
		noline=1
		
		if eLeft=line and eRight=line then
			high b.2
			m_00(0,0)
			pause 200
			m_11(27,27)
			pause 50
			low b.2
			whitee=2
			goto Main
		endif
	elseif whitee=2 then
		line=1
		noline=0
		if mLeft=line and mCenter=line and mRight=line and countt=0 then
			gosub Green
		endif
	elseif whitee=3 then
		serin d.4, n4800_4, b20,b21,b22,b23
		if b23=1 then
			m_11(30,30)
			pause 100
			if mLeft=noline and mCenter=noline and mRight=noline then 
				goto Connection
			else
				gosub recuar_ret
				pause 100
				goto Main
			endif
		endif
	endif
	goto FollowLine
	
#ENDREGION

#REGION Black1

	FollowLine:
	if mCenter=noline and whitee=0 then
		if eLeft=line and eRight=line then 
			if mRight=line or mLeft=line then goto White
		elseif eLeft=line and mRight=line then goto White
		elseif eRight=line and mLeft=line then goto White
		endif
	endif
	
	if mLeft=noline and mCenter=line and mRight=noline then Front
	if mLeft=noline and mCenter=noline and mRight=line then Right
	if mLeft=line and mCenter=noline and mRight=noline then Left
	if mLeft=noline and mCenter=line and mRight=line then Right_1
	if mLeft=line and mCenter=line and mRight=noline then Left_1
	if whitee!=1 then
		if mLeft=noline and mCenter=noline and mRight=noline then Gap
	endif
	goto Main
	
	Front:
	if eLeft=line and eRight=noline then RotateLeftFast
	if eLeft=noline and eRight=line then RotateRightFast
	if eLeft=noline and eRight=noline then MoveForward
	goto Main

	Left:
		if eLeft=line then RotateLeftFast
		if eLeft=noline then RotateLeft
		goto Main

	Right:
		if eRight=line then RotateRightFast
		if eRight=noline then RotateRight
		goto Main

	Left_1:
		if eLeft=noline then RotateLeft
		if eLeft=line then RotateLeftFast
		goto Main

	Right_1:
		if eRight=noline then RotateRight
		if eRight=line then RotateRightFast
		goto Main
		
	Gap:
	if mLeft=line or mCenter=line or mRight=line or eLeft=line or eRight=line then Main
	m_22(30,30)
	for w0=1 to pause_back
		if eLeft=line then
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
		elseif eRight=line then
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
	
	m_00(0,0)
	pause 200
	if mCenter=noline and mLeft=noline and mRight=noline then
		do while mCenter=noline and mLeft=noline and mRight=noline
			m_11(40,40)
		loop
	endif
	do while mCenter=line or mLeft=line or mRight=line or eLeft=line or eRight=line
		if mLeft=line or eLeft = line then
			m_01(50,50)
		elseif mRight=line or eRight = line then
			m_10(50,50)
		else
			m_11(40,40)
		endif
	loop
	
	do while mCenter=noline and mLeft=noline and mRight=noline and eLeft=noline and eRight=noline
		m_11(40,40)
	loop
	m_00(0,0)
	pause 200
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

	MoveForward:
		m_11(40, 40)
		goto Main

	RotateLeft:
		m_21(24, 40)
		goto Main

	RotateRight:
		m_12(40, 24)
		goto Main
		
	RotateLeftFast:
		m_21(40, 40)
		goto Main

	RotateRightFast:
		m_12(40, 40)
		goto Main
		
#ENDREGION


#REGION White

	White:
	if whitee=0 then
		high b.2
		m_00(0,0)
		pause 200
		low b.2
		whitee=1
		m_11(35,35)
		pause 300
	endif
	Goto Main
	

#ENDREGION

#REGION Green
	Green:
	high b.7, b.6, b.5, b.4
	pause 200
	
	gosub recuar_l_ret
	pause 150

	high b.7, b.6, b.5, b.4
	pause 200
	
	do while mLeft=0 or mCenter=0 or mRight=0	
		gosub count_green
	loop

	do while mLeft=1 and mCenter=1 and mRight=1
		gosub count_green
	loop
	
	m_11(25,25)
	pause 40

	m_00(0,0)
	pause 100
	
	green_right=0
	green_left=0
	
	for b0=0 to 18
		gosub count_green
	next b0
	
	m_00(0,0)
	pause 100
	
	if countt>3 then
		countt=0
		green_right=0
		green_left=0
		gosub recuar_ret
		pause 750
		goto Main 
	endif

	m_11(25,25)
	pause 150
	
	for b0=1 to countt
	servo 3, 90
	pause 250
	servo 3, 250
	pause 250
	next b0

	low b.3
	
	whitee=3
	
	goto Main

	c_frente:
	gosub avancar_l_ret
	pause 10
	high b.7, b.6, b.5, b.4
	pause 70
	serin d.4, n4800_4, b20,b21,b22,b23
	return
	
	count_green:
	gosub c_frente
	if b20=1 and green_left=0 then
		green_left=1
		countt=countt+1
	endif
	if b21=1 and green_right=0 then
		green_right=1
		countt=countt+1
	endif
	if b22=1 then
		if green_left=0 and green_right=0 then
			green_right=1
			green_left=1
			countt=countt+2
		elseif green_left=1 and green_right=0 then
			green_right=1
			countt=countt+1
		elseif green_left=0 and green_right=1 then
			green_left=1
			countt=countt+1
		endif
	endif		
	return
	
	recuar_l_ret:
	low b.7, b.5
	high b.6, b.4
	pwmout c.2,10,26
	pwmout c.1,10,26
	return
	
	recuar_ret:
	low b.7, b.5
	high b.6, b.4
	pwmout c.2,10,30
	pwmout c.1,10,30
	return
		
	avancar_l_ret:
	high b.7, b.5
	low b.6, b.4
	pwmout c.2,10,26
	pwmout c.1,10,26
	return
	
	avancar_ret:
	high b.7, b.5
	low b.6, b.4
	pwmout c.2,10,30
	pwmout c.1,10,30
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
	
		
#ENDREGION

#REGION Connection

	Connection:
	high b.2
	m_00(0,0)
	pause 200
	low b.2
	
	gosub recuar_esq
	pause pause_rec
	
	m_00(0,0)
	pause 200
	
	if countt=0 then
		countt=3
	endif



	for b0=1 to countt
		gosub avancar_ret
		do while ObsSensor=0
		loop
		pause 50
		
		m_00(0,0)
		pause 100
	
		gosub recuar_ret
		pause 250
		
		m_00(0,0)
		pause 300
		
	next b0
	
	end

#ENDREGION