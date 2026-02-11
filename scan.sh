#!/bin/bash

##########Funciones#########

#Funcion para hacer ping a una direccion
function ping_f()
{

addr="$1"
ping=$( { time fping -n -c 1 $addr; } 2>&1 )
resultado=$?
if [  $resultado -eq 0 ];then

	mac_vec=$(arp -n | grep $addr | awk '{print $3}')

  	echo -e "${mC}[+]${eC}IP: $cadena  ${mC}[+]${eC}MAC: $mac_vec" > /dev/tty
 fi

}

#Funcion para obtener la interfaz

function int()
{

local inter="$1" #Recibe el nombre escrito

code=$(ifconfig | grep "$inter") #Busca la interfaz

if [ "$code" ]; then #Si se encuentra imprimela, si no, termina el programa
    echo -e "${rC}[+]${eC}Comenzando Scan"
else
    echo -e "\n$rC[+]$eCNo se encontro la interfaz\n" > /dev/tty
    exit 0
fi

}

#Funcion para invertir un arreglo 

function inv()
{

local dir=("$@") Recibe el arreglo
length=${#dir[@]}
for (( i=$length; i>=0; i-- )); do #Construye un arreglo auxiliar invertido
	dir_aux+=("${dir[$i]}")
done

echo ${dir_aux[@]}

}

#Función para pasar de 192.168.1.0 a [192 168 1 0]

function dir_to_arr()
{

    dir="$1" #Recibe la cadena y separala en octetos
    dir1=$(echo "$dir" | sed 's/\./ /g')
    oc1=$(echo $dir1 | awk '{print $1}')
    oc2=$(echo $dir1 | awk '{print $2}')
    oc3=$(echo $dir1 | awk '{print $3}')
    oc4=$(echo $dir1 | awk '{print $4}')

    arr_aux+=("$oc1" "$oc2" "$oc3" "$oc4")

    echo "${arr_aux[@]}" #Entrega en forma de arreglo
}

#Funcion para pasar de [192 168 1 0] a 192.168.1.0
function string()
{

local arr=("$@") #Recibe arreglo
local cadena="" #Separador
for element in ${arr[@]}; do #Encadena cada elemento con un delimitador "."
	delimiter="."
	cadena+="$element$delimiter"
done
cadena="${cadena%$delimiter}" #Elimina el ultimo "."
echo $cadena

}
############################
#Extracción de ip y mascara de red
int $ip_int "Obten la interfaz"
ip=$(ifconfig | grep $ip_int -C 1 | grep inet | head -n 1 | awk '{print $2}') #Obten la IP
netmask=$(ifconfig | grep $ip_int -C 1 | grep inet | head -n 1 | awk '{print $4}') #Obten la máscara
mac=$(nmcli device show $ip_int | grep HWADDR | awk '{print $2}') #Obten la MAC
mtu=$(nmcli device show $ip_int | grep MTU | awk '{print $2}') #Obten el MTU
dns=$(nmcli device show $ip_int | grep DNS | awk '{print $2}') #Obten el dns
gate=$(nmcli device show $ip_init | grep IP4.GATEWAY | awk '{print $2}') #Obten el Default Gateway

echo -e "\n${mC}[+]${eC}$ip_int:\n" #Muestra la info
echo -e "${pC}[+]${eC}IP: $ip | ${pC}[+]${eC}MAC: $mac | ${pC}[+]${eC}NETMASK: $netmask | ${pC}[+]${eC}MTU: $mtu | ${pC}[+]${eC}DNS: $dns | ${pC}[+]${eC}DEFAULT GATEWAY: $gate\n"

#IP y Máscara pasan a array
ip_arr=($(dir_to_arr $ip))
mask_arr=($(dir_to_arr $netmask))

#Se obtiene la dirección de red
#Se multiplica de forma lógica [192 168 1 0] con [255 255 255 0] para obtener la red

for i in ${!ip_arr[@]}; do

	mult=$(( ip_arr[i] & mask_arr[i] ))
    red+=("$mult")

done

for i in ${!mask_arr[@]}; do #Para obtener la wildcard

	hosts=$(( 255 - ${mask_arr[$i]} ))
	wildcard+=("$hosts")
	
done
#Se invierten Wildcard e IP
wild_inv=($(inv ${wildcard[@]}))
dir_inv=($(inv ${red[@]}))

for i in ${!wild_inv[@]}; do

	sum=$(( dir_inv[i] + wild_inv[i] )) #Se calcula la suma de el elemento i de la wildcard + ip
	sum2=$(( dir_inv[i+1] + wild_inv[i+1] )) # La suma del siguiente elemento

	while [[ dir_inv[i] -ne $sum ]]; do
		dir2=($(inv ${dir_inv[@]})) #Se invierte la direxxion para que quede normal
		cadena=$(string ${dir2[@]})
		ping_f $cadena
		sub=$(( dir_inv[i]+=1 )) # Al indice de la direccion invertida se suma 1 para obtener la siguiente direccion [0 0 168 192] -> [1 0 168 192]. Aquí ya sería 192.168.0.1
        dir_inv[i]=$sub

		if [[ dir_inv[i] -eq $sum ]]; then #Si el elemento i es igual a la suma previamente hecha entones se ha llegado al final de un bloque 
			dir2=($(inv ${dir_inv[@]}))
			cadena=$(string ${dir2[@]})
			ping_f $cadena
			if [[ dir_inv[i+1] -ne $sum2 ]];then #Se comprueba si el valor del elemento i+1 es igual a la suma2, para saber si continuar o terminar el programa
				indice=i+1 #Se obtiene el indice + 1
				for (( j=0; j<$indice; j++ )); do #Para j desde 0, mientras sea MENOR que indice. Aquí se pretenden reiniciar todos los elementos anteriores a 0 para comenzar el siguiente bloque
					reset=$(( dir_inv[j]=0 )) #El elemento =0
					dir_inv[j]=$reset
				done
				set_next=$(( dir_inv[i+1]+=1 )) #Al siguiente elemento se le suma 1 [255 0 168 192] -> [ 0 1 168 192]
				dir_inv[i+1]=$set_next
				
			else
				break
			fi
		fi
		
	done
done

