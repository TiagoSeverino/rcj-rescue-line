symbol flag=b0
'w5 utiliza as b11 e b10
'b1 é o contador da subida
symbol esq_obs=pina.2'input2
symbol dir_obs=pina.3'input3                      
symbol amarelo=pina.1'led amarelo da subida



iniciar:
if pinc.7=0 then inicio         'botão deligado
if pinc.7=1 then acerto_agulha  'botão ligado
goto iniciar


acerto_agulha:
i2cslave $C0,i2cfast,i2cbyte	' Define i2c slave address for the CMPS03
readi2c 0,(b1)		' ler CMPS03 Software Revision
readi2c 1,(b5)
'if b5>0 then desliga_led_verde
'if b5<1 then liga_led_verde
if b5<121 then desliga_led_amarelo
if b5>120  and b5<134 then liga_led_amarelo
if b5>133 then desliga_led_amarelo
goto iniciar

liga_led_amarelo:
high b.2
goto iniciar

desliga_led_amarelo:
low b.2
goto iniciar


'#####################################################################################################################
'#####################################################################################################################

'pind.0  verde


inicio:
if pind.4=0 then seguir   'verificar se tem prateado(LDR)'
if pind.4=1 then prateado 
goto inicio


prateado:
high b.2       'Led amarelo (sala de evacuação)
goto seguir


verifica1:
if pind.0=1 then esquerda_r
if pind.0=0 then direita_r
goto inicio

verifica_esquerda:
if pind.0=1 then esquerda_r
if pind.0=0 then verifica_frente_esq  
goto inicio

verifica_frente_esq:
gosub c_avancar
pause 250
goto verifica3

verifica3:
if pind.7=0 and pind.6=0 and pind.5=0 then vira_esquerda
if pind.7=1 and pind.6=0 and pind.5=0 then seguir
if pind.7=0 and pind.6=1 and pind.5=0 then seguir
if pind.7=0 and pind.6=0 and pind.5=1 then seguir
if pind.7=1 and pind.6=1 and pind.5=0 then seguir
if pind.7=0 and pind.6=1 and pind.5=1 then seguir
goto inicio


verifica_direita:
if pind.0=1 then verifica_frente_dir
if pind.0=0 then direita_r    
goto inicio

verifica_frente_dir:
gosub c_avancar
pause 250
goto verifica4

verifica4:
if pind.7=0 and pind.6=0 and pind.5=0 then vira_direita
if pind.7=1 and pind.6=0 and pind.5=0 then seguir
if pind.7=0 and pind.6=1 and pind.5=0 then seguir
if pind.7=0 and pind.6=0 and pind.5=1 then seguir
if pind.7=1 and pind.6=1 and pind.5=0 then seguir
if pind.7=0 and pind.6=1 and pind.5=1 then seguir
goto inicio

vira_direita:
gosub c_direita_r
pause 400
goto inicio

vira_esquerda:
gosub c_esquerda_r
pause 400
goto inicio  

'******************************************** seguir a linha *********************************************************'
  
 'pista me           p-m          p-md          p-e          p-d       
livre: 
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then branco 
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=0 then direita 
if pind.7=0 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar   
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then direita          'direita_rr   
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then esquerda 
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then esquerda         'esquerda_rr
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=1 then direita_r        'direita_rr
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=1 then direita_rr        'direita_r
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then verifica_direita  'direita_r    'direita_r
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then esquerda_r        'esquerda_rr
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=1 and pind.2=0 then verifica_esquerda 'esquerda_r   'esquerda_r
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then esquerda_rr

if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then preto  
'if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then parar    
'if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=0 then parar
'if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=1 then parar


if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=1 then verifica1 
'if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=0 then verifica1 
'if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then verifica1  
goto inicio





branco:
if pinc.0=0 and pind.1=0 then branco1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas  'ultrasom
goto inicio

branco1:
if flag=0 then avancar'aa_avancar
if flag=1 then avancar'aa_avancar
if flag=2 then avancar'aa_avancar
if flag=3 then esquerda_rr
if flag=4 then direita_rr
if flag=5 then esquerda_rr
if flag=6 then direita_rr
if flag=10 then avancar
goto inicio


preto:
if pinc.0=0 and pind.1=0 then preto1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas  'ultrasom
goto inicio

preto1:
if flag=0 then avancar_lento
if flag=3 then esquerda_rr
if flag=4 then direita_rr
if flag=1 then esquerda
if flag=2 then direita
if flag=5 then esquerda_rr
if flag=6 then direita_rr
goto inicio


'*********************************************************************************************************************


avancar:
if pinc.0=0 and pind.1=0 then avancar1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas 'ultrason
goto inicio

