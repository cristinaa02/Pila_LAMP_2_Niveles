#!/bin/bash

# Script para el servidor web Apache (CrisAlmApache).

DB_HOST="$1" # IP 192.168.50.11 del servidor de la BD.
DB_NAME="lamp_db" # Nombre de la BD que se creará.
DB_USER="user" # Usuario para conectar la BD.
DB_PASS="pass" # Contraseña para conectar la BD.
WEB_ROUTE="/var/www/html"


# Actualizar el sistema.
sudo apt update
# Instalar Apache, PHP, el módulo de MySQL y git.
sudo apt install apache2 php libapache2-mod-php php-mysql -y

# Navegar hasta el directorio donde guardar los archivos.
cd "$WEB_ROUTE"
sudo rm -f index.html # Borrar index.html de apache por defecto

sudo cp -r /vagrant/src/* . # Copiar los archivos necesarios al directorio actual.

# Permisos para acceder a los archivos.
sudo chown -R www-data:www-data "$WEB_ROUTE"
sudo chmod -R 755 "$WEB_ROUTE"

# Configuración de la Aplicación.
CONFIG_FILE="$WEB_ROUTE/config.php"

if [ -f "$CONFIG_FILE" ]; then
    # 1. Reemplazamos 'localhost' por la IP privada de MySQL ($DB_HOST).
    sudo sed -i "s/localhost/$DB_HOST/g" "$CONFIG_FILE"
    # 2. Reemplazamos el nombre de la BD por el nombre real.
    sudo sed -i "s/database_name_here/$DB_NAME/g" "$CONFIG_FILE"
    # 3. Reemplazamos el usuario por el usuario de la aplicación.
    sudo sed -i "s/username_here/$DB_USER/g" "$CONFIG_FILE"
    # 4. Reemplazar la contraseña por la contraseña de la aplicación.
    sudo sed -i "s/password_here/$DB_PASS/g" "$CONFIG_FILE"
else
    echo "ERROR: Archivo $CONFIG_FILE no encontrado."
fi

# Habilitar el módulo rewrite y reiniciar Apache
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "Aprovisionamiento de Apache finalizado"