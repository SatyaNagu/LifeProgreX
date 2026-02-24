import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen_2.dart';
import 'pagination_dots.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _images = [
    'Assets/onboarding_image.png',
    'Assets/onboarding_image_2.png',
    'Assets/onboarding_image_3.png',
    'Assets/onboarding_image_4.png',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure no system shadows or default app bar colors bleed through
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Clean, flat gradient matching the provided image:
          // deep purple top-left -> pure black -> very subtle dark warm bottom-right
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B113D), // Deep dark purple glow
              Color(0xFF050505), // Near absolute black center
              Color(0xFF140A05), // Faint warm tone at bottom right
            ],
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
                        color: Colors.white.withValues(
                          alpha: 0.08,
                        ), // Subtle frosted background
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

              // Pagination Dots (Screen 1 is active)
              const PaginationDots(currentIndex: 0),

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
                      ), // Pushed down firmly to clear the Back button area
                      const Text(
                        'Build Better',
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
                          'Habits Today',
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
                        'Transform your life one habit at a time\nwith intelligent tracking.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Image Placeholder Card (Flexes gracefully on smaller screens without crashing)
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxHeight: 270,
                          ), // Reduced ~5% per user request
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1E1A29,
                            ), // Fallback background color
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Animated Automatic Image Slider
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 800),
                                child: Image.asset(
                                  _images[_currentIndex],
                                  key: ValueKey<int>(_currentIndex),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      key: const ValueKey('error_container'),
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

                              // Top Right Green Checkbox
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00D12E),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                    weight: 700,
                                  ),
                                ),
                              ),

                              // Bottom Left Text Content
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Motivation Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF3F2B66,
                                        ).withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'MOTIVATION',
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
                                      'Start Small, Win Big',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Consistency is the key to success',
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
                      const SizedBox(height: 24),

                      // Metrics Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              '85%',
                              const Color(0xFF8B5CF6), // Purple
                              'SUCCESS\nRATE',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              '2.3x',
                              const Color(0xFFF97316), // Orange
                              'FASTER\nGROWTH',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              '50k+',
                              Colors.white, // White
                              'ACTIVE\nUSERS',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

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
                                        const OnboardingScreen2(),
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

  Widget _buildMetricCard(String value, Color valueColor, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF16131A), // Very dark background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