avancar1:
let b1=0      
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,19'23      
pwmout c.1,10,19'23    
flag=0
goto inicio

lombas:      
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,28      
pwmout c.1,10,28
pause 300      
goto inicio



esquerda:
if pinc.0=0 and pind.1=0 then esquerda1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas 'ultrasom
goto inicio

esquerda1:
low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,35
pwmout c.1,10,35
flag=1
goto inicio

direita:
if pinc.0=0 and pind.1=0 then direita1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas 'ultrasom
goto inicio

direita1:
high b.7
low b.6
low b.5
low b.4
pwmout c.2,10,35
pwmout c.1,10,35
flag=2
goto inicio


'********************************************************************************************************************
'parar:
'if pinc.0=0 and pind.1=0 then parar1
'if pinc.0=0 and pind.1=1 then lombas
'if pinc.0=1 and pind.1=0 then ultrasom
'if pinc.0=1 and pind.1=1 then lombas 'ultrasom
'goto inicio

'parar1:      
'low b.7
'low b.6
'low b.5
'low b.4
'pwmout c.2,10,00
'pwmout c.1,10,00
'pause 1000
'goto inicio

'*********************************************************************************************************************

esquerda_r:
if pinc.0=0 and pind.1=0 then esquerda_r1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas 'ultrasom
goto inicio

esquerda_r1: 
low b.7
high b.6
high b.5
low b.4
pwmout c.2,10,29 
pwmout c.1,10,29 
flag=5
goto inicio

direita_r:
if pinc.0=0 and pind.1=0 then direita_r1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas 'ultrasom
goto inicio

direita_r1: 
high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,29
pwmout c.1,10,29
flag=6
goto inicio

direita_rr:
if pinc.0=0 and pind.1=0 then direita_rr1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas 'ultrasom
goto inicio

direita_rr1: 
high b.7
low b.6
low b.5
low b.4
pwmout c.2,10,32
pwmout c.1,10,32
flag=4
goto inicio

esquerda_rr:
if pinc.0=0 and pind.1=0 then esquerda_rr1
if pinc.0=0 and pind.1=1 then lombas
if pinc.0=1 and pind.1=0 then ultrasom
if pinc.0=1 and pind.1=1 then lombas 'ultrasom
goto inicio

esquerda_rr1: 
low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,32
pwmout c.1,10,32
flag=3
goto inicio

'**********************   SUBIDA  ********  SUBIDA *************************
  
ultrasom:
if pind.0=1 then ultrasom_esquerda
if pind.0=0 then ultrasom_direita
goto inicio

ultrasom_esquerda:
low b.0         
PULSOUT b.0, 5                ' escreve na w1 leitura da parede direita
PULSIN b.0, 1, w5
if w5<111 then desv_esquerda
if w5>110 then desv_direita
goto inicio

ultrasom_direita:
low b.1
PULSOUT b.1, 5               'escreve na w1 leitura da parede esquerda
PULSIN b.1, 1, w5
if w5<111 then desv_direita
if w5>110 then desv_esquerda
goto inicio 


desv_esquerda:
let b1=b1+1
if b1>151 then desv_esquerda_ligar 'corrigir o valor do ligar na b1
if b1<150 then desv_esquerda_conta
goto inicio

desv_esquerda_conta: 
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,35'30
pwmout c.1,10,20'23
goto inicio

desv_esquerda_ligar:
'high b.2               'Led amarelo (liga parte de cima)
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,35'30
pwmout c.1,10,20'23
goto inicio

desv_direita:
let b1=b1+1
if b1>151 then desv_direita_ligar 'corrigir o valor do ligar na b1
if b1<150 then desv_direita_conta
goto inicio

desv_direita_conta: 
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,20'23
pwmout c.1,10,35'30
goto inicio

desv_direita_ligar: 
'high b.2                   'Led amarelo (liga parte de cima)   
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,20'23
pwmout c.1,10,35'30
goto inicio


avancar_lento: 
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,23
pwmout c.1,10,23
flag=10
goto inicio

'************************************  Detetar Obstáculos  *************************************************************'


seguir:

    'cima        esquerda       direita

if amarelo=0 and esq_obs=0 and dir_obs=0 then livre
if amarelo=1 and esq_obs=0 and dir_obs=0 then avancar_topo2'avan_cima
if amarelo=0 and esq_obs=0 and dir_obs=1 then desvio_esquerda_plano
if amarelo=0 and esq_obs=1 and dir_obs=0 then desvio_direita_plano
if amarelo=0 and esq_obs=1 and dir_obs=1 then recua_inicio
if amarelo=1 and esq_obs=0 and dir_obs=1 then desvio_esquerda_plano 'pode ser tirado
if amarelo=1 and esq_obs=1 and dir_obs=0 then desvio_direita_plano  'pode ser tirado
'if amarelo=1 and esq_obs=1 and dir_obs=1 then desvio_entrar_porta_cima
goto inicio


