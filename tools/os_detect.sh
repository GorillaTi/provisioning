#!/usr/bin/env bash
# Autor: Edmundo Cespedes A.
# Licencia: GNU GPLv2
# Nombre: OS Detected
# Version: 1.0.0
# FUNCION:
# Deteccion de la distribucion y version del Sistema Operativo
# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# FUNCIONES
# ------------------------------------------------------------------------------
# Funcion de deteccion de distribucion de linux y su version
f_os_detect() {
  local -a DISTRIBUTIONS=( "Fedora" "RedHat" "CenOS" "AlmaLinux" "RockiLinux" "Debian" "Ubuntu")
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
  echo "Sistema Operativo indetificado como ($OS_TYPE): $DISTRO $VER_DISTRO"
}
# ------------------------------------------------------------------------------
# SCRIPT
# ------------------------------------------------------------------------------
# Reconociendo el sistema operativo
f_os_detect
