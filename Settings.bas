#PICAXE 40x2
#NO_TABLE
#NO_DATA
#INCLUDE "Setup.bas"
#IFDEF LineFollowing
	#SLOT 0
	;SETFREQ M16
#ELSE
	#SLOT 1
#ENDIF

inicio:
pause_back=200
pause_rec=50

if ConfigButton=1 then
	pause_rec=0
endif

for w0=0 to 500
	if BackSwitch=1 then
		pause_back=160
		pause_rec=0
	endif
next w0

goto Main

#INCLUDE "Macros.bas"


SYMBOL SpeedSLOW = 27
SYMBOL SpeedAVG = 40
SYMBOL SpeedFAST = 50