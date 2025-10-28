#!/bin/bash

# Script para el servidor de MySQL (CrisAlmMysql). 

APACHE_HOST="$1" # IP del servidor Apache (192.168.50.10)
DB_NAME="lamp_db" # Nombre de la BD que se creará.
DB_USER="user" # Usuario para conectar la BD.
DB_PASS="pass" # Contraseña para conectar la BD.

SQL_FILE="/vagrant/db/database.sql"

# Actualizar sistema e instalar MariaDB.
sudo apt update
sudo apt install mariadb-server -y

# Configurando MySQL para escuchar en 0.0.0.0.
sudo sed -i "s/^bind-address.*127.0.0.1/bind-address = 0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

# Creando la BD y usuario.
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARSET utf8mb4;
CREATE USER '$DB_USER'@'$APACHE_HOST' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$APACHE_HOST';
FLUSH PRIVILEGES;
EOF
echo "Usuario: $DB_USER"
echo "Contraseña: $DB_PASS"
echo "Creada la BD con acceso a $APACHE_HOST."

# Importando el archivo sql del repositorio.
if [ -f "$SQL_FILE" ]; then
    sudo mysql -u root $DB_NAME < "$SQL_FILE"
else
    echo "ERROR: Archivo $SQL_FILE no encontrado."
fi

echo "Aprovisionamiento de MySQL finalizado"