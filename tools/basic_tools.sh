#!/usr/bin/env bash
# Autor: Edmundo Cespedes A.
# Licencia: GNU GPLv2
# Nombre: Provisioning
# Version: 1.0.0
# FUNCION:
# Actualizacion del Sistema operativo e instalacion de herramientas basicas
# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
declare -a DISTRIBUTIONS=( "Fedora" "RedHat" "CenOS" "AlmaLinux" "RockiLinux" "Debian" "Ubuntu")
declare DISTRO
declare OS_TYPE
declare VER_DISTRO

# ------------------------------------------------------------------------------
# FUNCIONES
# ------------------------------------------------------------------------------
# Funcion de deteccion de distribucion de linux y su version
f_os_detect() {
  local D_LOCAL
  local OST_LOCAL
  local VD_LOCAL

  for i in "${DISTRIBUTIONS[@]}"; do
    OST_LOCAL=0
    D_LOCAL=$(cat /etc/*-release | grep "NAME" | grep -o -m1 -i "$i")

    if [ -n "$D_LOCAL" ]; then
      # Asignado valores a variable global DISTRO
      DISTRO="$D_LOCAL"
      VD_LOCAL=$(grep VERSION_ID /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')
      break;
    fi
  done
  # Asignado tipo de distribucion
  case $DISTRO in
    Fedora | RedHat | CenOS | AlmaLinux | RockiLinux)
      OST_LOCAL=1; 
    ;;
    Debian | Ubuntu)
      OST_LOCAL=2; 
    ;;
    *)
      echo "Sistema operativo desconocido";
      exit;
    ;;
  esac
  # Asignado valores a variable global OS_TYPE y VER_DISTRO
  OS_TYPE=$OST_LOCAL
  VER_DISTRO=$VD_LOCAL
  echo "Sistema Operativo indetificado como: $DISTRO $VER_DISTRO"
}

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
