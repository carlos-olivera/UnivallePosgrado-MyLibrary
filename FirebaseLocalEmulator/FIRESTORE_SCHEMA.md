# Esquema de Firestore - MyLibrary 📊

## Descripción Educativa
Este documento detalla la estructura de datos de Firestore para MyLibrary, diseñada con propósitos educativos para demostrar patrones comunes de bases de datos NoSQL.

## 🎯 Conceptos Clave Demostrados

- **Colecciones y Documentos**: Estructura jerárquica de NoSQL
- **Subcollections**: Organización anidada de datos relacionados
- **Timestamps**: Auditoría automática de fechas
- **Referencias**: Relaciones entre documentos
- **Índices**: Optimización de consultas
- **Validación**: Reglas de integridad de datos

---

## 📋 Estructura General

```
firestore
├── users/                          # Colección de usuarios
│   └── {userId}/                   # Documento por usuario
├── libraries/                      # Colección de librerías personales
│   └── {userId}/                   # Documento por usuario
│       └── books/                  # Subcollection de libros
│           └── {bookId}/          # Documento por libro
├── reviews/                        # Colección de reseñas
│   └── {reviewId}/                # Documento por reseña
└── system/                        # Colección de metadatos del sistema
    └── {configId}/               # Configuraciones globales
```

---

## 👥 Colección: `users`

### Propósito Educativo
Demuestra cómo almacenar perfiles de usuario con validación y estructura consistente.

### Estructura
```javascript
users/{userId} = {
  // Datos básicos del usuario
  email: string,              // ✅ Único, validado
  nombre: string,             // ✅ Requerido, 2-50 chars
  apellido: string,           // ✅ Requerido, 2-50 chars
  
  // Datos opcionales
  fotoPerfilUrl: string | null,  // URL de Firebase Storage
  
  // Metadatos de auditoría
  fechaCreacion: timestamp,      // ⏰ Auto-generado
  fechaUltimaActividad: timestamp // ⏰ Actualizado en cada login
}
```

### Ejemplo de Documento
```json
{
  "email": "ana.garcia@ejemplo.com",
  "nombre": "Ana",
  "apellido": "García",
  "fotoPerfilUrl": "gs://mylibrary-demo/profile-images/user123/avatar.jpg",
  "fechaCreacion": "2024-01-15T10:30:00Z",
  "fechaUltimaActividad": "2024-01-20T14:22:15Z"
}
```

### Consultas Educativas Comunes
```javascript
// Obtener perfil del usuario actual
db.collection('users').doc(currentUserId).get()

// Buscar usuarios por email (para validación de unicidad)
db.collection('users').where('email', '==', 'email@example.com').get()

// Obtener usuarios activos recientemente
db.collection('users')
  .where('fechaUltimaActividad', '>', last7Days)
  .orderBy('fechaUltimaActividad', 'desc')
  .get()
```

---

## 📚 Colección: `libraries` (con Subcollection)

### Propósito Educativo
Demuestra el patrón de **subcollections** para organizar datos jerárquicamente y mantener la escalabilidad.

### ¿Por qué Subcollections?
- ✅ **Escalabilidad**: Cada usuario puede tener miles de libros sin afectar el rendimiento
- ✅ **Seguridad**: Reglas de acceso más granulares
- ✅ **Organización**: Estructura lógica clara
- ✅ **Consultas**: Filtros eficientes por usuario

### Estructura Principal
```javascript
libraries/{userId} = {
  // Metadatos de la librería (opcional)
  totalLibros: number,        // Contador para UI
  fechaUltimaModificacion: timestamp,
  categoriasFavoritas: array  // Análisis de preferencias
}
```

### Subcollection: `books`
```javascript
libraries/{userId}/books/{bookId} = {
  // Identificación del libro (de la API externa)
  bookId: string,             // ✅ ID de la Books API
  
  // Datos básicos (cacheados de la API)
  titulo: string,             // ✅ Requerido
  autor: string,              // ✅ Requerido
  portadaUrl: string,         // URL de la imagen de portada
  
  // Metadatos de la librería personal
  fechaAgregado: timestamp,   // ⏰ Cuándo se agregó
  tieneReseña: boolean,       // ✅ Flag para UI optimizada
  
  // Datos opcionales (de la API)
  sinopsis?: string,
  anoPublicacion?: number,
  generos?: array,
  isbn?: string,
  editorial?: string
}
```

### Ejemplo de Documento
```json
{
  "bookId": "nggnmAEACAAJ",
  "titulo": "The Linux Command Line",
  "autor": "William E. Shotts Jr.",
  "portadaUrl": "http://books.google.com/books/content?id=nggnmAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
  "fechaAgregado": "2024-01-18T09:15:30Z",
  "tieneReseña": true,
  "sinopsis": "Una guía completa para dominar la línea de comandos...",
  "anoPublicacion": 2019,
  "generos": ["Tecnología", "Linux", "Programación"],
  "isbn": "9781593279523",
  "editorial": "No Starch Press"
}
```

