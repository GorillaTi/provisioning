#!/usr/bin/env bash
# Autor: Edmundo Cespedes A.
# Licencia: GNU GPLv2
# Nombre: Update OS
# Version: 1.0.0
# FUNCION:
# Actualizacion del Sistema operativo e instalacion de herramientas basicas
# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
declare DISTRO
declare OS_TYPE
declare VER_DISTRO
declare ST_D
declare DIR_D
declare SCRIPT_D
# ------------------------------------------------------------------------------
# DEPENDENCIAS
# ------------------------------------------------------------------------------
# Insertando dependencias
ST_D=0
DIR_D="./tools/"
SCRIPT_D="os_detect.sh"

while [ $ST_D -le 0 ]; do
  if [ -f "$DIR_D$SCRIPT_D" ]; then
    source "./tools/os_detect.sh"
    ST_D=1
  else
    curl -o "$DIR_D$SCRIPT_D" https://raw.githubusercontent.com/GorillaTi/provisioning/main/tools/os_detect.sh
    ST_D=0
  fi
done
# ------------------------------------------------------------------------------
# FUNCIONES
# ------------------------------------------------------------------------------
# Funcion de deteccion de distribucion de linux y su version
#f_os_detect() {
#  local -a DISTRIBUTIONS=( "Fedora" "RedHat" "CenOS" "AlmaLinux" "RockiLinux" "Debian" "Ubuntu")
#  local D_LOCAL
#  local OST_LOCAL
#  local VD_LOCAL
#
#  for i in "${DISTRIBUTIONS[@]}"; do
#    OST_LOCAL=0
#    D_LOCAL=$(cat /etc/*-release | grep "NAME" | grep -o -m1 -i "$i")
#
#    if [ -n "$D_LOCAL" ]; then
#      # Asignado valores a variable global DISTRO
#      DISTRO="$D_LOCAL"
#      VD_LOCAL=$(grep VERSION_ID /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')
#      break;
#    fi
#  done
#  # Asignado tipo de distribucion
#  case $DISTRO in
#    Fedora | RedHat | CenOS | AlmaLinux | RockiLinux)
#      OST_LOCAL=1; 
#    ;;
#    Debian | Ubuntu)
#      OST_LOCAL=2; 
#    ;;
#    *)
#      echo "Sistema operativo desconocido";
#      exit;
#    ;;
#  esac
#  # Asignado valores a variable global OS_TYPE y VER_DISTRO
#  OS_TYPE=$OST_LOCAL
#  VER_DISTRO=$VD_LOCAL
#  echo "Sistema Operativo indetificado como: $DISTRO $VER_DISTRO"
#}

f_install_basic_tools() {
    echo Instalando " $DISTRO $VER_DISTRO"
    case $OS_TYPE in
        1)
            sudo dnf upgrade -y && \
            sudo dnf install -y vim \
              curl \
              wget \
              dnf-utils \
              git \
              net-tools \
              bind-utils
        ;;
        2)
            sudo apt update && sudo apt upgrade -y && \
            sudo apt install -y vim \
              curl \
              wget \
              net-tools \
              bind9utils
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
# Detectando Sistema Operativo
f_os_detect
# Isntalando las herramientas basicas
f_install_basic_tools
