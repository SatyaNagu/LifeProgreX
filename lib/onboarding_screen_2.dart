import 'package:flutter/material.dart';
import 'onboarding_screen_3.dart';
import 'pagination_dots.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Clean, flat gradient matching Onboarding 1
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B113D), Color(0xFF050505), Color(0xFF140A05)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Custom Circular Back Button
              Positioned(
                top: 16.0,
                left: 20.0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Pagination Dots (Screen 2 is active)
              const PaginationDots(currentIndex: 1),

              // Main content
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 48,
                      ), // Pushed down very firmly to clear the Back button completely
                      const Text(
                        'Track Your',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          height: 1.1,
                        ),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) =>
                            const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFF97316)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        child: const Text(
                          'Progress Live',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Visualize your success with powerful analytics and insights.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Image Placeholder Card
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxHeight: 250,
                          ), // Heavily tightened constraint so it matches screen 1's vertical consumption
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1A29),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'Assets/onboarding_image_5.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFF231E30),
                                    child: Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                        size: 48,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Bottom Gradient Overlay for Text Readability
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 140,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.9),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Top Stats Overlay
                              Positioned(
                                top: 20,
                                left: 20,
                                right: 20,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildInnerStatCard(
                                        Icons.local_fire_department,
                                        const Color(0xFFF97316),
                                        '14',
                                        'STREAK',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInnerStatCard(
                                        Icons.star,
                                        const Color(0xFFFBBF24),
                                        '92%',
                                        'SCORE',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInnerStatCard(
                                        Icons.emoji_events,
                                        const Color(0xFFF87171),
                                        '#12',
                                        'RANK',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom Left Text Content
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Analytics Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF8B5CF6,
                                        ).withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'ANALYTICS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Data-Driven Growth',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Measure what matters most',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Interactive Charts Header
                      Row(
                        children: [
                          const Text(
                            'Interactive Charts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Divider(
                              color: Colors.white.withValues(alpha: 0.1),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Action Cards Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              Icons.show_chart,
                              'HABIT TRENDS',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              Icons.pie_chart_outline,
                              'CATEGORY\nSPLIT',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              Icons.bar_chart,
                              'WEEKLY STATS',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const OnboardingScreen3(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInnerStatCard(
    IconData icon,
    Color iconColor,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(
          0xFF2A2A2A,
        ).withValues(alpha: 0.8), // Dark translucent
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String label) {
    return SizedBox(
      height:
          90, // Unify the height exactly so none of them grow taller than each other
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4), // Tighter padding
        decoration: BoxDecoration(
          color: const Color(0xFF16131A), // Very dark background
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center contents inside the fixed box
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
