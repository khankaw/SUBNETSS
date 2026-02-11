#!/bin/bash

#####COLORES

#verde
gC="\e[38;5;46m\e[1m"
#FinalizaColor
eC="\033[0m\e[0m"
#rojo
rC="\e[0;31m\033[1m"
#azul electrico
bC="\e[38;5;21m\e[1m"
#amarillo
yC="\e[0;33m\033[1m"
#morado
mC="\e[38;5;92m\e[1m"
#turquesa
tC="\e[0;36m\033[1m"
#gris
grC="\e[0;37m\033[1m"
#rosa
pC="\e[38;5;199m\e[1m"
#rosa claro
plC="\e[38;5;207m\e[1m"
#rosa mas claro
pllC="\e[38;5;219m\e[1m"
#azul claro
blC="\e[38;5;27m\e[1m"
#azul mas claro
bllC="\e[38;5;33m\e[1m"
#azul mas mas claro
blllC="\e[38;5;39m\e[1m"


function helpPanel()
{
	source helpPanel.sh
}

function basic()
{

	source basic.sh

}

function manysubnets()
{

	source manysubnets.sh

}

function scan()
{

	source scan.sh

}

while getopts "b:""m:""n:""h" arg; do

    case $arg in

        b) ip_mask=$OPTARG;;
        m) ip_arr=$OPTARG;;
        n) ip_int=$OPTARG;;
        h) ;;

    esac

done

if [ "$ip_mask" ];then
	basic
elif [ "$ip_arr" ];then
	manysubnets	
elif [ "$ip_int" ];then
	scan
else
	helpPanel
fi
