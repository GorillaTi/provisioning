#!/bin/bash
# Autor: Edmundo Cespedes A.
# Licencia: GNU GPLv2
# Nombre: Install Provisioning
# Version: 1.0.0
# FUNCION:
# Instalador del script de aprovisionamiento
# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# FUNCIONES
# ------------------------------------------------------------------------------
f_install() {
  local DIR_LOCAL
  local SCRIPT_LOCAL
  local STATUS_LOCAL
  DIR_LOCAL="$PWD/provisioning"
  SCRIPT_LOCAL="provisioning.sh"

  while  [ "$STATUS_LOCAL" == 1 ]; do
    if [ -n "$DIR_LOCAL" ]; then
      echo "Directorio Provisioning no existe"
      mkdir -p "$DIR_LOCAL"
      STATUS_LOCAL=0
    else
      echo "Directorio Provisioning si existe"
      if [ ! -f "$DIR_LOCAL/$SCRIPT_LOCAL" ]; then
        curl -o "$DIR_LOCAL/$SCRIPT_LOCAL https://github.com/GorillaTi/Provisioning/raw/main/provisioning.sh"
        STATUS_LOCAL=0
      else
        sh -c "($DIR_LOCAL/$SCRIPT_LOCAL)"
        STATUS_LOCAL=1
      fi
    fi
  done
}
# ------------------------------------------------------------------------------
# SCRIPT
# ------------------------------------------------------------------------------
f_install
