
inicio:
if pin4=0 and pin3=0 then pinca_fecha_elev_cima
if pin4=1 and pin3=0 then pinca_aberta_elev_medio
if pin4=0 and pin3=1 then agarrar_objecto
'if pin4=1 and pin3=1 then largar_objecto
goto inicio

inicio_2:
if pin4=0 and pin3=0 then pinca_fecha_elev_cima
if pin4=0 and pin3=1 then pinca_fecha_elev_cima_objec_2
if pin4=1 and pin3=1 then largar_objecto
goto inicio_2

inicio_3:
if pin4=0 and pin3=0 then pinca_fecha_elev_cima
'if pin4=1 and pin3=0 then 
'if pin4=0 and pin3=1 then 
if pin4=1 and pin3=1 then pinca_aberta_elev_medio_3
goto inicio_3



agarrar_objecto:
gosub elev_baixo_pinca_aberta
pause 300
gosub pinca_fechada
pause 500
gosub pinca_fecha_elev_cima_objec
pause 1000
goto inicio_2

largar_objecto:
gosub pinca_fecha_elev_baix_objec
pause 1000'1000
gosub pinca_aberta
pause 1000
goto inicio_3



'goto inicio
pinca_fecha_elev_cima:
servo 0,98' 'pinça fechada
pause 10
servo 1,70  'elevador cima
pause 10
goto inicio

pinca_aberta_elev_medio:
servo 0,38 'pinça aberta
pause 10
servo 1,120  'elevador a meio
pause 10
goto inicio


pinca_fecha_elev_cima_objec_2:
servo 0,98' 'pinça fechada
pause 10
servo 1,70  'elevador cima
pause 10
goto inicio_2

pinca_fecha_elev_baix_objec_3:
servo 0,40 'pinça aberta
pause 10
servo 1,120  'elevador a meio
pause 10
goto inicio_3

pinca_aberta_elev_medio_3:
servo 0,38 'pinça aberta
pause 10
servo 1,120  'elevador a meio
pause 10
goto inicio_3



'return
pinca_aberta:  
servo 0,40' pinça aberta
return

pinca_fechada:
servo 0,98'pinça fechada
return

elev_baixo_pinca_aberta:
servo 1,155'elevador baixo   
servo 0,40' pinça aberta
return

pinca_fecha_elev_cima_objec:
servo 0,98'pinça fechada'''''''
servo 1,90  'elevador cima
return

pinca_fecha_elev_baix_objec:
servo 0,82'98''pinça fechada ----abre ligeiramente para a lata descair
servo 1,120  'elevador a meio
return

