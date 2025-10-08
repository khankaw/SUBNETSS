#!/bin/bash
#######VARIABLES

declare -i max_hosts_a=16777216
declare -i max_hosts_b=1048576
declare -i max_hosts_c=65536
declare -a hosts_array
declare -a hosts_array_final
declare -a hosts_adjusted
declare -i suma
declare -i suma_hosts=0
declare -i potencia=2
declare -a mascara_init=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
declare -a mascara_aux
declare -i num_ini=0
declare -a array_n
declare -a mascara_final_arr
declare -a masks_to_screen
declare -i flag=0
declare -a ips_red_conv
declare -a ips_broadcast_conv
declare -a ip_cpy
declare -a ip_br_cpy

########################################################FUNCIONES

#####Revisar si la dirección especificada es correcta

function check_dir_priv()
{
	ip="$1"
	class_a="a"
	class_b="b"
	class_c="c"
	
	if [ "$ip" != "$class_a" ] && [ "$ip" != "$class_b" ] && [ "$ip" != "$class_c" ]; then

		echo -e "\n$rC[+]$eC Dirección $rC inválida $eC. Solamente se admiten: a (10.0.0.0/8), b (172.16.0.0/12), c (192.168.0.0/16)"
		exit 1
	
	fi	

}


#################################################################################FLUJO

#####Obtener la ip seleccionada

ip=$(echo $ip_arr | awk '{print $1}')

#####Obtener los hosts

total_hosts=$(echo "${ip_arr:1}")

#####Revisar argumentos vacios

if [ -z "$ip" ] || [ -z "$total_hosts" ];then

	echo -e "\n$rC[+]$eC Argumentos $rC insuficientes $eC"
	exit 1

fi


#####LLamada de la funcion chech_dir_priv

check_dir_priv $ip_arr

#####Se selecciona el rango privado de ip

if [ "$ip" == a ];then
    declare -a ip_priv=(10 0 0 0)
elif [ "$ip" == b ];then
    declare -a ip_priv=(172 16 0 0)
elif [ "$ip" == c ];then
    declare -a ip_priv=(192 168 0 0)
fi

#####Pasar hosts a un array

for element in $total_hosts; do

	hosts_array+=("$element")

done


#####Revisar negativos o simbolos

for element in ${hosts_array[@]};do

	if [[ ! "$element" =~ ^[0-9]+$ ]] || [ "$element" -lt 0 ]; then

    	echo -e "\n$rC[+]$eC Formato $rC inválido $eC. No puede haber letras o negativos en los hosts indicados"
        exit 1
    fi
   
done

#####Ordenar de mayor a menor
hosts_array_sort=($(printf "%s\n" "${hosts_array[@]}" | sort -nr))


#####colocar en un nuevo array los hosts sumando la dirección de red y broadcast

#####PUEDES MODIFICAR ESTE COMPORTAMIENTO PONIENDO UN 0 EN VEZ DE UN 2

for element in ${hosts_array_sort[@]};do

	suma=$((element+=2)) #####Pon el 0 aquí si quieress
	hosts_array_final+=("$suma")
	
done

#####AQUI TERMINA LA PARTE PARA MODIFICAR

#####Se ajustan los hosts a las potencias

for element in ${hosts_array_final[@]};do

    potencia=2

    while true;do

        n=$((2**$potencia))
        if [ $n -ge $element ];then

            hosts_adjusted+=("$n")
            array_n+=("$potencia")
            break

        else

            potencia+=1

        fi

    done

done

#####Suma de hosts

for i in ${!hosts_adjusted[@]}; do

    suma_hosts=$(($suma_hosts + ${hosts_adjusted[$i]}))
    
done


#####Comprobacion de la suma de hosts

if [ "$ip" == "a" ] && [ $suma_hosts -gt $max_hosts_a ]; then
    echo -e "\n$rC[+]$eC El bloque de direcciones a no soporta la suma de hosts"
    exit
elif [ "$ip" == "b" ] && [ $suma_hosts -gt $max_hosts_b ]; then
    echo -e "\n$rC[+]$eC El bloque de direcciones b no soporta la suma de hosts"
    exit
elif [ "$ip" == "c" ] && [ $suma_hosts -gt $max_hosts_c ]; then
    echo -e "\n$rC[+]$eC El bloque de direcciones c no soporta la suma de hosts"
    exit
fi

#####Se ajustan los hosts (ej. 59->64 o 1000->1024)

###Obtener la mascara de red

