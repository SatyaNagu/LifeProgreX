import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'theme_manager.dart';

class PremiumBackground extends StatelessWidget {
  final Widget child;
  final bool forcePremium;

  const PremiumBackground({
    super.key,
    required this.child,
    this.forcePremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager();
    final isDark = themeManager.isDarkMode;

    // Only apply the premium background in dark mode, or if forced
    if (!isDark && !forcePremium) {
      return Container(
        color: const Color(0xFFF0F4F8),
        child: child,
      );
    }

    return Stack(
      children: [
        // 1. Base Gradient Layer
        _buildBaseBackground(isDark),
        
        // 2. Fixed Background Blobs
        ..._buildBackgroundBlobs(context, isDark),
        
        // 3. Mesh Gradient Overlay
        _buildMeshGradient(isDark),
        
        // 4. Content
        child,
      ],
    );
  }

  Widget _buildBaseBackground(bool isDark) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [
                    const Color(0xFF0F0718),
                    const Color(0xFF1A0B2E),
                    const Color(0xFF160B28),
                  ]
                : [
                    const Color(0xFFF0F4F8), 
                    const Color(0xFFE8EDF3), 
                    const Color(0xFFF5F7FA),
                  ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundBlobs(BuildContext context, bool isDark) {
    final size = MediaQuery.of(context).size;
    return [
      // Top-Right Blob
      Positioned(
        top: -size.height * 0.15,
        right: -size.width * 0.2,
        child: _buildBlob(
          size: 500,
          color: isDark 
              ? const Color(0xFFFF6B35).withValues(alpha: 0.15) 
              : const Color(0xFF00D9FF).withValues(alpha: 0.06),
          blur: 180,
        ),
      ),
      // Mid-Left Blob
      Positioned(
        top: size.height * 0.25,
        left: -size.width * 0.25,
        child: _buildBlob(
          size: 450,
          color: isDark 
              ? const Color(0xFFB24BF3).withValues(alpha: 0.2) 
              : const Color(0xFFFFBF00).withValues(alpha: 0.08),
          blur: 160,
        ),
      ),
      // Bottom-Right Blob
      Positioned(
        bottom: size.height * 0.15,
        right: -size.width * 0.2,
        child: _buildBlob(
          size: 400,
          color: isDark 
              ? const Color(0xFFFFBF00).withValues(alpha: 0.15) 
              : const Color(0xFFFF2D95).withValues(alpha: 0.06),
          blur: 150,
        ),
      ),
      // Bottom-Left Blob
      Positioned(
        bottom: -size.height * 0.15,
        left: -size.width * 0.15,
        child: _buildBlob(
          size: 450,
          color: isDark 
              ? const Color(0xFFFF2D95).withValues(alpha: 0.15) 
              : const Color(0xFFB24BF3).withValues(alpha: 0.06),
          blur: 160,
        ),
      ),
    ];
  }

  Widget _buildBlob({required double size, required Color color, required double blur}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildMeshGradient(bool isDark) {
    return Positioned.fill(
      child: Opacity(
        opacity: isDark ? 0.4 : 0.3,
        child: CustomPaint(
          painter: MeshGradientPainter(isDark: isDark),
        ),
      ),
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  final bool isDark;
  MeshGradientPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final List<Map<String, dynamic>> gradients = isDark 
      ? [
          {'pos': const Offset(0.2, 0.3), 'color': const Color(0xFFFF6B35).withValues(alpha: 0.2)},
          {'pos': const Offset(0.8, 0.2), 'color': const Color(0xFFFFBF00).withValues(alpha: 0.15)},
          {'pos': const Offset(0.4, 0.7), 'color': const Color(0xFFB24BF3).withValues(alpha: 0.2)},
          {'pos': const Offset(0.9, 0.8), 'color': const Color(0xFFFF2D95).withValues(alpha: 0.15)},
        ]
      : [
          {'pos': const Offset(0.2, 0.3), 'color': const Color(0xFF00D9FF).withValues(alpha: 0.15)},
          {'pos': const Offset(0.8, 0.2), 'color': const Color(0xFFFFBF00).withValues(alpha: 0.12)},
          {'pos': const Offset(0.4, 0.7), 'color': const Color(0xFFB24BF3).withValues(alpha: 0.1)},
          {'pos': const Offset(0.9, 0.8), 'color': const Color(0xFFFF2D95).withValues(alpha: 0.12)},
        ];

    for (var g in gradients) {
      final center = Offset(size.width * g['pos'].dx, size.height * g['pos'].dy);
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          size.width * 1.2,
          [g['color'], Colors.transparent],
        );
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