'avan_cima:
'if pinc.0=0 then avancar_topo1  '  está no cimo da rampa (em Santo Tirso passa a Livre
'if pinc.0=1 then ultrasom
'goto inicio


'#######################################################################################################################

'avancar_topo1:
'for b0= 1 to 256'250 'para ficar infinito até encontrar a parede
'gosub cima_avancar_topo_1   'Cimo da rampa     ' se controlar com "c_avancar" o valor é +/-60 max 255            
'pause 5
'next b0
'goto avancar_topo2
avancar_topo2:
low b.7
low b.6
low b.5
low b.4
pause 300
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)
let b25=b5-5'-7   'ESTE (-1) é acerto do compass para a pista
let b17=b25-2
let b18=b25-1
let b19=b25+1  'andar para a frente
let b20=b25+2
goto avancar_topo2_1

avancar_topo2_1:
if pind.0=0 then avancar_topo2_1_esquerda
if pind.0=1 then avancar_topo2_1_direita
goto inicio

avancar_topo2_1_direita:
for b0= 1 to 90           '???????importante acertar valor (MAX255) 
gosub c_avancar_topo_frente              
pause 5
next b0
gosub rodar_esquerda      'rodar com as duas rodas para ficar a 90Graus
pause 425
gosub recuar_return
pause 4000
goto carregar_valor

avancar_topo2_1_esquerda:
for b0= 1 to 90           '???????importante acertar valor (MAX255) 
gosub c_avancar_topo_frente              
pause 5
next b0
gosub rodar_direita      'rodar com as duas rodas para ficar a 90Graus
pause 425
gosub recuar_return
pause 4000
goto carregar_valor

carregar_valor:
if pind.0=0 then carregar_valor_esquerda
if pind.0=1 then carregar_valor_direita
goto inicio

carregar_valor_esquerda:
low b.2       '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<DESLIGA LED AMARELO
low b.7
low b.6
low b.5
low b.4
pause 100
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)

let b50=b5-5

let b21=b50-2
let b22=b50-1
let b23=b50+1   'andar para a esquerda a -90g
let b24=b50+2

let b27=b50-3'+4  ' no recuar

let b28=b27-2
let b29=b27-1
let b30=b27+1   'no recuar para a esquerda a -90g-3g
let b31=b27+2
goto inicio_2

carregar_valor_direita:
low b.2       '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<DESLIGA LED AMARELO
low b.7
low b.6
low b.5
low b.4
pause 100
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)

let b50=b5-5

let b21=b50-2
let b22=b50-1
let b23=b50+1   'andar para a esquerda a -90g
let b24=b50+2

let b27=b50+3'+4  ' no recuar

let b28=b27-2
let b29=b27-1
let b30=b27+1   'no recuar para a esquerda a -90g-3g
let b31=b27+2
goto inicio_2


'MUDA DE ESTADO para inicio2

c_avancar_topo_frente:     'ACERTAR VALORES ####  'ACERTAR VALORES #### 'ACERTAR VALORES ####          
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)
if b5< b18 then direita_topo_frente
if b5> b19 then esquerda_topo_frente
if b5> b17 and b5<b20 then c_avancar
'low b.0         
'PULSOUT b.0, 5                ' escreve na w1 leitura da parede direita
'PULSIN b.0, 1, w5
'if w5<100 then esquerda_topo
'if w5>100 then direita_topo
'low b.1
'PULSOUT b.1, 5               'escreve na w1 leitura da parede esquerda
'PULSIN b.1, 1, w5
'if w5<100 then direita_topo
'if w5>100 then esquerda_topo
return


esquerda_topo: 
low b.2
low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

direita_topo: 
low b.2
high b.7
low b.6
low b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

direita_topo_frente:
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,20'23
pwmout c.1,10,35'30
return

esquerda_topo_frente:
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,35'23
pwmout c.1,10,20'30
return



'################################################

desvio_direita_plano:       'desvia-se pela direita' 
low b.7
low b.6
low b.5
low b.4
low b.0         
PULSOUT b.0, 5                ' escreve na w5 leitura da parede direita
PULSIN b.0, 1, w5
if w5<151 then desvio_esquerda_plano 
if w5>150 then desvio_direita_plano1
goto inicio


desvio_direita_plano1:
gosub recuar_return
pause 50
gosub bb_direita_desv   'direita_desv       'rodar com duas rodas
pause 325
for b0= 1 to 50
gosub contorna_direita
next b0
for b0= 1 to 200
gosub pista_direita_avancar
next b0
for b0= 1 to 200
gosub pista_direita_avancar
next b0
for b0= 1 to 200
gosub pista_direita_avancar
next b0
goto inicio

