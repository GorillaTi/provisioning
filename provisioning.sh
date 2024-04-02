#!/bin/bash
# Autor: Edmundo Cespedes A.
# Licencia: GNU GPLv2
# Nombre: Provisioning
# Version: 1.0.0
# FUNCION:
# Aprovisionamiento de servidor
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
        local distro
        distro=$(cat /etc/*-release | grep "NAME" | grep -o -m1 -i "$i");
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

# Función para dibujar una línea horizontal
draw_horizontal_line() {
    local line=""
    local width=${COLUMNS:-$(tput cols)}  # Obtener el ancho de la terminal o establecer un valor predeterminado
    local char="${1:--}"  # Obtener el carácter especificado o usar "-" como predeterminado
    for ((i=0; i<width; i++)); do
        line+="$char"
    done
    echo "$line"
}

# Función para imprimir texto en negrita
bold_text() {
    echo -e "\e[1m$1\e[0m"  # \e[1m inicia negrita, \e[0m termina negrita
}

# ------------------------------------------------------------------------------
# SCRIPT
# ------------------------------------------------------------------------------
# Menu del script

#Detectando Sistema Operativo
f_os_detect

# Definir las opciones del menú
options=("Opción 1" "Opción 2" "Opción 3" "Salir")

# Bucle para mostrar el menú
while true; do
    # Limpiar la terminal
    clear

    # Mostrar el título del menú
    draw_horizontal_line "*"
    bold_text "Menú interactivo de Aprovisionamiento para $os"
    draw_horizontal_line "*"

    # Mostrar las opciones del menú
    for ((i=0; i<${#options[@]}; i++)); do
        echo "$((i+1)). ${options[i]}"
    done

    # Pedir al usuario que elija una opción
    draw_horizontal_line "="
    read -rp "Ingrese el número de la opción deseada: " choice
    draw_horizontal_line

    # Validar la opción ingresada
    if [[ "$choice" -gt 0 && "$choice" -le "${#options[@]}" ]]; then
        case $choice in
            1)
                echo "Ha elegido la Opción 1"
                # Agrega aquí el código para la Opción 1
                f_os_update
                ;;
            2)
                echo "Ha elegido la Opción 2"
                # Agrega aquí el código para la Opción 2
                ;;
            3)
                echo "Ha elegido la Opción 3"
                # Agrega aquí el código para la Opción 3
                ;;
            4)
                echo "Saliendo del programa"
                exit
                ;;
            *)
                echo "Opción inválida. Por favor, elija una opción válida."
                ;;
        esac
    else
        echo "Opción inválida. Por favor, elija una opción válida."
    fi

    # Esperar antes de volver al menú
    read -rp "Presione Enter para volver al menú principal..."
    # Volver al principio del bucle
done

# Verificancion de Proceso Ejecutado
if $?; then
    echo "Instalacion realizada exitosamente"
else
    echo "Instalacion NO realizada exitosamente"
fi
