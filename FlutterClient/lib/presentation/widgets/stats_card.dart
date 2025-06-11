import 'package:flutter/material.dart';

/// **WIDGET DE TARJETA DE ESTADÍSTICAS EDUCATIVO** 📊
/// 
/// Este widget demuestra:
/// - Visualización de datos numéricos
/// - Diseño de tarjetas informativas
/// - Uso de iconos y colores temáticos
/// - Responsive design
/// - Animaciones sutiles
/// 
/// Conceptos educativos demostrados:
/// - Data visualization widgets
/// - Material Design principles
/// - Color and typography systems
/// - Widget animations

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool isLoading;
  final String? trend;
  final bool showTrend;
  
  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.isLoading = false,
    this.trend,
    this.showTrend = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                effectiveColor.withOpacity(0.05),
                effectiveColor.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: isLoading ? _buildLoadingState() : _buildContent(effectiveColor),
        ),
      ),
    );
  }
  
  /// **CONSTRUIR ESTADO DE CARGA** ⏳
  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Cargando...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  /// **CONSTRUIR CONTENIDO** 📋
  Widget _buildContent(Color effectiveColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con ícono y título
        _buildHeader(effectiveColor),
        
        const SizedBox(height: 12),
        
        // Valor principal
        _buildValue(effectiveColor),
        
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          _buildSubtitle(),
        ],
        
        if (showTrend && trend != null) ...[
          const SizedBox(height: 8),
          _buildTrend(),
        ],
      ],
    );
  }
  
  /// **CONSTRUIR HEADER** 📄
  Widget _buildHeader(Color effectiveColor) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: effectiveColor,
            ),
          ),
          const SizedBox(width: 12),
        ],
        
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        if (onTap != null)
          Icon(
            Icons.chevron_right,
            size: 16,
            color: Colors.grey[400],
          ),
      ],
    );
  }
  
  /// **CONSTRUIR VALOR** 🔢
  Widget _buildValue(Color effectiveColor) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: effectiveColor,
      ),
    );
  }
  
  /// **CONSTRUIR SUBTÍTULO** 📄
  Widget _buildSubtitle() {
    return Text(
      subtitle!,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
      ),
    );
  }
  
  /// **CONSTRUIR TENDENCIA** 📈
  Widget _buildTrend() {
    final isPositive = trend!.startsWith('+');
    final isNeutral = trend!.startsWith('=');
    
    Color trendColor;
    IconData trendIcon;
    
    if (isPositive) {
      trendColor = Colors.green;
      trendIcon = Icons.trending_up;
    } else if (isNeutral) {
      trendColor = Colors.grey;
      trendIcon = Icons.trending_flat;
    } else {
      trendColor = Colors.red;
      trendIcon = Icons.trending_down;
    }
    
    return Row(
      children: [
        Icon(
          trendIcon,
          size: 14,
          color: trendColor,
        ),
        const SizedBox(width: 4),
        Text(
          trend!,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: trendColor,
          ),
        ),
      ],
    );
  }
}

/// **VARIACIONES DEL WIDGET** 🎨
/// 
/// Clases especializadas para diferentes tipos de estadísticas.

/// **TARJETA DE PROGRESO** 📊
class ProgressStatsCard extends StatelessWidget {
  final String title;
  final double progress; // 0.0 a 1.0
  final String? progressText;
  final Color? color;
  final IconData? icon;
  
  const ProgressStatsCard({
    super.key,
    required this.title,
    required this.progress,
    this.progressText,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: effectiveColor,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Barra de progreso
            LinearProgressIndicator(
              value: progress,
              backgroundColor: effectiveColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
            
            const SizedBox(height: 8),
            
            // Texto de progreso
            Text(
              progressText ?? '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// **TARJETA DE RATING** ⭐
class RatingStatsCard extends StatelessWidget {
  final String title;
  final double rating; // 0.0 a 5.0
  final int? totalRatings;
  final Color? color;
  
  const RatingStatsCard({
    super.key,
    required this.title,
    required this.rating,
    this.totalRatings,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.amber;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Rating con estrellas
            Row(
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                  ),
                ),
                const SizedBox(width: 8),
                ...List.generate(5, (index) {
                  final filled = index < rating.floor();
                  final half = index == rating.floor() && rating % 1 >= 0.5;
                  
                  return Icon(
                    filled ? Icons.star : (half ? Icons.star_half : Icons.star_border),
                    size: 16,
                    color: effectiveColor,
                  );
                }),
              ],
            ),
            
            if (totalRatings != null) ...[
              const SizedBox(height: 4),
              Text(
                '$totalRatings valoraciones',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}