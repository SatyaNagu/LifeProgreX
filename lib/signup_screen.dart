import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'welcome.dart';
import 'email_verification.dart';
import 'auth_service.dart';
import 'utils/custom_popup.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    HapticFeedback.lightImpact();
    setState(() => _isGoogleLoading = true);

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => user.user?.emailVerified == true
                ? const WelcomeScreen(isNewUser: true)
                : const EmailVerificationScreen(isNewUser: true),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Google Sign-In Error',
          message: e.toString(),
          primaryColor: const Color(0xFFF98E2F), // Orange
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      CustomPopup.show(
        context: context,
        title: 'Missing Fields',
        message: 'Please fill all required fields',
        primaryColor: const Color(0xFFF98E2F), // Orange
      );
      return;
    }

    if (password != confirmPassword) {
      CustomPopup.show(
        context: context,
        title: 'Password Mismatch',
        message: 'Passwords do not match. Please try again.',
        primaryColor: const Color(0xFFF98E2F), // Orange
      );
      return;
    }

    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signUpWithEmailAndPassword(
        email,
        password,
      );
      if (user != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => user.user?.emailVerified == true
                ? const WelcomeScreen(isNewUser: true)
                : const EmailVerificationScreen(isNewUser: true),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Signup Error',
          message: e.toString(),
          primaryColor: const Color(0xFFF98E2F), // Orange
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEAF5F3), // mint
              Color(0xFFF6F8FB), // white
              Color(0xFFF3EAF2), // lavender
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background Blobs
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00D9FF).withValues(alpha: 0.05),
                  ),
                ),
              ),

              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),

                          // Join Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00D9FF), Color(0xFFA855F7)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFA855F7,
                                  ).withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Join LifeProgreX',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Headers
                          const Text(
                            'Create Your Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Start your personal growth journey today',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Form Card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ui.ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildFieldLabel('First Name'),
                                              _buildTextField(
                                                hint: 'John',
                                                icon: Icons.person_outline,
                                                controller:
                                                    _firstNameController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildFieldLabel('Last Name'),
                                              _buildTextField(
                                                hint: 'Doe',
                                                icon: Icons.person_outline,
                                                controller: _lastNameController,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFieldLabel('Email Address'),
                                    _buildTextField(
                                      hint: 'john@example.com',
                                      icon: Icons.mail_outline,
                                      controller: _emailController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFieldLabel(
                                      'Mobile Number (Optional)',
                                    ),
                                    _buildTextField(
                                      hint: '+1 (555) 000-0000',
                                      icon: Icons.phone_outlined,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFieldLabel('Password'),
                                    _buildTextField(
                                      hint: 'Create a strong password',
                                      icon: Icons.lock_outline,
                                      isPassword: true,
                                      controller: _passwordController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFieldLabel('Confirm Password'),
                                    _buildTextField(
                                      hint: 'Re-enter your password',
                                      icon: Icons.lock_outline,
                                      isPassword: true,
                                      controller: _confirmPasswordController,
                                    ),
                                    const SizedBox(height: 24),

                                    // Create Account Button
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF00D9FF),
                                            Color(0xFFA855F7),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFA855F7,
                                            ).withValues(alpha: 0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed:
                                            (_isLoading || _isGoogleLoading)
                                            ? null
                                            : _handleSignUp,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (_isLoading)
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            else ...[
                                              const Text(
                                                'CREATE ACCOUNT',
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Features Card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'What you\'ll get:',
                                      style: TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCheckItem('Track unlimited habits'),
                                    const SizedBox(height: 10),
                                    _buildCheckItem('Get AI-powered insights'),
                                    const SizedBox(height: 10),
                                    _buildCheckItem('Unlock achievements'),
                                    const SizedBox(height: 10),
                                    _buildCheckItem(
                                      'Access detailed analytics',
                                    ),
                                    const SizedBox(height: 10),
                                    _buildCheckItem('Join 50k+ users'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFF00D9FF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Back Button
              Visibility(
                visible: Navigator.canPop(context),
                child: Positioned(
                  top: 16.0,
                  left: 20.0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.8),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.05),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_left,
                            color: Color(0xFF1F2937),
                            size: 24,
                          ),
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF374151),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0F2FE),
          ),
          child: const Icon(Icons.check, color: Color(0xFF3B82F6), size: 12),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF9CA3AF).withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}

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
    final double scaleX = width / 24.0;
    final double scaleY = height / 24.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Red
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

    // Green
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

    // Yellow
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

    // Blue
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
