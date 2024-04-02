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
  DIR_LOCAL="$PWD/provisionings"
  if [[ -n $DIR_LOCAL ]]; then
    echo "Directorio Provisioning no existe"
  else
    echo "Directorio Provisioning no existe"
  fi
}
# ------------------------------------------------------------------------------
# SCRIPT
# ------------------------------------------------------------------------------
f_install