### Consultas Educativas Comunes
```javascript
// Obtener todos los libros de un usuario
db.collection('libraries').doc(userId).collection('books').get()

// Libros agregados recientemente
db.collection('libraries').doc(userId).collection('books')
  .orderBy('fechaAgregado', 'desc')
  .limit(10)
  .get()

// Libros sin reseña (para sugerir al usuario)
db.collection('libraries').doc(userId).collection('books')
  .where('tieneReseña', '==', false)
  .get()

// Buscar libros por autor en la librería personal
db.collection('libraries').doc(userId).collection('books')
  .where('autor', '==', 'Douglas Crockford')
  .get()
```

---

## ⭐ Colección: `reviews`

### Propósito Educativo
Demuestra relaciones entre documentos y consultas complejas con múltiples filtros.

### Estructura
```javascript
reviews/{reviewId} = {
  // Referencias (clave para las relaciones)
  userId: string,             // ✅ Quién escribió la reseña
  bookId: string,             // ✅ Libro reseñado (de la API)
  
  // Contenido de la reseña
  calificacion: number,       // ✅ 1-5 estrellas
  textoReseña: string,        // ✅ Texto de la reseña (min 10 chars)
  
  // Metadatos de auditoría
  fechaCreacion: timestamp,   // ⏰ Cuándo se creó
  fechaModificacion: timestamp, // ⏰ Última edición
  
  // Datos opcionales para análisis
  dispositivo?: string,       // "mobile" | "web"
  version?: string           // Versión de la app
}
```

### Ejemplo de Documento
```json
{
  "userId": "demo-user-1",
  "bookId": "nggnmAEACAAJ",
  "calificacion": 5,
  "textoReseña": "Excelente libro para aprender la línea de comandos de Linux. Muy didáctico y con ejemplos prácticos que se pueden seguir fácilmente.",
  "fechaCreacion": "2024-01-19T16:45:20Z",
  "fechaModificacion": "2024-01-19T16:45:20Z",
  "dispositivo": "mobile",
  "version": "1.0.0"
}
```

### Consultas Educativas Comunes
```javascript
// Reseñas de un usuario específico
db.collection('reviews')
  .where('userId', '==', userId)
  .orderBy('fechaCreacion', 'desc')
  .get()

// Reseñas de un libro específico
db.collection('reviews')
  .where('bookId', '==', bookId)
  .orderBy('fechaCreacion', 'desc')
  .get()

// Reseñas con alta calificación (para destacar)
db.collection('reviews')
  .where('calificacion', '>=', 4)
  .orderBy('calificacion', 'desc')
  .orderBy('fechaCreacion', 'desc')
  .limit(10)
  .get()

// Verificar si el usuario ya reseñó un libro
db.collection('reviews')
  .where('userId', '==', userId)
  .where('bookId', '==', bookId)
  .get()
```

---

## ⚙️ Colección: `system`

### Propósito Educativo
Demuestra cómo manejar configuraciones globales y metadatos del sistema.

### Estructura
```javascript
system/config = {
  version: string,            // Versión de la app
  apiEndpoints: object,       // URLs de APIs externas
  featuresEnabled: object,    // Feature flags
  mantenimiento: boolean      // Modo mantenimiento
}

system/stats = {
  totalUsuarios: number,
  totalLibros: number,
  totalReseñas: number,
  fechaUltimaActualizacion: timestamp
}
```

---

## 🔍 Índices Necesarios

### Índices Automáticos
Firebase crea automáticamente índices para:
- Consultas de campo único
- Consultas de igualdad

### Índices Compuestos (en firestore.indexes.json)
```json
{
  "indexes": [
    {
      "collectionGroup": "reviews",
      "fields": [
        {"fieldPath": "bookId", "order": "ASCENDING"},
        {"fieldPath": "fechaCreacion", "order": "DESCENDING"}
      ]
    },
    {
      "collectionGroup": "reviews", 
      "fields": [
        {"fieldPath": "userId", "order": "ASCENDING"},
        {"fieldPath": "fechaCreacion", "order": "DESCENDING"}
      ]
    }
  ]
}
```

---

## 📏 Reglas de Validación

### Tamaños de Documentos
- **Usuarios**: ~1KB por documento
- **Libros**: ~2-3KB por documento
- **Reseñas**: ~1-2KB por documento

### Límites de Firestore
- **Documento máximo**: 1MB
- **Subcollections**: Ilimitadas por documento
- **Consultas**: 100 resultados por defecto

---

## 🎓 Ejercicios Educativos

### Nivel Básico
1. Crear un usuario nuevo
2. Agregar un libro a la librería
3. Escribir una reseña

### Nivel Intermedio
1. Consultar libros por fecha
2. Implementar búsqueda por autor
3. Calcular promedio de calificaciones

### Nivel Avanzado
1. Implementar paginación en consultas
2. Crear triggers para actualizar contadores
3. Optimizar consultas con índices compuestos

---

**💡 Tip Educativo**: Usa la UI del emulador para explorar estos datos en tiempo real y ver cómo se estructuran en Firestore.