for n in ${array_n[@]};do #Recorre todos los elementos del arreglo 

	n_ini=$((32-n))

	for ((i=31;i>=$n_ini;i--));do #Aquí se toman los bits necesarios para la máscara

    	mascara_init[$i]=$(( mascara_init[$i] - 1 ))

	done

	while [ $num_ini -le 31 ];do #Se van tomando de 8 en 8 los elementos del array para recomponer los octetos

		for ((i=$num_ini;i<=31;i++));do

			valor=${mascara_init[$i]}

        	arr_aux+=("$valor")

        	if [ $i -eq 7 ];then
            	break
        	elif [ $i -eq 15 ];then
            	break
        	elif [ $i -eq 23 ];then
            	break
        	elif [ $i -eq  31 ];then
            	break
        	fi

    	done

    	cadena=$(printf "%s" "${arr_aux[@]}") #transformación de cada octeto a decimal
    	decimal=$(echo "ibase=2; $cadena" | bc)
    	mascara_final_arr+=("$decimal")
    	
    	arr_aux=()
    	num_ini+=8
			
	done

	#####Se reinician num ini y mascara init para reutilizar con cada n
	
	mask_string="${mascara_final_arr[@]}"
	mask_string_p=${mask_string// /.}
	masks_to_screen+=("$mask_string_p")

	num_ini=0
	mascara_init=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
	mascara_final_arr=()
	
done

#####Se obtienen la direccion de red y broadcast

for mask in ${masks_to_screen[@]};do #toma un elemento en el arreglo, es decir una máscara

	mask_dot=$(echo $mask | sed 's/\./ /g') #sustituye puntos por espacios
	mask_arr=($mask_dot) #Pasalo a arreglo

	#####Toma una copia de la direccion de red privada, pasala a string, sustituye espacios por puntos y guardala en un arreglo
	ip_cpy=${ip_priv[@]}
	ip_string="${ip_cpy[@]}"
	ip_string=$(echo $ip_string | sed 's/ /\./g')
	ips_red_conv+=("$ip_string")
	
	for j in ${!mask_arr[@]};do

		if [ ${mask_arr[$j]} -lt 255 ];then #si existe en la máscara algú numero menor a 255
			
			resta=$((255 - mask_arr[$j])) #¿Cuanto le falta para 255? (ej. 255-192=63)
			ip_priv[$j]=$((ip_priv[$j]+$resta)) #sustituye el elemento en el valor donde la máscara cambia
		fi
		
	done
	
	#####Toma una copia de la dirección broadcast, pasala a string, sustituye espacios por puntos y guardala en un arreglo
	
	ip_br_cpy=${ip_priv[@]}
	ip_br_string="${ip_br_cpy[@]}"
	ip_br_string=$(echo $ip_br_string | sed 's/ /\./g')
	ips_broadcast_conv+=("$ip_br_string")

	for i in ${!ip_priv[@]};do

		if [ $(($i+1)) -gt 3 ];then
			break
		fi

		if [ ${ip_priv[$i]} -lt 255 ] && [ ${ip_priv[$i+1]} -eq 255 ]; then 
			ip_priv[$i]=$((ip_priv[$i]+1))
		fi
	
	done

	for i in ${!ip_priv[@]};do
		if [ ${ip_priv[$i]} -ne 255 ];then
			flag+=1
		fi
	done

	if [ $flag -eq 4 ];then
		ip_priv[-1]=$((${ip_priv[-1]}+1))
		flag=0
	else
		flag=0
	fi

	#echo "${ip_priv[@]}"

	for k in ${!ip_priv[@]};do
		if [ ${ip_priv[$k]} -ge 255 ];then
			ip_priv[$k]=0
		fi
	done
	
done

echo -e "\n"

echo -e "$mC[+]$eC A cada dirección se le ha sumado un 2, puedes cambiar este comportamiento en la linea 111 del archivo $bC manyhosts.sh $eC"

echo -e "\n"

{
  printf "%-10s %-10s %-18s %-15s %-15s\n" "Req_Hosts" "Ajustado" "Mask" "Network" "Broadcast"
  printf "%s\n" "----------------------------------------------------------------------"
  for i in "${!hosts_adjusted[@]}"; do
    printf "%-10s %-10s %-18s %-15s %-15s\n" \
      "${hosts_array_sort[i]}" "${hosts_adjusted[i]}" "${masks_to_screen[i]}" "${ips_red_conv[i]}" "${ips_broadcast_conv[i]}"
  done
}
