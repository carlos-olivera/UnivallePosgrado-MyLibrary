import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// **WIDGET DE TARJETA DE LIBRO EDUCATIVO** 📚
/// 
/// Este widget demuestra:
/// - Composición de widgets reutilizables
/// - Manejo de imágenes con cache
/// - Estados de carga y error
/// - Diseño responsivo y adaptable
/// - Diferentes modos de visualización
/// 
/// Conceptos educativos demostrados:
/// - Widget composition patterns
/// - Image caching strategies
/// - Responsive design
/// - Component flexibility

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final VoidCallback? onTap;
  final bool showRating;
  final bool showProgress;
  final bool isCompact;
  final double? width;
  final double? height;
  
  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.showRating = false,
    this.showProgress = false,
    this.isCompact = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(isCompact ? 8 : 12),
          child: isCompact ? _buildCompactLayout() : _buildDefaultLayout(),
        ),
      ),
    );
  }
  
  /// **CONSTRUIR LAYOUT POR DEFECTO** 📋
  Widget _buildDefaultLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen del libro
        Expanded(
          flex: 3,
          child: _buildBookImage(),
        ),
        
        const SizedBox(height: 12),
        
        // Información del libro
        Expanded(
          flex: 2,
          child: _buildBookInfo(),
        ),
      ],
    );
  }
  
  /// **CONSTRUIR LAYOUT COMPACTO** 📋
  Widget _buildCompactLayout() {
    return Row(
      children: [
        // Imagen del libro
        SizedBox(
          width: 60,
          height: 80,
          child: _buildBookImage(),
        ),
        
        const SizedBox(width: 12),
        
        // Información del libro
        Expanded(
          child: _buildBookInfo(),
        ),
      ],
    );
  }
  
  /// **CONSTRUIR IMAGEN DEL LIBRO** 🖼️
  Widget _buildBookImage() {
    final imageUrl = book['imageUrl'] as String?;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildImagePlaceholder(),
                errorWidget: (context, url, error) => _buildImageError(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }
  
  /// **CONSTRUIR PLACEHOLDER DE IMAGEN** 🖼️
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.book,
          size: isCompact ? 24 : 32,
          color: Colors.grey[400],
        ),
      ),
    );
  }
  
  /// **CONSTRUIR ERROR DE IMAGEN** ⚠️
  Widget _buildImageError() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: isCompact ? 20 : 28,
          color: Colors.grey[400],
        ),
      ),
    );
  }
  
  /// **CONSTRUIR INFORMACIÓN DEL LIBRO** 📝
  Widget _buildBookInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Text(
          book['title'] ?? 'Sin título',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isCompact ? 14 : 16,
          ),
          maxLines: isCompact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Autor
        Text(
          book['author'] ?? 'Autor desconocido',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isCompact ? 12 : 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        if (!isCompact) const Spacer(),
        
        // Rating o progreso
        if (showRating && !showProgress) _buildRating(),
        if (showProgress && !showRating) _buildProgress(),
        if (showRating && showProgress) ..._buildRatingAndProgress(),
      ],
    );
  }
  
  /// **CONSTRUIR RATING** ⭐
  Widget _buildRating() {
    final rating = book['rating'] as double? ?? 0.0;
    
    if (rating <= 0) return const SizedBox.shrink();
    
    return Row(
      children: [
        Icon(
          Icons.star,
          size: isCompact ? 14 : 16,
          color: Colors.amber,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: isCompact ? 12 : 14,
          ),
        ),
      ],
    );
  }
  
  /// **CONSTRUIR PROGRESO** 📊
  Widget _buildProgress() {
    final progress = book['progress'] as int? ?? 0;
    final status = book['status'] as String? ?? '';
    
    String statusText;
    Color statusColor;
    
    switch (status) {
      case 'reading':
        statusText = 'Leyendo';
        statusColor = Colors.blue;
        break;
      case 'completed':
        statusText = 'Completado';
        statusColor = Colors.green;
        break;
      case 'want-to-read':
        statusText = 'Por leer';
        statusColor = Colors.orange;
        break;
      case 'on-hold':
        statusText = 'En pausa';
        statusColor = Colors.grey;
        break;
      default:
        statusText = 'Sin estado';
        statusColor = Colors.grey;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Estado
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        if (status == 'reading' && progress > 0) ...[
          const SizedBox(height: 4),
          
          // Barra de progreso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$progress%',
                style: TextStyle(
                  fontSize: isCompact ? 10 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ],
          ),
        ],
      ],
    );
  }
  
  /// **CONSTRUIR RATING Y PROGRESO** ⭐📊
  List<Widget> _buildRatingAndProgress() {
    return [
      _buildProgress(),
      const SizedBox(height: 8),
      _buildRating(),
    ];
  }
}

/// **VARIACIONES DEL WIDGET** 🎨
/// 
/// Clases especializadas para diferentes usos.

/// **TARJETA COMPACTA DE LIBRO** 📋
class CompactBookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final VoidCallback? onTap;
  final bool showRating;
  final bool showProgress;
  
  const CompactBookCard({
    super.key,
    required this.book,
    this.onTap,
    this.showRating = false,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return BookCard(
      book: book,
      onTap: onTap,
      showRating: showRating,
      showProgress: showProgress,
      isCompact: true,
      height: 100,
    );
  }
}

/// **TARJETA GRANDE DE LIBRO** 📚
class LargeBookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final VoidCallback? onTap;
  final bool showRating;
  final bool showProgress;
  
  const LargeBookCard({
    super.key,
    required this.book,
    this.onTap,
    this.showRating = true,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return BookCard(
      book: book,
      onTap: onTap,
      showRating: showRating,
      showProgress: showProgress,
      width: 200,
      height: 320,
    );
  }
}