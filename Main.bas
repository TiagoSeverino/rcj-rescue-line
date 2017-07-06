#DEFINE LineFollowing

#INCLUDE "Settings.bas"

#REGION Start

	Start:
		if LeftWall=0 and RightWall=0 then Start
		if RightWall=1 then EvacuationZone
		goto Main
#ENDREGION

#REGION Main-Loop

	Main:
		if SilverTape=0 then EvacuationZone
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
		if mLeft=0 and mCenter=0 and mRight=0 then Gap
		if mLeft=1 and mCenter=0 and mRight=1 then 
			if eLeft = 1 then RotateLeftFast
			if eRight = 1 then RotateRightFast
		endif
		goto Main

	Front:
		if mFront=1 then MoveForward
		if eLeft=1 and eRight=1 then MoveForward
		if eLeft=1 and eRight=0 then RotateLeftFast
		if eLeft=0 and eRight=1 then RotateRightFast
		if eLeft=0 and eRight=0 then MoveForward
		goto Main

	Intersection:
		if mFront=1 then MoveForward
		if eLeft=1 and eRight=1 then MoveForward
		if eLeft=1 and eRight=0 then RotateLeftFast
		if eLeft=0 and eRight=1 then RotateRightFast
		if eLeft=0 and eRight=0 then MoveForward
		goto Main
		
	Gap:
		if eLeft=1 then RotateLeftFast
		if eRight=1 then RotateRightFast
		goto Main

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
		if mFront=1 then MoveForward
		if eLeft=1 then RotateLeftFast
		goto Main

	Right_1:
		if eRight=0 then RotateRight
		if mFront=1 then MoveForward
		if eRight=1 then RotateRightFast
		goto Main

	MoveForward:  
		m_11(SpeedSLOW, SpeedSLOW)
		goto Main

	RotateLeft:
		m_21(SpeedSLOW, SpeedSLOW)
		goto Main

	RotateRight:
		m_12(SpeedSLOW, SpeedSLOW)
		goto Main

	RotateLeftFast:
		m_21(SpeedSLOW, SpeedSLOW)
		goto Main

	RotateRightFast:
		m_12(SpeedSLOW, SpeedSLOW)
		goto Main
#ENDREGION

#REGION Obstacle

	Obstacle:
		m_11(SpeedFAST, SpeedFAST)
		PAUSE 1000
		m_22(SpeedAVG, SpeedAVG)
		PAUSE 1000
		goto Main
#ENDREGION

#REGION Evacuation-Zone

	EvacuationZone:
		RUN 1
		goto main
#ENDREGION