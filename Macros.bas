#MACRO Speed(SpeedLeft, SpeedRight)
	pwmout PWM_Left, 10, SpeedLeft
	pwmout PWM_Right, 10, SpeedRight
#ENDMACRO

#MACRO MotorLeftStop
	low Left_Motor_1
	low Left_Motor_2
#ENDMACRO

#MACRO MotorLeftForward
	low Left_Motor_1
	high Left_Motor_2
#ENDMACRO

#MACRO MotorLeftBackward
	high Left_Motor_1
	low Left_Motor_2
#ENDMACRO

#MACRO MotorLeftBreak
	high Left_Motor_1
	high Left_Motor_2
#ENDMACRO

#MACRO MotorRightStop
	low Right_Motor_1
	low Right_Motor_2
#ENDMACRO

#MACRO MotorRightForward
	low Right_Motor_1
	high Right_Motor_2
#ENDMACRO

#MACRO MotorRightBackward
	high Right_Motor_1
	low Right_Motor_2
#ENDMACRO

#MACRO MotorRightBreak
	high Right_Motor_1
	high Right_Motor_2
#ENDMACRO

#MACRO m_00(SpeedLeft, SpeedRight)
	MotorLeftStop
	MotorRightStop
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_01(SpeedLeft, SpeedRight)
	MotorLeftStop
	MotorRightForward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_02(SpeedLeft, SpeedRight)
	MotorLeftStop
	MotorRightBackward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_03(SpeedLeft, SpeedRight)
	MotorLeftStop
	MotorRightBreak
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_10(SpeedLeft, SpeedRight)
	MotorLeftForward
	MotorRightStop
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_11(SpeedLeft, SpeedRight)
	MotorLeftForward
	MotorRightForward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_12(SpeedLeft, SpeedRight)
	MotorLeftForward
	MotorRightBackward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_13(SpeedLeft, SpeedRight)
	MotorLeftForward
	MotorRightBreak
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_20(SpeedLeft, SpeedRight)
	MotorLeftBackward
	MotorRightStop
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_21(SpeedLeft, SpeedRight)
	MotorLeftBackward
	MotorRightForward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_22(SpeedLeft, SpeedRight)
	MotorLeftBackward
	MotorRightBackward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_23(SpeedLeft, SpeedRight)
	MotorLeftBackward
	MotorRightBreak
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_30(SpeedLeft, SpeedRight)
	MotorLeftBreak
	MotorRightStop
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_31(SpeedLeft, SpeedRight)
	MotorLeftBreak
	MotorRightForward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_32(SpeedLeft, SpeedRight)
	MotorLeftBreak
	MotorRightBackward
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO

#MACRO m_33(SpeedLeft, SpeedRight)
	MotorLeftBreak
	MotorRighBreak
	Speed(SpeedLeft, SpeedRight)
#ENDMACRO