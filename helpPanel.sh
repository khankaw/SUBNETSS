#!/bin/bash

echo -e "\n$blC SUBNETSS $eC te va a ayudar a practicar subnetting o a hacerlo de forma automática para tus ejercicios de configuración de"
echo -e "equipos mientras practiques\n"

echo -e "Tienes tres opciones:\n"

echo -e "	$mC -b $eC Obtener la dirección de red a partir de una dirección y una máscara\n"
echo -e "		ej. $bllC ./subnets.sh $eC-b $yC\"192.168.1.1 255.255.255.0\" $eC \n"
echo -e "	$mC -m $eC Hacer el subnetting de una ip privada (a,b o c) indicando la letra y los hosts requeridos\n"
echo -e "		ej. $bllC ./subnets.sh $eC-m $yC\"a 499998 199998 99998 59998 45 22 14 6\" $eC \n"
echo -e "	$mC -h $eC Muestra este panel de ayuda\n"
echo -e "	$rC $eC En la opción -m se le suma 2 a cada número de host indicado\n"
echo -e "	$rC $eC En ambas opciones tienes que especificar el argumento con dobles comillas, de otra forma tendrás errores\n"
echo -e "	$rC $eC Los bloques soportados para calcular subredes son $bllC 10.0.0.0/8, 172.16.0.0/12 y 192.168.0.0/16$eC \n"
