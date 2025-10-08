## SUBNETSS ##

Es un programa que tiene dos funcionalidades:
- Encontrar la dirección de red dada una dirección y su máscara
- Calcular las subredes dada la dirección elegida y los hosts

### Ejecución ###  

- Clona el repositorio: https://github.com/khankaw/SUBNETSS
- Entra al directorio SUBNETSS
- Da permisos de ejecución

```` bash  
chmod +x subnets.sh  
````
- Para mostrar el panel de ayuda
````
./subnets.sh
````
o
````
./subnets.sh -h
````
#### Para la máscara ####
Ejemplo:  

````
./subnets.sh -b "192.168.5.0 255.255.255.0"
````
Se debe poner el argumento entre comillas de otra forma dará errores

#### Para el cáclulo ####
Ejemplo:  

````
./subnets.sh -m "a 589 7891 200 35 40"
````

El primer argumento es una letra. Puede ser a, b o c y representan un bloque de direcciones privadas:
- a->10.0.0.0/8
- b->172.16.0.0/12
- c->192.168.0.0/16
  
Tanto la letra como los hosts deben de estar dentro de las comillas.

#### Detalles ####

- El bloque a soporta un máximo de 16,777,216 hosts
- El bloque b soporta un máximo de 1,048,576 hots
- El bloque c soporta un máximo de 65,536 hosts
- A cada host que se especifique en el calculo de hosts se le suma un 2 (dirección broadcast y de red) pero esto se puede modificar en la línea 111 del archivo manyhosts.sh
- No es necesario proporcionar el orden de los hosts en orden, puesto que se ordenan automáticamente

  