contorna_direita:
low b.1
PULSOUT b.1, 5               'escreve na w5 leitura da parede esquerda
PULSIN b.1, 1, w5
if w5<76 then desv_direita_r
if w5>75 then desv_esquerda_r
goto inicio

desv_direita_r: 
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,1'23'30
pwmout c.1,10,38'35
return

desv_esquerda_r: 
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,38'35
pwmout c.1,10,1'23'30
return

bb_esquerda_desv: 
low b.7
high b.6            
high b.5
low b.4
pwmout c.2,10,33
pwmout c.1,10,33
return

bb_direita_desv: 
high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,33
pwmout c.1,10,33
return

'«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

desvio_esquerda_plano:        'desvio pela esquerda 
low b.7
low b.6
low b.5
low b.4
low b.1
PULSOUT b.1, 5               'escreve na w1 leitura da parede esquerda
PULSIN b.1, 1, w5
if w5<151 then desvio_direita_plano  
if w5>150 then desvio_esquerda_plano1
goto inicio


desvio_esquerda_plano1: 
gosub recuar_return
pause 50
gosub bb_esquerda_desv   'direita_desv       'rodar com duas rodas
pause 325
for b0= 1 to 50
gosub contorna_esquerda
next b0
for b0= 1 to 200
gosub pista_esquerda_avancar
next b0
for b0= 1 to 200
gosub pista_esquerda_avancar
next b0
for b0= 1 to 200
gosub pista_esquerda_avancar
next b0
goto inicio

contorna_esquerda:
low b.0         
PULSOUT b.0, 5                ' escreve na w5 leitura da parede direita
PULSIN b.0, 1, w5
if w5<76 then desv_esquerda_r
if w5>75 then desv_direita_r
goto inicio


'***********************************************************************************************************************

pista_direita_avancar:
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then contorna_direita 'c_avancar         
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=0 then c_direita
if pind.7=0 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then avancar   
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then c_esquerda
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar

if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=1 then c_direita  
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=1 then c_direita_r   
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then c_direita_r  
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then c_avancar
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=1 and pind.2=0 then c_esquerda_r
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then c_avancar

if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then c_direita_r
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then roda_tudo_direita
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=0 then roda_tudo_direita
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=1 then roda_tudo_direita
return

pista_esquerda_avancar:
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then contorna_esquerda'c_avancar        
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=0 then c_direita
if pind.7=0 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then avancar   
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=0 then c_esquerda
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=0 and pind.2=0 then avancar

if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=0 and pind.2=1 then c_avancar  
if pind.7=0 and pind.6=0 and pind.5=1 and pind.3=0 and pind.2=1 then c_avancar  
if pind.7=0 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then c_direita_r 
if pind.7=0 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then c_esquerda
if pind.7=1 and pind.6=1 and pind.5=0 and pind.3=1 and pind.2=0 then c_esquerda_r
if pind.7=1 and pind.6=0 and pind.5=0 and pind.3=1 and pind.2=0 then c_esquerda_r

if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=0 then c_esquerda_r
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=0 and pind.2=1 then roda_tudo_esquerda
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=0 then roda_tudo_esquerda
if pind.7=1 and pind.6=1 and pind.5=1 and pind.3=1 and pind.2=1 then roda_tudo_esquerda
return

'###############################################################

roda_tudo_direita:
gosub c_avancar
pause 60
gosub c_direita_r
pause 460
goto inicio

roda_tudo_esquerda:
gosub c_avancar
pause 80
gosub c_esquerda_r
pause 500
goto inicio

'******************


c_avancar:
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30'Acerto dos motores
return

c_avancar_lento:
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,25
pwmout c.1,10,25'Acerto dos motores
return

c_esquerda:
low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,35
pwmout c.1,10,35
return

c_direita:
high b.7
low b.6
low b.5
low b.4
pwmout c.2,10,35
pwmout c.1,10,35
return


c_esquerda_r:
low b.7
high b.6
high b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

c_direita_r:
high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

recua_inicio:     'recua com inicio'
low b.7
high b.6
low b.5
high b.4
pwmout c.2,10,32
pwmout c.1,10,32
goto inicio

recuar_return:        'recua com return
low b.7
high b.6
low b.5
high b.4
pwmout c.2,10,32
pwmout c.1,10,32
return


parar_return:      
low b.7
low b.6
low b.5
low b.4
pwmout c.2,10,00
pwmout c.1,10,00
return

rodar_esquerda:
low b.7
high b.6
high b.5
low b.4
pwmout c.2,10,29 
pwmout c.1,10,29 
return

