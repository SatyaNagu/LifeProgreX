import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Consistent flat gradient matching Onboarding & Signup
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
              // Main content (Keyboard safe scroll view)
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 64,
                          ), // Space padding for top back button
                          // Top Welcome Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF643DF2,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xFF643DF2,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: const Color(
                                    0xFF8B5CF6,
                                  ), // Bright Purple
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Headers
                          const Text(
                            'Login to LifeProgreX',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Continue your journey to greatness',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Form Fields
                          _buildTextField(
                            hint: 'Email or Mobile',
                            icon: Icons.mail_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {}, // TODO: Forgot Password routing
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xFF8B5CF6), // Primary Purple
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Login Button
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF643DF2), // Left position
                                  Color(0xFF3A1F73), // Right position
                                ],
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {}, // TODO: Add auth validation
                                borderRadius: BorderRadius.circular(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Divider OR
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Continue with Google Button
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF232029), // Dark Grey
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {}, // TODO: Add Google Auth
                                borderRadius: BorderRadius.circular(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: GoogleLogoPainterWidget(),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Terms & Privacy Text
                          Text(
                            'By continuing, you agree to our Terms & Privacy Policy',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Universal Custom Circular Back Button
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
            ],
          ),
        ),
      ),
    );
  }

  // Consistent dark form fields
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0C13), // Very dark field background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.3),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// Custom Native Google Logo Drawing
class GoogleLogoPainterWidget extends StatelessWidget {
  const GoogleLogoPainterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GoogleLogoPainter());
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Scale standard path data to fit the custom widget size
    final double scaleX = width / 24.0;
    final double scaleY = height / 24.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Red Path
    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(23.64, 12.2)
      ..cubicTo(23.64, 11.36, 23.57, 10.55, 23.43, 9.77)
      ..lineTo(12, 9.77)
      ..lineTo(12, 14.4)
      ..lineTo(18.52, 14.4)
      ..cubicTo(18.24, 15.89, 17.43, 17.16, 16.15, 18.01)
      ..lineTo(16.15, 21.03)
      ..lineTo(20.08, 21.03)
      ..cubicTo(22.37, 18.91, 23.64, 15.83, 23.64, 12.2)
      ..close();
    canvas.drawPath(redPath, paint);

    // Green Path
    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(12, 24)
      ..cubicTo(15.27, 24, 18.02, 22.92, 20.08, 21.03)
      ..lineTo(16.15, 18.01)
      ..cubicTo(15.06, 18.73, 13.65, 19.16, 12, 19.16)
      ..cubicTo(8.79, 19.16, 6.07, 17.02, 5.09, 14.16)
      ..lineTo(1.05, 14.16)
      ..lineTo(1.05, 17.26)
      ..cubicTo(3.08, 21.28, 7.21, 24, 12, 24)
      ..close();
    canvas.drawPath(greenPath, paint);

    // Yellow Path
    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(5.09, 14.16)
      ..cubicTo(4.84, 13.43, 4.7, 12.73, 4.7, 12)
      ..cubicTo(4.7, 11.27, 4.84, 10.57, 5.09, 9.84)
      ..lineTo(5.09, 6.74)
      ..lineTo(1.05, 6.74)
      ..cubicTo(0.38, 8.08, 0, 9.58, 0, 12)
      ..cubicTo(0, 14.42, 0.38, 15.92, 1.05, 17.26)
      ..lineTo(5.09, 14.16)
      ..close();
    canvas.drawPath(yellowPath, paint);

    // Blue Path
    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(12, 4.84)
      ..cubicTo(13.78, 4.84, 15.37, 5.45, 16.63, 6.64)
      ..lineTo(20.16, 3.1)
      ..cubicTo(18.01, 1.18, 15.27, 0, 12, 0)
      ..cubicTo(7.21, 0, 3.08, 2.72, 1.05, 6.74)
      ..lineTo(5.09, 9.84)
      ..cubicTo(6.07, 6.98, 8.79, 4.84, 12, 4.84)
      ..close();
    canvas.drawPath(bluePath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
