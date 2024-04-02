# Provisioning

Script de Aprovisionamiento para servidores GNU/Linux. el cual reconoce la distribución del Sistema Operativo y conforme a ello da la mejor opción de instalación para solucione requeridas.

## Instalación

### Usando el Script de instalación

Usando `curl`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/GorillaTi/provisioning/main/install.sh)"    
```

Usando `wget`

```bash
sh -c "$(wget  -O -)"
```

### Volver a ejecutar el Script

Ingresamos al directorio `provisioning` 

```bash
cd provisioning
```

Ejecutar el script

```bash
./provisioning
```

## Scripts de Aprovisionamiento

- Provisioning - Script principal para el aprovisionamiento
- OS_Update- Actualización del Sistema Operativo
- PHP Provisioning - Script de aprovisionamiento de  php
