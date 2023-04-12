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
#declare os;
declare os_id=0;
# ------------------------------------------------------------------------------
# FUNCIONES
# ------------------------------------------------------------------------------
f_os_detect() {
    for i in ${os_distro[@]}; do
        local distro=$(cat /etc/*-release | grep "NAME" | grep -o -m1 -i "$i");
        if [ ! -z "$distro" ]; then
            os=$distro;
            break;
        fi
    done
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
f_install_apache() {
    echo "Instalando Apache en $os";
    case $os_id in
        1)
            sudo dnf install -y httpd;
        ;;
        2)
            sudo apt install -y apache2;
        ;;
        0)
            echo "Sistema no definido";
            exit;
        ;;
    esac
}
f_install_php() {
    echo "Instalando Apache en $os";
    case $os_id in
        1)
            echo "Intalando repositorio Remirepo para PHP";
            echo "Paquetes adicionales";
            sudo dnf -y install epel-release
            sudo dnf config-manager --set-enabled powertools
            sudo dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
            sudo dnf -y makecache
            sudo dnf -y module reset php
            sudo yum module install -y php:remi-8.1
        ;;
        2)
            echo "Intalando repositorio Sury para PHP";
            echo "Paquetes adicionales";
            sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2;
            echo "Adicionando repositorio Sury";
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list;
            echo "Adicionando GPG key";
            curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg;
            sudo apt update;
            echo "Instalando PHP y modulos adicionales";
        sudo apt install -y php8.1 php-{bcmath,cli,common,curl,dev,gd,imagick,imap,intl,mbstring,mysql,opcache,pgsql,readline,soap,xml,xmlrpc,zip};
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
echo "Aprovisionando $os";
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
f_os_update;
f_install_apache;
f_install_php;
