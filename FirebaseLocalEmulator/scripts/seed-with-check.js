#!/usr/bin/env node

// **SCRIPT MEJORADO DE SEEDING CON VERIFICACIONES** 🔧
// Este script verifica que los emuladores estén funcionando antes de hacer seeding

const { spawn } = require('child_process');
const http = require('http');

// Función para verificar si un puerto está activo
function checkPort(port, host = 'localhost') {
  return new Promise((resolve) => {
    const req = http.request({ host, port, timeout: 2000 }, () => {
      resolve(true);
    });
    
    req.on('error', () => {
      resolve(false);
    });
    
    req.on('timeout', () => {
      resolve(false);
    });
    
    req.end();
  });
}

// Función principal
async function main() {
  console.log('🔍 Verificando que los emuladores estén activos...');
  
  // Verificar Firestore emulator
  const firestoreRunning = await checkPort(8080);
  const authRunning = await checkPort(9099);
  
  if (!firestoreRunning) {
    console.error('❌ El emulador de Firestore no está corriendo en el puerto 8080');
    console.log('💡 Ejecuta: npm run start en el directorio FirebaseLocalEmulator');
    process.exit(1);
  }
  
  if (!authRunning) {
    console.error('❌ El emulador de Authentication no está corriendo en el puerto 9099');
    console.log('💡 Ejecuta: npm run start en el directorio FirebaseLocalEmulator');
    process.exit(1);
  }
  
  console.log('✅ Emuladores verificados, procediendo con el seeding...');
  
  // Ejecutar el script de seeding
  const seedProcess = spawn('node', ['scripts/seed-data.js'], {
    stdio: 'inherit',
    cwd: process.cwd()
  });
  
  seedProcess.on('close', (code) => {
    if (code === 0) {
      console.log('🎉 Seeding completado exitosamente!');
      console.log('🌐 Revisa los datos en: http://localhost:4000');
    } else {
      console.error('❌ Error durante el seeding');
    }
    process.exit(code);
  });
}

main().catch(console.error);