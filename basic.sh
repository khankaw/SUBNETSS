#!/bin/bash

#####Variables

declare -a arr_aux

declare -i flag=0

#####Funciones

function dir_vacia()
{

	dir="$1"
	dir1=$(echo "$dir" | sed 's/\./ /g')
	oc1=$(echo $dir1 | awk '{print $1}')
	oc2=$(echo $dir1 | awk '{print $2}')
	oc3=$(echo $dir1 | awk '{print $3}')
	oc4=$(echo $dir1 | awk '{print $4}')

	if [ -z $oc1 ] || [ -z $oc2 ] || [ -z $oc3 ] || [ -z $oc4 ]; then

    	echo -e "\n$rC[+]$eC Formato invalido. Argumentos insuficientes" > /dev/tty
    	flag=1
    	exit 1

	else

    	arr_aux+=("$oc1" "$oc2" "$oc3" "$oc4")

	fi

	echo "${arr_aux[@]}"
}

function check_element()
{
	arr=("$@")

	for element in ${arr[@]}; do

    	if [[ ! "$element" =~ ^[0-9]+$ ]] || [ "$element" -lt 0 ] || [ "$element" -gt 255 ]; then

        	echo -e "\n$rC[+]$eC Formato inválido. No puede haber letras, negativos o mayores a 255 en la direccion" >/dev/tty
        	flag=1
        	exit 1

    	fi
    	
	done   
}


function dir_red()
{

	local -n ip_a="$1"
	local -n mask_a="$2"
	declare -a red

	for i in ${!ip_a[@]}; do

		mult=$(( ip_a[i] & mask_a[i] ))
		red+=("$mult")	
		
	done

	dir_r="${red[*]}"
	dir_r=$(echo "$dir_r"| sed 's/ /\./g')
	echo -e "\n$mC [+] $eC La direccion de $blC red $eC es: $bllC$dir_r $eC"
	
}
#####Flujo

ip=$(echo $ip_mask | awk '{print $1}')

mask=$(echo $ip_mask | awk '{print $2}')

ip_arr=($(dir_vacia $ip))

mask_arr=($(dir_vacia $mask))

check_element ${ip_arr[@]}

check_element ${mask_arr[@]}

if [ "$flag" -eq 1 ]; then

	echo -e "\n$rC[+]$eC Hubo un error en la sintaxis"	
	exit 1

else

	dir_red ip_arr mask_arr

fi


