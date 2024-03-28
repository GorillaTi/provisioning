#!/bin/bash
# Autor: Edmundo Cespedes A.
# Licencia: GNU GPLv2
# Nombre: Initial Provisioning
# Version: 1.0.0
# FUNCION:
# Instalar servidor web con apache y php
# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
declare -a os_distro=( "Fedora" "RedHat" "CenOS" "AlmaLinux" "RockiLinux" "Debian" "Ubuntu");
#declare os;
declare os_id=0;
# ------------------------------------------------------------------------------
# FUNCIONES
# ------------------------------------------------------------------------------
f_os_detect() {
    for i in "${os_distro[@]}"; do
        local distro=$(cat /etc/*-release | grep "NAME" | grep -o -m1 -i "$i");
        if [ -n "$distro" ]; then
            os=$distro;
            break;
        fi
    done
    case $os in
        Fedora | RedHat | CenOS | AlmaLinux | RockiLinux)
            os_id=1; 
        ;;
        Debian | Ubuntu)
            os_id=2; 
        ;;
    *)
        echo "Sistema operativo desconocido";
        exit;
    ;;
    esac
    echo "Sistema Operativo indetificado como: $os"
}
f_os_update() {
    echo "Actualizando $os";
    case $os_id in
        1)
            sudo dnf upgrade -y;
        ;;
        2)
            sudo apt update && sudo apt upgrade -y;
        ;;
        0)
            echo "Sistema no definido";
            exit;
        ;;
    esac
}

# ------------------------------------------------------------------------------
# SCRIPT
# ------------------------------------------------------------------------------
f_os_detect;
sleep 2;
clear;
echo "Aprovisionando $os";
f_os_update;

# Verificancion de Proceso Ejecutado
if [[ $? == 0 ]]; then
    echo "Instalacion realizada exitosamente"
else
    echo "Instalacion NO realizada exitosamente"
fi
