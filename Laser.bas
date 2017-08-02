'
'************************************************* ***********************
' INITIALISATION
'************************************************* ***********************
setup:
'Set up I2C bus
hi2csetup i2cmaster,%01010010,i2cfast,i2cword 'slave address 52 Hex

Address_16 = 0x16 'Reset status byte register address
GoSub Read_I2C 'Returns contents of register Address_16 in Data_Byte

GoSub Init_I2C 'Load the required register settings

'Now confirm initialisation has taken place
Address_16 = 0x16 'Reset status byte register address
GoSub Read_I2C 'Returns contents of register Address_16 in Data_Byte
If Data_Byte <> 0 Then 'Check fresh out of reset status = 0
	high b.2
	gosub setup
do 
	loop while b1=b1 ' Freeze on error message
End If
low b.2
return

#MACRO GetLaser()
	high d.0
	high c.7
	GoSub Single_Shot_Read 
#ENDMACRO

'************************************************* ***********************
' SUBROUTINES
'************************************************* ***********************
' Enter with target register as Address_16 
' Return with data from register in Data_Byte 
Read_I2C: 
hi2cin Address_16,(Data_Byte)
Return 
' ************************************************** *********************
'Enter with target register as Address_16 and data to write in Data_Byte
Write_I2C: 
hi2cout Address_16,(Data_Byte)
;pause 5 ' Allow time for allocation of byte
Return 
' ************************************************** *********************
'Perform a single-shot read on the VL6180X 
'Return with reading in Distance_mm
Single_Shot_Read: 
Address_16 = 0x4d ' Check device is ready (Bit0 set)
'
Wait_Ready_Read:
GoSub Read_I2C
If bit8 = 0 then Wait_Ready_Read ' Wait for device to become ready
' 
Address_16 = 0x0018
Data_Byte = 0x01 ' Start a range measurement
GoSub Write_I2C 
Address_16 = 0x4f ' Check measurement complete(Bit2 set)
'
Wait_Sample_Ready:
GoSub Read_I2C
If bit10 = 0 Then Wait_Sample_Ready ' Wait for measurement to be completed 
'
Address_16 = 0x62 ' Read the range into Data_Byte
GoSub Read_I2C
'
Distance_mm = Data_Byte ' Save the measured distance in mm 
Address_16 = 0x15 
Data_Byte = 0x07 ' Clear the interrupt status
GoSub Write_I2C 
Return ' Return with reading in Distance_mm
'************************************************* ***********************
' Load the required settings onto the VL6180X
Init_I2C: 
' Mandatory register settings
Address_16 = 0x0207
Data_Byte = 0x01
GoSub Write_I2C
Address_16 = 0x0208
Data_Byte = 0x01
GoSub Write_I2C
Address_16 = 0x0096
Data_Byte = 0x00
GoSub Write_I2C
Address_16 = 0x0097
Data_Byte = 0xfd
GoSub Write_I2C
Address_16 = 0x00e3
Data_Byte = 0x00
GoSub Write_I2C
Address_16 = 0x00e4
Data_Byte = 0x04
GoSub Write_I2C
Address_16 = 0x00e5
Data_Byte = 0x02
GoSub Write_I2C
Address_16 = 0x00e6
Data_Byte = 0x01
GoSub Write_I2C
Address_16 = 0x00e7
Data_Byte = 0x03
GoSub Write_I2C
Address_16 = 0x00f5
Data_Byte = 0x02
GoSub Write_I2C
Address_16 = 0x00d9
Data_Byte = 0x05
GoSub Write_I2C
Address_16 = 0x00db
Data_Byte = 0xce
GoSub Write_I2C
Address_16 = 0x00dc
Data_Byte = 0x03
GoSub Write_I2C
Address_16 = 0x00dd
Data_Byte = 0xf8
GoSub Write_I2C
Address_16 = 0x009f
Data_Byte = 0x00
GoSub Write_I2C
Address_16 = 0x00a3
Data_Byte = 0x3c
GoSub Write_I2C
Address_16 = 0x00b7
Data_Byte = 0x00
GoSub Write_I2C
Address_16 = 0x00bb
Data_Byte = 0x3c
GoSub Write_I2C
Address_16 = 0x00b2
Data_Byte = 0x09
GoSub Write_I2C
Address_16 = 0x00ca
Data_Byte = 0x09
GoSub Write_I2C
Address_16 = 0x0198
Data_Byte = 0x01
GoSub Write_I2C
Address_16 = 0x01b0
Data_Byte = 0x17
GoSub Write_I2C
Address_16 = 0x01ad
Data_Byte = 0x00
GoSub Write_I2C
Address_16 = 0x00ff
Data_Byte = 0x05
GoSub Write_I2C
Address_16 = 0x0100
Data_Byte = 0x05
GoSub Write_I2C
Address_16 = 0x0199
Data_Byte = 0x05
GoSub Write_I2C
Address_16 = 0x01a6
Data_Byte = 0x1b
GoSub Write_I2C
Address_16 = 0x01ac
Data_Byte = 0x3e
GoSub Write_I2C
Address_16 = 0x01a7
Data_Byte = 0x1f
GoSub Write_I2C
Address_16 = 0x0030
Data_Byte = 0x00
GoSub Write_I2C
'
' Recommended register settings
Address_16 = 0x0011
Data_Byte = 0x10 ' Enables polling for new sample ready
GoSub Write_I2C
Address_16 = 0x010a
Data_Byte = 0x30 ' Set the average sample period
GoSub Write_I2C
Address_16 = 0x003f
Data_Byte = 0x46 ' Sets the light/dark gain upper nibble
GoSub Write_I2C
Address_16 = 0x0031
Data_Byte = 0xff ' Sets no of measurements for calibration
GoSub Write_I2C
Address_16 = 0x0040
Data_Byte = 0x63 ' Set ALS integration time to 100ms
GoSub Write_I2C
Address_16 = 0x002e
Data_Byte = 0x01 ' Perform single temperature calibration
GoSub Write_I2C
'
' Optional register settings
Address_16 = 0x001b
Data_Byte = 0x09 ' Set inter-measurement period to 100ms
GoSub Write_I2C
Address_16 = 0x003e
Data_Byte = 0x31 ' Set ALS inter-measurement period to 500ms
GoSub Write_I2C 
Address_16 = 0x0014
Data_Byte = 0x24 ' Config interrupt on new sample ready event
GoSub Write_I2C
' Indicate settings have been loaded
Address_16 = 0x16
Data_Byte = 0x00 ' Write 0 to Reset status byte register
GoSub Write_I2C 
Return