SYMBOL BackSwitch = pinA.0
SYMBOL ConfigButton = pinA.1
SYMBOL LeftWall = pinA.2
SYMBOL ObsSensor = pinA.3
SYMBOL RightWall = pinA.5
SYMBOL LeftPlatformSwitch = pinA.6
SYMBOL RightPlatformSwitch = pinA.7

SYMBOL Right_Sonar = B.0
SYMBOL Left_Sonar = B.1
SYMBOL YellowLED = B.2
SYMBOL Ball_Gate = pinB.3
SYMBOL Right_Motor_1 = B.4
SYMBOL Right_Motor_2 = B.5
SYMBOL Left_Motor_1 = B.6
SYMBOL Left_Motor_2 = B.7

SYMBOL PWM_Left = C.1
SYMBOL PWM_Right = C.2
SYMBOL ClawLifter = C.5
SYMBOL ClawGraber = C.6
SYMBOL SilverTape = pinC.7

SYMBOL mFront = pinD.1
SYMBOL eRight = pinD.2
SYMBOL eLeft = pinD.3
SYMBOL mLeft = pinD.5
SYMBOL mCenter = pinD.6
SYMBOL mRight = pinD.7

SYMBOL LeftSonar = w0
SYMBOL RightSonar = w1

GetSonarEsq:
	LOW Left_Sonar
	PULSOUT Left_Sonar, 1
	PULSIN Left_Sonar, 1, LeftSonar
return

GetSonarDir:
	LOW Right_Sonar
	PULSOUT Right_Sonar, 1
	PULSIN Right_Sonar, 1, RightSonar
return