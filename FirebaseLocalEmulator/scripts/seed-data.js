const admin = require('firebase-admin');

// **SCRIPT EDUCATIVO DE DATOS DE PRUEBA - MYLIBRARY** 📚
// Este script demuestra cómo poblar Firestore con datos de ejemplo

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
const auth = admin.auth();

// **DATOS DE EJEMPLO EDUCATIVOS**
const seedData = {
  // Usuarios de ejemplo para testing
  users: [
    {
      id: 'demo-user-1',
      email: 'estudiante1@example.com',
      nombre: 'Ana',
      apellido: 'García',
      fotoPerfilUrl: null,
      fechaCreacion: admin.firestore.FieldValue.serverTimestamp(),
      fechaUltimaActividad: admin.firestore.FieldValue.serverTimestamp()
    },
    {
      id: 'demo-user-2',
      email: 'estudiante2@example.com',
      nombre: 'Carlos',
      apellido: 'Rodríguez',
      fotoPerfilUrl: null,
      fechaCreacion: admin.firestore.FieldValue.serverTimestamp(),
      fechaUltimaActividad: admin.firestore.FieldValue.serverTimestamp()
    },
    {
      id: 'demo-app-user',
      email: 'demo@mylibrary.com',
      nombre: 'Usuario',
      apellido: 'Demo',
      fotoPerfilUrl: null,
      fechaCreacion: admin.firestore.FieldValue.serverTimestamp(),
      fechaUltimaActividad: admin.firestore.FieldValue.serverTimestamp()
    }
  ],

  // Libros de ejemplo en las librerías personales
  libraryBooks: [
    {
      userId: 'demo-user-1',
      books: [
        {
          id: 'book-1',
          bookId: 'nggnmAEACAAJ',
          titulo: 'The Linux Command Line',
          autor: 'William E. Shotts Jr.',
          portadaUrl: 'http://books.google.com/books/content?id=nggnmAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api',
          fechaAgregado: admin.firestore.FieldValue.serverTimestamp(),
          tieneReseña: true
        },
        {
          id: 'book-2',
          bookId: 'PXa2bby0oQ0C',
          titulo: 'JavaScript: The Good Parts',
          autor: 'Douglas Crockford',
          portadaUrl: 'http://books.google.com/books/content?id=PXa2bby0oQ0C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api',
          fechaAgregado: admin.firestore.FieldValue.serverTimestamp(),
          tieneReseña: false
        }
      ]
    },
    {
      userId: 'demo-user-2',
      books: [
        {
          id: 'book-3',
          bookId: 'qU_oDwAAQBAJ',
          titulo: 'React: Up & Running',
          autor: 'Stoyan Stefanov',
          portadaUrl: 'http://books.google.com/books/content?id=qU_oDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api',
          fechaAgregado: admin.firestore.FieldValue.serverTimestamp(),
          tieneReseña: true
        }
      ]
    }
  ],

  // Reseñas de ejemplo
  reviews: [
    {
      id: 'review-1',
      userId: 'demo-user-1',
      bookId: 'nggnmAEACAAJ',
      calificacion: 5,
      textoReseña: 'Excelente libro para aprender la línea de comandos de Linux. Muy didáctico y con ejemplos prácticos.',
      fechaCreacion: admin.firestore.FieldValue.serverTimestamp(),
      fechaModificacion: admin.firestore.FieldValue.serverTimestamp()
    },
    {
      id: 'review-2',
      userId: 'demo-user-2',
      bookId: 'qU_oDwAAQBAJ',
      calificacion: 4,
      textoReseña: 'Buen punto de partida para React. Los ejemplos son claros aunque algunos conceptos podrían estar más actualizados.',
      fechaCreacion: admin.firestore.FieldValue.serverTimestamp(),
      fechaModificacion: admin.firestore.FieldValue.serverTimestamp()
    }
  ]
};

// **FUNCIÓN PRINCIPAL DE SEEDING**
async function seedDatabase() {
  console.log('🌱 Iniciando el seeding de la base de datos...');

  try {
    // 1. Crear usuarios en Firebase Authentication
    console.log('🔐 Creando usuarios en Authentication...');
    for (const user of seedData.users) {
      try {
        const authUser = await auth.createUser({
          uid: user.id,
          email: user.email,
          password: 'demo123456', // Contraseña para testing
          displayName: `${user.nombre} ${user.apellido}`,
          emailVerified: true
        });
        console.log(`   ✅ Usuario Auth creado: ${authUser.email}`);
      } catch (error) {
        if (error.code === 'auth/uid-already-exists') {
          console.log(`   ♻️ Usuario Auth ya existe: ${user.email}`);
        } else {
          console.error(`   ❌ Error creando usuario Auth ${user.email}:`, error.message);
        }
      }
    }

    // 2. Crear documentos de usuarios en Firestore
    console.log('👥 Creando documentos de usuarios en Firestore...');
    for (const user of seedData.users) {
      await db.collection('users').doc(user.id).set(user);
      console.log(`   ✅ Documento de usuario creado: ${user.email}`);
    }

    // 3. Crear librerías personales
    console.log('📚 Creando librerías personales...');
    for (const library of seedData.libraryBooks) {
      // Primero crear el documento padre de la librería
      await db
        .collection('libraries')
        .doc(library.userId)
        .set({
          userId: library.userId,
          fechaCreacion: admin.firestore.FieldValue.serverTimestamp(),
          totalLibros: library.books.length
        });
      console.log(`   ✅ Librería creada para usuario: ${library.userId}`);
      
      // Luego agregar los libros a la subcollección
      for (const book of library.books) {
        await db
          .collection('libraries')
          .doc(library.userId)
          .collection('books')
          .doc(book.id)
          .set(book);
        console.log(`   ✅ Libro agregado: ${book.titulo} para usuario ${library.userId}`);
      }
    }

    // 4. Crear reseñas de ejemplo
    console.log('⭐ Creando reseñas de ejemplo...');
    for (const review of seedData.reviews) {
      await db.collection('reviews').doc(review.id).set(review);
      console.log(`   ✅ Reseña creada para libro ${review.bookId}`);
    }

    console.log('🎉 ¡Seeding completado exitosamente!');
    console.log('💡 Puedes ver los datos en la UI del emulador: http://localhost:4000');
    console.log('');
    console.log('👤 Usuarios de prueba creados:');
    console.log('   📧 estudiante1@example.com - Contraseña: demo123456');
    console.log('   📧 estudiante2@example.com - Contraseña: demo123456');
    console.log('   📧 demo@mylibrary.com - Contraseña: demo123456 (para app)');
    console.log('');
    console.log('🔍 Para verificar:');
    console.log('   • Authentication: http://localhost:4000 → Authentication');
    console.log('   • Firestore: http://localhost:4000 → Firestore → Data');
    
  } catch (error) {
    console.error('❌ Error durante el seeding:', error);
  } finally {
    process.exit();
  }
}

// Ejecutar el seeding
if (require.main === module) {
  seedDatabase();
}

module.exports = { seedDatabase, seedData };