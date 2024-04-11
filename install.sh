#!/usr/bin/env bash
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
  STATUS_LOCAL=0

  while  [ $STATUS_LOCAL -le 0 ]; do
    if [ ! -d "$DIR_LOCAL" ]; then
      echo "Directorio Provisioning no existe"
      mkdir -p "$DIR_LOCAL"
      echo "Directorio provisioning Creado"
      STATUS_LOCAL=0
    else
      echo "Directorio Provisioning si existe"
      if [ ! -f "$DIR_LOCAL/$SCRIPT_LOCAL" ]; then
        echo "Archivo $SCRIPT_LOCAL no existe"
        curl -o "$DIR_LOCAL/$SCRIPT_LOCAL" https://raw.githubusercontent.com/GorillaTi/provisioning/main/provisioning.sh && \
        chmod 754 "$DIR_LOCAL/$SCRIPT_LOCAL"
        STATUS_LOCAL=0
      else
        echo "Archivo $SCRIPT_LOCAL si existe"
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
