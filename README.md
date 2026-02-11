## SUBNETSS ##

Es un programa que tiene tres funcionalidades:
- Encontrar la dirección de red dada una dirección y su máscara
- Calcular las subredes dada la dirección elegida y los hosts
- Encontrar vecinos en la red usando mensajes ping para una interfaz dada

### Ejecución ###  

- Clona el repositorio: https://github.com/khankaw/SUBNETSS.git
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

![NuevoHelpPanel](https://github.com/user-attachments/assets/f02a43fe-0e6e-41d1-be69-3ee4d338126b)

#### Para la máscara ####
Ejemplo:  

````
./subnets.sh -b "192.168.5.0 255.255.255.0"
````
Se debe poner el argumento entre comillas de otra forma dará errores

<img width="906" height="133" alt="image" src="https://github.com/user-attachments/assets/ee79df1b-f933-4b4a-8bba-dc6b4eae6134" />

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

<img width="1316" height="427" alt="Ejemplo" src="https://github.com/user-attachments/assets/28a998bf-49e1-4b01-a950-e5cc7cf65d90" />

#### Para escanear ####

Ejemplo:

````
./subnets.sh -n enp0s3
````
El nombre de la interfaz se puede especificar sin comillas

![EjemploScan](https://github.com/user-attachments/assets/ed8d3e2f-3909-4210-9c52-e6c1d0103d93)


#### Detalles ####

- El bloque a soporta un máximo de 16,777,216 hosts
- El bloque b soporta un máximo de 1,048,576 hots
- El bloque c soporta un máximo de 65,536 hosts
- A cada host que se especifique en el calculo de hosts se le suma un 2 (dirección broadcast y de red) pero esto se puede modificar en la línea 111 del archivo manyhosts.sh
- No es necesario proporcionar el orden de los hosts en orden, puesto que se ordenan automáticamente

  