rodar_direita:
high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,29
pwmout c.1,10,29
return


'********************************************************************************************************************
'*************************Continuação Software(Cáptura da Lata)******************************************************
'********************************************************************************************************************

inicio_2:
if esq_obs=0 and dir_obs=0 then c_avancar_procura
if esq_obs=0 and dir_obs=1 then direita_21   'encontrou a vitima
if esq_obs=1 and dir_obs=0 then esquerda_21    'encontrou a vitima
if esq_obs=1 and dir_obs=1 then questiona_lata 'encontrou
goto inicio_2

c_avancar_procura:
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)
if b5< b22 then direita_topo_2
if b5> b23 then esquerda_topo_2
if b5> b21 and b5<b24 then c_avancar_2
goto inicio_2 

esquerda_topo_2:
'low c.5  ' o alicate   (binário para picaxe 08)
'low c.6                    '(binário para picaxe 08)
low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
goto inicio_2

direita_topo_2:
'low c.5  ' alicate   (binário para picaxe 08)
'low c.6                    '(binário para picaxe 08)
high b.7
low b.6
low b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
goto inicio_2

esquerda_21:
low b.7
high b.6
high b.5
low b.4
pwmout c.2,10,20
pwmout c.1,10,20
goto inicio_2

direita_21:
high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,20
pwmout c.1,10,20
goto inicio_2

c_avancar_2:
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,28
pwmout c.1,10,30'Acerto dos motores
goto inicio_2


esquerda_2:
low c.5'high c.5  'abre o alicate    (binário para picaxe 08)
low c.6                     '(binário para picaxe 08)

low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,35
pwmout c.1,10,35
goto inicio_2

direita_2:
low c.5'high c.5  'abre o alicate   (binário para picaxe 08)
low c.6                    '(binário para picaxe 08)

high b.7
low b.6
low b.5
low b.4
pwmout c.2,10,35
pwmout c.1,10,35
goto inicio_2


questiona_lata:
for b0=1 to 30
gosub questiona_lata_1
next b0
goto recuar_no_procura

questiona_lata_1:
if pina.0=1 then avanc_lento
if pina.0=0 then segura_lata   'valor 0 quando é a lata
goto inicio_2


segura_lata:
gosub parar_return
pause 200
gosub segura_lata_1
gosub pergunta_led_amarelo_2       '<<<<<<<<<<<<<<PEGGUNTA SE ENCONTROU A PLATAFORMA
goto inicio_3      'TRANSPORTA A VITIMA 


pergunta_led_amarelo_2:
if amarelo=0 then inicio_3              'RECUA COM A VITIMA
if amarelo=1 then transport_viti_lado   'RECUA DE LADO COM A VITIMA
return
        
segura_lata_1:
low b.7
low b.6
low b.5
low b.4
low c.5   'alicate fechado e levanta vitima          (binário para picaxe 08)  
high c.6                                            '(binário para picaxe 08)
pause 2000 '2segundos parado para agarrar a vitima
return

avanc_lento:
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,15
pwmout c.1,10,15'Acerto dos motores
return

transport_viti_lado:        'RECUA DE LADO COM A VITIMA
for b0= 1 to 250
gosub c_recuar_topo_lado
next b0
for b0= 1 to 200
gosub c_recuar_topo_lado
next b0
goto inicio_3


recuar_no_procura:
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 150          '?????ACERTAR ESTA
gosub c_recuar_topo
next b0
gosub c_avancar
pause 200
gosub virar
pause 100'500
for b0= 1 to 110 '150        
gosub c_avancar_proc_parede 'fazer o L
next b0
gosub pergunta_led_amarelo       '<<<<<<<<<<<<<<PEGGUNTA SE ESTÀ NA PLATAFORMA
goto inicio_2

virar:
if pind.0=0 then c_esquerda_r2
if pind.0=1 then c_direita_r2
return

c_esquerda_r2:
low b.7
high b.6
high b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

c_direita_r2:
high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

pergunta_led_amarelo:
if amarelo=0 then inicio_2
if amarelo=1 then c_avancar_proc_parede_2
goto inicio_2

c_avancar_proc_parede_2:
for b0= 1 to 60        
gosub c_avancar_proc_parede 'fazer o L
next b0
goto inicio_2


c_recuar_topo:
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)
if b5< b29 then direita_topo_recuar
if b5> b30 then esquerda_topo_recuar
if b5> b28 and b5<b31 then topo_recuar
return

c_recuar_topo_lado:        'RECUA COM VALORES DA ENTRADA
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)
if b5< b18 then direita_topo_recuar
if b5> b19 then esquerda_topo_recuar
if b5> b17 and b5<b20 then topo_recuar
return


