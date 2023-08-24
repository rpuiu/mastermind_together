#!/bin/bash
set -e

IP="49.13.53.30"
HOST="root@$IP:/var/www/mmt"

echo "Setting up permissions for SSH key..."
chmod 600 ./id_rsa

echo "Building Flutter app..."
flutter clean
flutter build web --target=lib/main_prod.dart --web-renderer canvaskit

if [ $? -ne 0 ]; then
    echo "Flutter build failed"
    exit 1
fi

echo "Deleting old files..."
ssh -i ./id_rsa -o StrictHostKeyChecking=no root@$IP 'rm -rf /var/www/mmt/*'

echo "Deploying to $HOST..."
scp -i ./id_rsa -o StrictHostKeyChecking=no -r ./build/web/* $HOST

if [ $? -ne 0 ]; then
    echo "SCP failed"
    exit 1
fi

echo "Restarting Nginx..."
ssh -i ./id_rsa -o StrictHostKeyChecking=no root@$IP 'sudo service nginx restart'

if [ $? -ne 0 ]; then
    echo "Failed to restart Nginx"
    exit 1
fi

echo "Deployment successful!"
