#!/bin/bash
# Autor: Edmundo Cespedes A.
# Licencia: GNU GPLv2
# Nombre: php_provisioning
# Version: 1.0.0
# FUNCION:
# Instalar servidor web con apache y php
# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
declare -a os_distro=( "Fedora" "RedHat" "CenOS" "AlmaLinux" "RockiLinux" "Debian" "Ubuntu");
declare os;
# ------------------------------------------------------------------------------
# FUNCIONES
# ------------------------------------------------------------------------------
function_os_detect(){
    for i in ${os_distro[@]}; do
         os=$(cat /etc/*-release | grep "NAME" | grep -o -m1 "Fedora");
    done
} 
# ------------------------------------------------------------------------------
# SCRIPT
# ------------------------------------------------------------------------------
function_os_detect;
case $os in
    Fedora | RedHat | CenOS | AlmaLinux | RockiLinux)
         echo "Aprovisionando $os";
         echo "Actualizando $os";
         sudo dnf upgrade -y;
         echo "Instalando Apache en $os";
         sudo dnf install -y httpd;
    ;;
    Debian | Ubuntu)
         echo "Aprovisionando $os";
         echo "Actualizando $os";
         sudo apt update && sudo apt upgrade -y;
         echo "Instalando Apache en $os";
         sudo apt install -y apache2;
         echo "Intalando repositorio Sury para PHP";
         echo "Adicionando repositorio Sury";
         echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list;
         echo "Adicionando GPG key";
         curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg;
         echo "instalando PHP";
         sudo apt install -y php8.1 php-{bcmath,cli,common,curl,dev,gd,imagick,imap,intl,mbstring,mysql,opcache,pgsql,readline,soap,xml,xmlrpc,zip};
    ;;
    *)
         echo "Sistema operativo desconocido";
         exit;
         echo "Actualizando repositorios";
         sudo apt update;

    ;;
esac