direita_topo_recuar:
low b.7
low b.6
low b.5
high b.4
pwmout c.2,10,25
pwmout c.1,10,25
return

esquerda_topo_recuar:             
low b.7
high b.6
low b.5
low b.4
pwmout c.2,10,25
pwmout c.1,10,25
return

topo_recuar: 
low b.7
high b.6
low b.5
high b.4
pwmout c.2,10,27
pwmout c.1,10,27
return

c_avancar_proc_parede:
if esq_obs=0 and dir_obs=0 then avancar_proc_parede_2
if esq_obs=0 and dir_obs=1 then direita_2   'encontrou a vitima
if esq_obs=1 and dir_obs=0 then esquerda_2    'encontrou a vitima
if esq_obs=1 and dir_obs=1 then questiona_lata 'encontrou
return

avancar_proc_parede_2:
if pind.0=0 then avancar_proc_parede_2_esquerda
if pind.0=1 then avancar_proc_parede_2_direita
return

avancar_proc_parede_2_direita:
low b.0         
PULSOUT b.0, 5                ' escreve na w5 leitura da parede direita
PULSIN b.0, 1, w5
if w5<100 then desv_esquerda_2
if w5>100 then desv_direita_2
return

avancar_proc_parede_2_esquerda:
low b.1
PULSOUT b.1, 5               'escreve na w5 leitura da parede esquerda
PULSIN b.1, 1, w5
if w5<100 then desv_direita_2
if w5>100 then desv_esquerda_2
return


desv_esquerda_2:     '<<<<<<<<<<<<<<<<<<<<<VERIFICA NA AGULHA SE È A PLATAFORMA
i2cslave $C0,i2cfast,i2cbyte	' 
readi2c 0,(b6)		' 
readi2c 1,(b5)
let b16=b25-30    '<<<<<<<<<<<<<<<<<<<<<<<<<<<RETIRA VALOR AO VALOR DA ENTRADA
if b5<b16 then desv_esquerda_2_2
if b5>b16 then desv_esquerda_2_1
return

desv_esquerda_2_1:
'low c.5  ' o alicate   (binário para picaxe 08)
'low c.6               '(binário para picaxe 08)
low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

desv_esquerda_2_2:
high b.2   '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<LIGA LED AMARELO
'low c.5  ' o alicate   (binário para picaxe 08)
'low c.6               '(binário para picaxe 08)
low b.7
low b.6
high b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
return

desv_direita_2:
'low c.5  ' alicate   (binário para picaxe 08)
'low c.6             '(binário para picaxe 08)
high b.7
low b.6
low b.5
low b.4
pwmout c.2,10,30
pwmout c.1,10,30
return



 'TRANSPORTA A VITIMA ****************

inicio_3:         'VAI PARA A PAREDE
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
for b0= 1 to 250
gosub c_recuar_topo
next b0
gosub c_avancar  'desencosta da parede
pause 200
gosub virar 'rodar_direita  (rodar com as duas rodas)
pause 460
goto inicio_4  'ACERTAR AQUI QUANTAS VEZES TEM DE RODAR ??????**************************************
               ' ACERTAR SE VAI PARA INICIO_4/5 ou directo para o INICIO_6
'ACERTAR AQUI QUANTAS VEZES TEM DE RODAR ??????#####################################
'ACERTAR AQUI QUANTAS VEZES TEM DE RODAR ??????######################################
'ACERTAR AQUI QUANTAS VEZES TEM DE RODAR ??????######################################
'ACERTAR AQUI QUANTAS VEZES TEM DE RODAR ??????**************************************
               '****************************************

'**********************************************************************************
'*************************************

inicio_4:                'segue na procura da plataforma de salvamento   '       
low b.3         
PULSOUT b.3, 5                
PULSIN b.3, 1, w4  ' escreve na w6 leitura da parede da frente
if w4>130 then avanca_4 '120'180
if w4<131 then rodar_4  '120
goto inicio_4 


avanca_4:        'A PROCURAR A plataforma de salvamento com ultra-som ligado:
;if esq_obs=0 and dir_obs=0 then c_avanca_4   
;if esq_obs=0 and dir_obs=1 then direita_6a   'encontrou a plataforma
;if esq_obs=1 and dir_obs=0 then esquerda_6a    'encontrou a plataforma
;if esq_obs=1 and dir_obs=1 then baixa_lata_6 'encontrou a plataforma
readadc 5, b30
if b30<150 then c_avanca_4
if b30>150 then baixa_lata_6
goto baixa_lata_6'inicio_4

c_avanca_4:
if pind.0=0 then c_avanca_4_esquerda
if pind.0=1 then c_avanca_4_direita
goto inicio_4

