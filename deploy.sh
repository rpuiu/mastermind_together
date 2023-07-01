#!/bin/bash
set -e

IP="49.13.53.30"
HOST="root@$IP:/var/www/mmt"

echo "Setting up permissions for SSH key..."
chmod 600 ./id_rsa

echo "Building Flutter app..."
flutter build web

if [ $? -ne 0 ]; then
    echo "Flutter build failed"
    exit 1
fi

echo "Deploying to $HOST..."
scp -i ./id_rsa -o StrictHostKeyChecking=no -r ./build/web $HOST

if [ $? -ne 0 ]; then
    echo "SCP failed"
    exit 1
fi

echo "Deployment successful!"
