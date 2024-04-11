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
            echo "Adicionando repositorio Remirepo" 
            sudo dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
            sudo dnf -y makecache
            echo "Limpiando  lista de verciones de PHP"
            sudo dnf -y module reset php
            echo "Instalando PHP"
            sudo yum module install -y php:remi-8.1
        ;;
        2)
            echo "Intalando repositorio Sury para PHP";
            echo "Paquetes adicionales";
            sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2;
            echo  "Paquetes adicionales instalados con exito"
            sleep 2;
            clear;
            if [ ! -f /etc/apt/sources.list.d/sury-php.list ]; then
            echo "Adicionando repositorio Sury";
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list;
            echo "Adicionando GPG key";
            curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg;
            sudo apt update;
            clear;
            echo "Repositorio Sury instalado con exito"
            sleep 2;
            clear;
            else
                echo "Repositorio Sury ya se encuntra instalado"
                sleep 2;
                clear;
            fi
            echo "Instalando PHP y modulos adicionales";
            sudo apt install -y php8.1 php8.1-{bcmath,cli,common,curl,dev,gd,imagick,imap,intl,mbstring,mysql,opcache,pgsql,readline,soap,xml,xmlrpc,zip};
            sleep 2;
            clear;
        ;;
        0)
            echo "Sistema no definido";
            exit;
        ;;
    esac
}
f_crate_php_test() {
    echo "Creando archivo de prueba de php"
    if [ -f "$HOME/tets.php" ]; then
        echo "El archivo test.php ya existe"
    else
    cat <<- EOF > "$HOME/test.php"
<?php
    phpinfo();
?>
EOF
        echo "Creando link simbolico para test.php"
        sudo  ln -sf "$HOME/test.php /var/www/html/"
        echo "Link creado con exito"
        echo "Probar la instalacion en la IP : http://$(hostname -I | cut -d' ' -f1)/test.php"
    fi
}
f_install_composer() {
    echo "Intalando compose en $os"
    case $os_id in
        1)
            curl -sS https://getcomposer.org/installer -o composer-setup.php
            echo "Obteniendpo el verificandor del instalador"
            HASH=$(curl -sS https://composer.github.io/installer.sig)
            echo "$HASH"
            echo "Instalando composer"
            php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
        ;;
        2)
            sudo apt install curl git unzip
            curl -sS https://getcomposer.org/installer -o composer-setup.php
            echo "Obteniendpo el verificandor del instalador"
            HASH=$(curl -sS https://composer.github.io/installer.sig)
            echo "$HASH"
            echo "Instalando composer"
            php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
            sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
            echo "Comprobando la instalacion de Composer"
            composer
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
f_install_apache;
f_install_php;
f_crate_php_test;
f_install_composer;
if [[ $? == 0 ]]; then
    echo "Instalacion realizada exitosamente"
else
    echo "Instalacion NO realizada exitosamente"
fi
