#!/usr/bin/env node

// **SCRIPT DE DEBUG PARA UI - MYLIBRARY** 🔍
// Este script proporciona información útil para debuggear la UI

const admin = require('firebase-admin');

// Configuración para el emulador local
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';

// Inicializar Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'univalle-mylibrary'
  });
}

const db = admin.firestore();

async function debugUI() {
  console.log('🔍 DEBUG DE LA UI DE FIREBASE EMULATOR\n');
  
  console.log('📋 Información de Configuración:');
  console.log(`   Proyecto: univalle-mylibrary`);
  console.log(`   Firestore: localhost:8080`);
  console.log(`   UI: http://localhost:4000`);
  console.log('');
  
  try {
    // Listar todas las colecciones de primer nivel
    console.log('📁 Colecciones de primer nivel:');
    
    const collections = ['users', 'libraries', 'reviews'];
    const results = {};
    
    for (const collectionName of collections) {
      const snapshot = await db.collection(collectionName).get();
      results[collectionName] = snapshot.size;
      console.log(`   ${collectionName}: ${snapshot.size} documentos`);
      
      // Mostrar algunos IDs de ejemplo
      if (!snapshot.empty) {
        const sampleIds = snapshot.docs.slice(0, 3).map(doc => doc.id);
        console.log(`      Ejemplos: ${sampleIds.join(', ')}`);
      }
    }
    
    // Verificar subcollecciones en libraries
    console.log('\n📚 Subcollecciones en libraries:');
    const librariesSnapshot = await db.collection('libraries').get();
    
    for (const libraryDoc of librariesSnapshot.docs) {
      const booksSnapshot = await libraryDoc.ref.collection('books').get();
      console.log(`   ${libraryDoc.id}/books: ${booksSnapshot.size} documentos`);
      
      if (!booksSnapshot.empty) {
        const bookTitles = booksSnapshot.docs.map(doc => doc.data().titulo);
        console.log(`      Libros: ${bookTitles.join(', ')}`);
      }
    }
    
    // Verificar que los datos se pueden leer
    console.log('\n✅ Verificación de accesibilidad de datos:');
    
    // Probar lectura de un usuario específico
    const userDoc = await db.collection('users').doc('demo-user-1').get();
    if (userDoc.exists) {
      console.log(`   ✅ Usuario demo-user-1 accesible: ${userDoc.data().nombre}`);
    } else {
      console.log(`   ❌ Usuario demo-user-1 no encontrado`);
    }
    
    // Probar lectura de una librería específica
    const libraryDoc = await db.collection('libraries').doc('demo-user-1').get();
    if (libraryDoc.exists) {
      console.log(`   ✅ Librería demo-user-1 accesible: ${libraryDoc.data().totalLibros} libros`);
    } else {
      console.log(`   ❌ Librería demo-user-1 no encontrada`);
    }
    
    console.log('\n🌐 Para ver en la UI:');
    console.log('   1. Abre: http://localhost:4000');
    console.log('   2. Ve a la pestaña "Firestore"');
    console.log('   3. Asegúrate de estar en la pestaña "Data"');
    console.log('   4. Deberías ver las colecciones: users, libraries, reviews');
    console.log('   5. Haz clic en cada colección para expandir y ver los documentos');
    
    if (Object.values(results).every(count => count > 0)) {
      console.log('\n🎉 Todos los datos están presentes. Si no aparecen en la UI:');
      console.log('   • Refresca la página (F5)');
      console.log('   • Verifica que estés en el proyecto "univalle-mylibrary"');
      console.log('   • Limpia el cache del navegador');
      console.log('   • Reinicia los emuladores si es necesario');
    } else {
      console.log('\n❌ Faltan algunos datos. Ejecuta: npm run seed');
    }
    
  } catch (error) {
    console.error('\n❌ Error durante el debug:', error.message);
    console.log('\n💡 Verifica que los emuladores estén corriendo: npm run start');
  }
  
  process.exit();
}

if (require.main === module) {
  debugUI();
}

module.exports = { debugUI };