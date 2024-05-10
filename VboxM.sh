#!/bin/bash
#
# Challenge 1
#
# Hernández Meza Midgard Sammael
#
#Maquinas virtuales ya creadas
#
#variables
VM=$1
TYPEOS=$2
HDSIZE=$3
RAMSIZE=$4
CPUS=$5
ADATRED=$6
DESC=$7
PATHTOISO=$8

if [[ -z $PATHTOISO ]]
then
    echo "ERROR: agregar todas las variables de entrada"
    #Mostrar las variables de entrada
    echo "Configuración variables de entrada"
    echo "Nombre de la maquina virtual: "$VM
    echo "Tipo de sistema operativo: "$TYPEOS
    echo "Cantidad en MB del disco duro: "$HDSIZE
    echo "Cantidad en MB de Memoria RAM: "$RAMSIZE
    echo "Numero de CPUs: "$CPUS
    echo "Adaptador de red: "$ADATRED
    echo "Descripcion de la maquina virtual: "$DESC
    echo "PATH del archivo ISO: "$PATHTOISO
else
    #Mostrar las variables de entrada
    echo "Configuración variables de entrada"
    echo "Nombre de la maquina virtual: "$VM
    echo "Tipo de sistema operativo: "$TYPEOS
    echo "Cantidad en MB del disco duro: "$HDSIZE
    echo "Cantidad en MB de Memoria RAM: "$RAMSIZE
    echo "Numero de CPUs: "$CPUS
    echo "Adaptador de red: "$ADATRED
    echo "Descripcion de la maquina virtual: "$DESC
    echo "PATH del archivo ISO: "$PATHTOISO
    #confirmacion
    echo "Continuar? y/n : "
    read continua
    #Validacion.
    if [ "$continua" = "y" ]
    then 
        echo "Inicia la creación de la maquina virtual"

        #Creacion de la maquina virtual usando VBoxManage
        VBoxManage createvm --name $VM --register

        #Disco duro
        VBoxManage createhd --filename $VM.vdi --size $HDSIZE --format VDI

        #Controlador de almacenamiento IDE
        VBoxManage storagectl $VM --name "IDE Controller" --add ide

        #vinculacion del disco duro virtual
        VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium $VM.vdi

        #Vinculación de imagen cd/dvd
        VBoxManage storageattach $VM --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $PATHTOISO   #MODIFICAR 

        #Agregar descripción a ala maquina virtual
        VBoxManage modifyvm $VM --description "$DESC"

        #Especificación tipo de sistema operativo de la maquina virtual
        VBoxManage modifyvm $VM --ostype $TYPEOS

        #Asignación de memoria RAM a la maquina virtual
        VBoxManage modifyvm $VM --memory $RAMSIZE

        #I/O  APIC si esta disponible
        VBoxManage modifyvm $VM --ioapic on

        #Asignación del número de nucleos para CPUs de la maquina virtual
        VBoxManage modifyvm $VM --cpus $CPUS

        #Establece procentaje de procesamiento asignado a la CPU
        VBoxManage modifyvm $VM --cpuexecutioncap 100

        #Habilita virtualización por hardware si el host lo tiene disponible
        VBoxManage modifyvm $VM --hwvirtex on

        #Establece orden de booteo
        VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none

        #Configuración de la tarjeta de red de la mauina virtual
        VBoxManage modifyvm $VM --nic1 bridged

        #Adaptador de puente de la tarjeta de red
        VBoxManage modifyvm $VM --bridgeadapter1 $ADATRED

        #Asignación de memoria para la tarjeta grafica
        VBoxManage modifyvm $VM --vram 128

        #lista Las maquinas virtuales creadas.
        VBoxManage list vms

        #iniciar maquina virtual 
        VBoxManage startvm $VM
    else
        echo "Cancela la creacion de la maquina virtual"
        echo "GOOD lUCK"
    fi
fi


    #https://www.youtube.com/watch?v=JHicitRhnFc&t=25s