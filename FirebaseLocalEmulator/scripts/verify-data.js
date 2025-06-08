#!/usr/bin/env node

// **SCRIPT DE VERIFICACIÓN DE DATOS - MYLIBRARY** 🔍
// Este script verifica que los datos de ejemplo se crearon correctamente

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

// Función para verificar usuarios
async function verifyUsers() {
  console.log('👥 Verificando usuarios...');
  
  try {
    const usersSnapshot = await db.collection('users').get();
    
    if (usersSnapshot.empty) {
      console.log('   ❌ No se encontraron usuarios');
      return false;
    }
    
    console.log(`   ✅ ${usersSnapshot.size} usuarios encontrados:`);
    
    usersSnapshot.forEach(doc => {
      const userData = doc.data();
      console.log(`      - ${doc.id}: ${userData.nombre} ${userData.apellido} (${userData.email})`);
    });
    
    return true;
    
  } catch (error) {
    console.log('   ❌ Error verificando usuarios:', error.message);
    return false;
  }
}

// Función para verificar librerías
async function verifyLibraries() {
  console.log('\n📚 Verificando librerías personales...');
  
  try {
    const librariesSnapshot = await db.collection('libraries').get();
    
    if (librariesSnapshot.empty) {
      console.log('   ❌ No se encontraron librerías');
      return false;
    }
    
    console.log(`   ✅ ${librariesSnapshot.size} librerías encontradas:`);
    
    for (const libraryDoc of librariesSnapshot.docs) {
      console.log(`      📖 Librería de usuario: ${libraryDoc.id}`);
      
      const booksSnapshot = await libraryDoc.ref.collection('books').get();
      console.log(`         - ${booksSnapshot.size} libros:`);
      
      booksSnapshot.forEach(bookDoc => {
        const bookData = bookDoc.data();
        console.log(`           * ${bookData.titulo} - ${bookData.autor}`);
      });
    }
    
    return true;
    
  } catch (error) {
    console.log('   ❌ Error verificando librerías:', error.message);
    return false;
  }
}

// Función para verificar reseñas
async function verifyReviews() {
  console.log('\n⭐ Verificando reseñas...');
  
  try {
    const reviewsSnapshot = await db.collection('reviews').get();
    
    if (reviewsSnapshot.empty) {
      console.log('   ❌ No se encontraron reseñas');
      return false;
    }
    
    console.log(`   ✅ ${reviewsSnapshot.size} reseñas encontradas:`);
    
    reviewsSnapshot.forEach(doc => {
      const reviewData = doc.data();
      console.log(`      - ${doc.id}: ${reviewData.calificacion}⭐ para libro ${reviewData.bookId}`);
      console.log(`        "${reviewData.textoReseña.substring(0, 80)}..."`);
    });
    
    return true;
    
  } catch (error) {
    console.log('   ❌ Error verificando reseñas:', error.message);
    return false;
  }
}

// Función para mostrar estadísticas generales
async function showStatistics() {
  console.log('\n📊 Estadísticas de la base de datos:');
  
  try {
    const collections = ['users', 'libraries', 'reviews'];
    
    for (const collectionName of collections) {
      const snapshot = await db.collection(collectionName).get();
      console.log(`   ${collectionName}: ${snapshot.size} documentos`);
    }
    
    // Contar libros en total
    let totalBooks = 0;
    const librariesSnapshot = await db.collection('libraries').get();
    
    for (const libraryDoc of librariesSnapshot.docs) {
      const booksSnapshot = await libraryDoc.ref.collection('books').get();
      totalBooks += booksSnapshot.size;
    }
    
    console.log(`   libros (subcollection): ${totalBooks} documentos`);
    
  } catch (error) {
    console.log('   ❌ Error obteniendo estadísticas:', error.message);
  }
}

// Función para verificar conectividad
async function checkConnectivity() {
  console.log('🔗 Verificando conectividad con emuladores...');
  
  try {
    // Intentar una operación simple
    await db.collection('_test').doc('connectivity').set({ 
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      test: true 
    });
    
    await db.collection('_test').doc('connectivity').delete();
    
    console.log('   ✅ Conectividad con Firestore OK');
    return true;
    
  } catch (error) {
    console.log('   ❌ Error de conectividad:', error.message);
    console.log('   💡 Verifica que los emuladores estén corriendo: npm run start');
    return false;
  }
}

// Función principal
async function main() {
  console.log('🔍 VERIFICACIÓN DE DATOS - MYLIBRARY\n');
  
  try {
    // Verificar conectividad primero
    const connected = await checkConnectivity();
    if (!connected) {
      console.log('\n❌ No se puede conectar a los emuladores');
      process.exit(1);
    }
    
    // Verificar cada tipo de dato
    const usersOK = await verifyUsers();
    const librariesOK = await verifyLibraries();
    const reviewsOK = await verifyReviews();
    
    // Mostrar estadísticas
    await showStatistics();
    
    // Resultado final
    console.log('\n🎯 RESULTADO DE LA VERIFICACIÓN:');
    
    if (usersOK && librariesOK && reviewsOK) {
      console.log('✅ Todos los datos se crearon correctamente');
      console.log('🌐 Puedes verlos en la UI: http://localhost:4000');
      console.log('📱 La app puede conectarse y mostrar los datos');
    } else {
      console.log('❌ Algunos datos no se encontraron');
      console.log('💡 Ejecuta el seeding nuevamente: npm run seed');
    }
    
  } catch (error) {
    console.error('\n❌ Error durante la verificación:', error);
  } finally {
    process.exit();
  }
}

// Ejecutar verificación
if (require.main === module) {
  main();
}

module.exports = { verifyUsers, verifyLibraries, verifyReviews, showStatistics };