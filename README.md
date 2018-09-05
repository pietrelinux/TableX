# TableX

Hola people, este script sirve para descargar las dependencias compilar y crear una imagen mas o menos funcional de un ubuntu 14 para tablets allwinner.

Puedes usarlo en ram o en local.

Estas son las funciones que realiza el script

1. Instalar dependencias
2. Crear directorios
3. Instalación de sunxi tools
4. Creación de imagen Rootfs
5. Creación de debootstrap dentro de rootfs
6. Creación de script de inicio de u-boot "boot.src"
7. Descargar ,descomprimir ,configurar ,compilar e instalar Kernel mainline en rootfs
8. Descarga de uboot
9. Selección de plantilla para la compilacion de u-boot
10. Montaje de particiones dentro del rootfs
11. Ejecución debootstrap segunda fase 
12. Limpieza y desmontaje de particiones.
13. Salida
