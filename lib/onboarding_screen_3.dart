import 'package:flutter/material.dart';
import 'pagination_dots.dart';
import 'signup_screen.dart';
import 'login_screen.dart'; // Added import

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Clean, flat gradient matching Onboarding 1 & 2 perfectly
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

              // Pagination Dots (Screen 3 is active)
              const PaginationDots(currentIndex: 2),

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
                      ), // Set perfectly identical to Screen 1 top padding
                      const Text(
                        'Meet MAX',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38, // Reverted exactly to 38
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
                          'Your Personal Coach',
                          style: TextStyle(
                            fontSize: 38, // Reverted exactly to 38
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Unlock your full potential with advanced AI analysis.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24), // Reverted back to exactly 24
                      // Central Image Card Placeholder
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxHeight:
                                186, // Shrunk to perfectly absorb the Login Button height and keep ColH equivalent to Screen 2!
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1A29),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'Assets/onboarding_image_6.png',
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
                                height: 100,
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

                              // Bottom Center Text Inside Image
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Intelligence Amplified',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Trained on millions of success patterns',
                                      textAlign: TextAlign.center,
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
                      const SizedBox(height: 24), // Reverted back to exactly 24
                      // Feature Action Cards Row (Identical sizing to Screen 2)
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureCard(
                              Icons.rocket_launch,
                              const Color(0xFFEC4899), // Pink
                              '3.5x',
                              'FASTER GOALS',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFeatureCard(
                              Icons.star,
                              const Color(0xFFFBBF24), // Yellow
                              '92%',
                              'SATISFACTION',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFeatureCard(
                              Icons.smart_toy,
                              const Color(0xFF8B5CF6), // Purple
                              '24/7',
                              'SUPPORT',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20), // Reverted back to exactly 20
                      // Start Your Journey Button with the Custom Angle Gradient
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF643DF2), // Left position 0%
                              Color(0xFF3A1F73), // Right position 100%
                            ],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo Placeholder (Reverted to Image.asset PNG)
                                Image.asset(
                                  'Assets/logo_placeholder.png',
                                  width: 22,
                                  height: 22,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.white,
                                      size: 20,
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Start Your Journey',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ), // Bottom cushion for the inserted Login button
                      // Login Text Button (Brought BACK into Main Column to stabilize math)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildFeatureCard(
    IconData icon,
    Color iconColor,
    String value,
    String label,
  ) {
    return SizedBox(
      height: 90, // Reverted to exactly 90 matching Screen 2
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF16131A), // Very dark background
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: iconColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
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