c_avanca_4_direita:
low b.0         
PULSOUT b.0, 5                ' escreve na w5 leitura da parede direita
PULSIN b.0, 1, w5
if w5<130 then desv_esquerda_4
if w5>130 then desv_direita_4
goto inicio_4

c_avanca_4_esquerda:
low b.1
PULSOUT b.1, 5               'escreve na w5 leitura da parede esquerda
PULSIN b.1, 1, w5
if w5<130 then desv_direita_4
if w5>130 then desv_esquerda_4
goto inicio_4

'desv_esquerda_4:
'low c.5  'alicate fechado     (binário para picaxe 08)
'high c.6                     '(binário para picaxe 08)

'low b.7
'low b.6
'high b.5
'low b.4
'pwmout c.2,10,30
'pwmout c.1,10,30
'goto inicio_4

'desv_direita_4:
'low c.5  'alicate fechado     (binário para picaxe 08)
'high c.6                     '(binário para picaxe 08)

'high b.7
'low b.6
'low b.5
'low b.4
'pwmout c.2,10,30
'pwmout c.1,10,30
'goto inicio_4

desv_esquerda_4:
low  c.5  'alicate fechado     (binário para picaxe 08)
high  c.6                     '(binário para picaxe 08)

high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,33'30
pwmout c.1,10,22
goto inicio_4

desv_direita_4:
low c.5  'alicate fechado     (binário para picaxe 08)
high c.6                     '(binário para picaxe 08)

high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,22'23
pwmout c.1,10,33'30'35
goto inicio_4

rodar_esquerda_vitima:
low c.5  'alicate fechado     (binário para picaxe 08)
high c.6                     '(binário para picaxe 08)
low b.7
high b.6
high b.5
low b.4
pwmout c.2,10,31'29 
pwmout c.1,10,31'29 
return

rodar_direita_vitima:
low c.5  'alicate fechado     (binário para picaxe 08)
high c.6                     '(binário para picaxe 08)
high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,31'29
pwmout c.1,10,31'29
return

rodar_4:
if pind.0=0 then rodar_4_esquerda
if pind.0=1 then rodar_4_direita
goto inicio_4

rodar_4_direita:
gosub rodar_esquerda_vitima'       'rodar com as duas rodas
pause 430
goto inicio_4'goto inicio_5   PROCURA NOS 4 CANTOS


rodar_4_esquerda:
gosub rodar_direita_vitima'       'rodar com as duas rodas
pause 430
goto inicio_4'goto inicio_5   PROCURA NOS 4 CANTOS


'**********************************
'**********************************

inicio_5:                'segue na procura da plataforma de salvamento   '       
low b.3         
PULSOUT b.3, 5                
PULSIN b.3, 1, w4  ' escreve na w6 leitura da parede da frente
if w4>100 then avanca_5
if w4<100 then rodar_5
goto inicio_5 


avanca_5:        'A PROCURAR A plataforma de salvamento com ultra-som ligado:
;if esq_obs=0 and dir_obs=0 then c_avanca_5   
;if esq_obs=0 and dir_obs=1 then direita_6a   'encontrou a plataforma
;if esq_obs=1 and dir_obs=0 then esquerda_6a    'encontrou a plataforma
;if esq_obs=1 and dir_obs=1 then baixa_lata_6 'encontrou a plataforma
readadc 5, b30
if b30<150 then c_avanca_5
if b30>150 then baixa_lata_6
goto baixa_lata_6'inicio_5

c_avanca_5:
low b.0         
PULSOUT b.0, 5                ' escreve na w5 leitura da parede direita
PULSIN b.0, 1, w5
if w5<100 then desv_esquerda_5
if w5>100 then desv_direita_5
'low b.1
'PULSOUT b.1, 5               'escreve na w5 leitura da parede esquerda
'PULSIN b.1, 1, w5
'if w5<160 then desv_direita_5
'if w5>160 then desv_esquerda_5
goto inicio_5 


'desv_esquerda_5:
'low c.5  'alicate fechado     (binário para picaxe 08)
'high c.6                     '(binário para picaxe 08)

''low b.7
'low b.6
'high b.5
'low b.4
'pwmout c.2,10,30
'pwmout c.1,10,30
'goto inicio_5

'desv_direita_5:
'low c.5  'alicate fechado     (binário para picaxe 08)
'high c.6                     '(binário para picaxe 08)

'high b.7
'low b.6
'low b.5
'low b.4
'pwmout c.2,10,30
'pwmout c.1,10,30
'goto inicio_5

desv_esquerda_5:
low  c.5  'alicate fechado     (binário para picaxe 08)
high  c.6                     '(binário para picaxe 08)

high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,33'30
pwmout c.1,10,18
goto inicio_5

desv_direita_5:
low c.5  'alicate fechado     (binário para picaxe 08)
high c.6                     '(binário para picaxe 08)

