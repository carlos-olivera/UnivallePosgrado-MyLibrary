const admin = require('firebase-admin');

// **SCRIPT EDUCATIVO DE DATOS DE PRUEBA - MYLIBRARY** 📚
// Este script demuestra cómo poblar Firestore con datos de ejemplo

// Configuración para el emulador local
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';

// Inicializar Firebase Admin SDK
admin.initializeApp({
  projectId: 'mylibrary-demo'
});

const db = admin.firestore();

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
    // 1. Crear usuarios de ejemplo
    console.log('👥 Creando usuarios de ejemplo...');
    for (const user of seedData.users) {
      await db.collection('users').doc(user.id).set(user);
      console.log(`   ✅ Usuario creado: ${user.email}`);
    }

    // 2. Crear librerías personales
    console.log('📚 Creando librerías personales...');
    for (const library of seedData.libraryBooks) {
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

    // 3. Crear reseñas de ejemplo
    console.log('⭐ Creando reseñas de ejemplo...');
    for (const review of seedData.reviews) {
      await db.collection('reviews').doc(review.id).set(review);
      console.log(`   ✅ Reseña creada para libro ${review.bookId}`);
    }

    console.log('🎉 ¡Seeding completado exitosamente!');
    console.log('💡 Puedes ver los datos en la UI del emulador: http://localhost:4000');
    
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