#PICAXE 40x2
#NO_TABLE
#NO_DATA

#IFDEF LineFollowing
	#SLOT 0
	SETFREQ M16
#ELSE
	#SLOT 1
#ENDIF

GOTO Start

#INCLUDE "Macros.bas"
#INCLUDE "Setup.bas"

SYMBOL SpeedSLOW = 24
SYMBOL SpeedAVG = 30
SYMBOL SpeedFAST = 50