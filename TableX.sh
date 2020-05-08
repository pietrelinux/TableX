#!/bin/sh

################################    Dependencias    #########################

clear
echo " Bienvenid@s al script de creacion"
sleep 1
echo " de la imagen linux para una tablet allwinner "
sleep 1
echo " Instalando dependencias"
sleep 1
apt-get update
apt-get install -y flex bison python3-dev gcc-arm-linux-gnueabihf wget bc tree git build-essential libssl-dev libusb-1.0-0-dev bin86 libncurses5 libncurses5-dev u-boot-tools device-tree-compiler swig libpython2-dev libusb-dev zlib1g-dev pkg-config libgtk2.0-dev libglib2.0-dev libglade2-dev
echo " Instalación de dependencias completado "
sleep 1
echo " Creando directorios y disco RAM "
sleep 1
################################   Creando directorios y disco RAM    #########################

mkdir /home/sunxi/
mkdir /home/sunxi/boot/
mkdir /home/sunxi/tools
mkdir /home/sunxi/u-boot
mkdir /home/sunxi/kernel/
clear
echo " Directorios creados "
################################   SUNXI-TOOLS    #########################
cp TableX_defconfig /home/sunxi
echo " OK "
sleep 1
echo " Instalando sunxi-tools"
sleep 1
cd /home/sunxi/tools
git clone https://github.com/linux-sunxi/sunxi-tools
cd sunxi-tools
make -j$(nproc)
make -j$(nproc) install

echo " Instalación completada"
sleep 1
################################   KERNEL LEGACY    #########################
#echo " Descargando Kernel sunxi"
#cd /home/sunxi/kernel/sunxi
#git clone https://github.com/linux-sunxi/linux-sunxi.git

################################   SCRIPT DE INICIO DE U-BOOT BOOT.SCR    #########################
echo " Añadiendo script de inicio "
> /home/sunxi/boot/boot.cmd
cat <<+ >> /home/sunxi/boot/boot.cmd
setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p1 rootwait panic=10
load mmc 0:1 0x43000000 sun8i-a33-q8-tablet.dtb || load mmc 0:1 0x43000000 boot/sun8i-a33-q8-tablet.dtb
load mmc 0:1 0x42000000 zImage || load mmc 0:1 0x42000000 boot/zImage
bootz 0x42000000 - 0x43000000
+
mkimage -C none -A arm -T script -d /home/sunxi/boot/boot.cmd /home/sunxi/boot/boot.scr
echo " Completado"
sleep 1
################################   KERNEL   #########################
echo " Descargando y descomprimiendo Kernel mainline" 
sleep 1
wget -P /home/sunxi/kernel https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.11.tar.xz
cd /home/sunxi/kernel
tar -Jxf /home/sunxi/kernel/linux-5.6.11.tar.xz
cp /home/sunxi/TableX_defconfig /home/sunxi/kernel/linux-5.6.11/arch/arm/configs/
cd /home/sunxi/kernel/linux-5.6.11
echo " Compilando "
make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- TableX_defconfig
# sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- xconfig
make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs 
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=output make modules modules_install
cp -R lib /home/sunxi/boot
cp arch/arm/boot/zImage  /home/sunxi/boot
cd ..
echo " Kernel compilado "
sleep 1
################################   U-BOOT   #########################
echo " Descarga y compilacion de u-boot "
sleep 1
echo " Descargando u-boot denx "
sleep 1
cd /home/sunxi/u-boot
wget ftp://ftp.denx.de/pub/u-boot/u-boot-2020.01.tar.bz2
cp u-boot-2020.01.tar.bz2 /home/sunxi/u-boot
tar -xjvf u-boot-2020.01.tar.bz2
echo " Descarga y descompresión de u-boot finalizada "
sleep 1
echo " Cuando aparezca el menu "
sleep 1
echo " no tiene que configurar nada "
sleep 1
echo "para continuar, seleccione Menu ----> File ----> Quit"
sleep 1
cd u-boot-2020.01
echo "      Menu de compilación del u-boot"
echo " Elija una opción para compilación del u-boot según su modelo de tablet"
sleep 2
echo "1. 	Tablet a13 q8 "
echo ""
echo "2. 	Tablet a23 q8 Resolución 800x480"
echo ""
echo "3. 	Tablet a33 q8 Resolución 1024x600"
echo ""
echo "4. 	Tablet a33 q8 Resolución 800x480"
echo ""
echo "5. 	iNet_3F"
echo ""
echo "6. 	iNet_3W"
echo ""
echo "7. 	iNet_86VS"
echo ""
echo "8. 	iNet_D978"
echo ""
echo -n "	Seleccione una opcion [1 - 8]"
read uboot
case $uboot in
1) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a13_tablet_defconfig;;
2) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a23_tablet_800x480_defconfig;;
3) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a33_tablet_1024x600_defconfig;;
4) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a33_tablet_800x480_defconfig;;
5) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_3F_defconfig ;;
6) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_3W_defconfig;;
7) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_86VS_defconfig;;
8) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_D978_rev2_defconfig;;
*) echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;;
esac
sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
clear
echo "Compilación de u-boot terminada"
sleep 1
exit
