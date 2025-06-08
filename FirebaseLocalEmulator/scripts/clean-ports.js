#!/usr/bin/env node

// **SCRIPT DE LIMPIEZA DE PUERTOS - MYLIBRARY** 🧹
// Este script verifica y limpia los puertos usados por Firebase Emulators

const { spawn, exec } = require('child_process');
const util = require('util');

const execAsync = util.promisify(exec);

// Puertos utilizados por Firebase Emulators
const FIREBASE_PORTS = [
  { port: 4000, name: 'Firebase UI' },
  { port: 8080, name: 'Firestore Emulator' },
  { port: 9099, name: 'Auth Emulator' },
  { port: 9199, name: 'Storage Emulator' }
];

// Función para verificar si un puerto está en uso
async function checkPort(port) {
  try {
    const { stdout } = await execAsync(`lsof -ti:${port}`);
    return stdout.trim().split('\n').filter(pid => pid);
  } catch (error) {
    // No hay procesos usando el puerto
    return [];
  }
}

// Función para matar procesos en un puerto
async function killProcessesOnPort(port) {
  try {
    await execAsync(`lsof -ti:${port} | xargs kill -9`);
    return true;
  } catch (error) {
    // No hay procesos para matar o error
    return false;
  }
}

// Función para verificar y mostrar el estado de los puertos
async function checkAllPorts() {
  console.log('🔍 Verificando puertos de Firebase Emulators...\n');
  
  const portsInUse = [];
  
  for (const { port, name } of FIREBASE_PORTS) {
    const processes = await checkPort(port);
    
    if (processes.length > 0) {
      console.log(`❌ Puerto ${port} (${name}) está ocupado por PIDs: ${processes.join(', ')}`);
      portsInUse.push({ port, name, processes });
    } else {
      console.log(`✅ Puerto ${port} (${name}) está libre`);
    }
  }
  
  return portsInUse;
}

// Función para limpiar puertos ocupados
async function cleanPorts(portsInUse) {
  if (portsInUse.length === 0) {
    console.log('\n🎉 Todos los puertos están libres. No hay nada que limpiar.');
    return;
  }
  
  console.log('\n🧹 Limpiando puertos ocupados...\n');
  
  for (const { port, name } of portsInUse) {
    console.log(`🔧 Liberando puerto ${port} (${name})...`);
    
    const killed = await killProcessesOnPort(port);
    
    if (killed) {
      console.log(`✅ Puerto ${port} liberado exitosamente`);
    } else {
      console.log(`⚠️  No se pudo liberar el puerto ${port} (puede que ya esté libre)`);
    }
  }
}

// Función para verificar después de la limpieza
async function verifyCleanup() {
  console.log('\n🔍 Verificando estado final de los puertos...\n');
  
  const remainingPorts = await checkAllPorts();
  
  if (remainingPorts.length === 0) {
    console.log('\n🎉 ¡Todos los puertos están ahora libres!');
    console.log('💡 Puedes iniciar los emuladores con: npm run start');
  } else {
    console.log('\n⚠️  Algunos puertos siguen ocupados:');
    remainingPorts.forEach(({ port, name }) => {
      console.log(`   - Puerto ${port} (${name})`);
    });
    console.log('\n💡 Intenta cerrar manualmente las aplicaciones que usan estos puertos.');
  }
}

// Función principal
async function main() {
  const args = process.argv.slice(2);
  const checkOnly = args.includes('--check') || args.includes('-c');
  const forceClean = args.includes('--force') || args.includes('-f');
  
  console.log('🔧 Script de Limpieza de Puertos Firebase\n');
  
  try {
    // Verificar estado inicial
    const portsInUse = await checkAllPorts();
    
    if (checkOnly) {
      // Solo verificar, no limpiar
      console.log('\n📊 Verificación completada (modo solo lectura)');
      process.exit(portsInUse.length > 0 ? 1 : 0);
    }
    
    if (portsInUse.length === 0) {
      console.log('\n🎉 Todos los puertos están libres. Los emuladores pueden iniciarse.');
      process.exit(0);
    }
    
    if (!forceClean) {
      // Preguntar confirmación
      console.log('\n❓ ¿Deseas limpiar los puertos ocupados? (y/N)');
      
      process.stdin.setRawMode(true);
      process.stdin.resume();
      process.stdin.once('data', async (data) => {
        const input = data.toString().trim().toLowerCase();
        
        if (input === 'y' || input === 'yes' || input === 'sí' || input === 's') {
          await cleanPorts(portsInUse);
          await verifyCleanup();
        } else {
          console.log('\n⏹️  Limpieza cancelada.');
          console.log('💡 Usa --force para limpiar sin confirmación');
        }
        
        process.exit(0);
      });
    } else {
      // Limpiar sin confirmación
      await cleanPorts(portsInUse);
      await verifyCleanup();
    }
    
  } catch (error) {
    console.error('\n❌ Error durante la limpieza:', error.message);
    process.exit(1);
  }
}

// Mostrar ayuda
function showHelp() {
  console.log(`
🔧 Script de Limpieza de Puertos Firebase

Uso:
  node clean-ports.js [opciones]

Opciones:
  --check, -c    Solo verificar puertos, no limpiar
  --force, -f    Limpiar sin confirmación
  --help, -h     Mostrar esta ayuda

Ejemplos:
  node clean-ports.js              # Verificar y preguntar antes de limpiar
  node clean-ports.js --check      # Solo verificar estado
  node clean-ports.js --force      # Limpiar inmediatamente

Puertos monitoreados:
  4000  - Firebase UI
  8080  - Firestore Emulator  
  9099  - Auth Emulator
  9199  - Storage Emulator
`);
}

// Verificar argumentos de ayuda
if (process.argv.includes('--help') || process.argv.includes('-h')) {
  showHelp();
  process.exit(0);
}

// Ejecutar función principal
if (require.main === module) {
  main();
}

module.exports = { checkAllPorts, cleanPorts, verifyCleanup };