high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,18'23
pwmout c.1,10,33'30'35
goto inicio_5

rodar_5:
gosub rodar_esquerda_vitima'       'rodar com as duas rodas
pause 350
goto inicio_6 



'*************FINAL **** FINAL **** FINAL **** FINAL
'***********FINAL ******* FINAL ***** FINAL

inicio_6:  'A PROCURAR A plataforma de salvamento com ultra-som ligado:
;if esq_obs=0 and dir_obs=0 then c_avanca_6   
;if esq_obs=0 and dir_obs=1 then direita_6a   'encontrou a plataforma
;if esq_obs=1 and dir_obs=0 then esquerda_6a    'encontrou a plataforma
;if esq_obs=1 and dir_obs=1 then baixa_lata_6 'encontrou a plataforma

readadc 5, b30
if b30<150 then c_avanca_6
if b30>150 then baixa_lata_6
goto baixa_lata_6'inicio_5

c_avanca_6:
low 0         
PULSOUT 0, 5                ' escreve na w5 leitura da parede direita
PULSIN 0, 1, w5
if w5<100 then desv_esquerda_6
if w5>100 then desv_direita_6
'low 2
'PULSOUT 1, 5               'escreve na w5 leitura da parede esquerda
'PULSIN 1, 1, w5
'if w5<160 then desv_direita_6
'if w5>160 then desv_esquerda_6
goto inicio_6

'c_avanca_6:   
'i2cslave $C0,i2cfast,i2cbyte	' Define i2c slave address for the CMPS03
'readi2c 0,(b6)		' ler CMPS03 Software Revision
'readi2c 1,(b5)
'if b5< b22 then desv_direita_6    
'if b5> b23 then desv_esquerda_6
'if b5> b21 and b5<b24 then avancar_6_1 
'goto inicio_6


'desv_esquerda_6:
'low c.5  'alicate fechado     (binário para picaxe 08)
'high c.6                     '(binário para picaxe 08)
'low b.7
'low b.6
'high b.5
'low b.4
'pwmout c.2,10,30
'pwmout c.1,10,30
'goto inicio_6

'desv_direita_6:
'low c.5  'alicate fechado     (binário para picaxe 08)
'high c.6                     '(binário para picaxe 08)
'high b.7
'low b.6
'low b.5
'low b.4
'pwmout c.2,10,30
'pwmout c.1,10,30
'goto inicio_6

c_avancar_6_1:
low c.5  'alicate fechado     (binário para picaxe 08)
high c.6                     '(binário para picaxe 08)
high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,28
pwmout c.1,10,30'Acerto dos motores
goto inicio_6

desv_esquerda_6:
low  c.5  'alicate fechado     (binário para picaxe 08)
high  c.6                     '(binário para picaxe 08)

high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,33'30
pwmout c.1,10,18
goto inicio_6

desv_direita_6:
low c.5  'alicate fechado     (binário para picaxe 08)
high c.6                     '(binário para picaxe 08)

high b.7
low b.6
high b.5
low b.4
pwmout c.2,10,18'23
pwmout c.1,10,33'30'35
goto inicio_6


'#########################


esquerda_6a:
low c.5   'alicate fechado       (binário para picaxe 08)
high c.6                        '(binário para picaxe 08)

low b.7
high b.6
high b.5
low b.4
pwmout c.2,10,35
pwmout c.1,10,35
goto inicio_6

direita_6a:
low c.5   'alicate fechado       (binário para picaxe 08)
high c.6                        '(binário para picaxe 08)

high b.7
low b.6
low b.5
high b.4
pwmout c.2,10,35
pwmout c.1,10,35
goto inicio_6


baixa_lata_6:
gosub baixa_lata_final
pause 2000            'parar 2segundos para baixar o objecto
gosub recuar_return
pause 500
'gosub c_avancar
'pause 800
'gosub virar    'IMPORTANTE IMPORTANTE 'ACERTAR O LADO ESQUERDO OU DIREITO    
'pause 400
'gosub c_esquerda  'IMPORTANTE IMPORTANTE 'ACERTAR O LADO ESQUERDO OU DIREITO    
'pause 1000
'gosub recuar_return
'pause 200
'gosub c_avancar
'pause 200
'gosub recuar_return
'pause 200
'gosub c_avancar
'pause 200
'gosub recuar_return
'pause 500
'gosub parar_return
'pause 30000
'goto inicio_6
end

baixa_lata_final:
low b.7
low b.6
low b.5
low b.4
high c.5   'baixa o alicate e abre           (binário para picaxe 08)
high c.6                                    '(binário para picaxe 08)
pwmout c.2,10,00
pwmout c.1,10,00
return