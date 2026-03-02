import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'utils/custom_popup.dart';
import 'welcome.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final bool isNewUser;
  const EmailVerificationScreen({super.key, this.isNewUser = true});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final AuthService _authService = AuthService();
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  Timer? _timer;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    // Initially check if email is verified
    _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    
    if (!_isEmailVerified) {
      _sendVerificationEmail();
      
      // Periodically check if the user verified their email
      _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    await _authService.reloadUser();
    
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (_isEmailVerified) {
      _timer?.cancel();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(isNewUser: widget.isNewUser),
          ),
          (route) => false,
        );
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      await _authService.sendEmailVerification();
      setState(() {
        _canResendEmail = false;
        _resendTimer = 60;
      });
      _startResendTimer();
    } catch (e) {
      if (mounted) {
        CustomPopup.show(
          context: context,
          title: 'Email Error',
          message: 'Failed to send verification email: ${e.toString()}',
          primaryColor: const Color(0xFFF98E2F), // Orange
        );
      }
    }
  }

  void _startResendTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResendEmail = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'your email';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Consistent flat gradient
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
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 60),

                          // Large Mail Icon with glow
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF643DF2), // Solid Purple
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF643DF2).withValues(alpha: 0.5),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.mail_outline,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF98E2F), // Orange notification dot
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Header Text
                          const Text(
                            'Check Your Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "We've sent a verification link to",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Instructions Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16131A), // Dark surface
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.open_in_new,
                                      color: Color(0xFF8B5CF6),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Next Steps',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildStep(1, 'Open your email inbox'),
                                const SizedBox(height: 16),
                                _buildStep(2, 'Find the email from LifeProgreX'),
                                const SizedBox(height: 16),
                                _buildStep(3, 'Click the verification link'),
                                const SizedBox(height: 16),
                                _buildStep(4, "You'll be automatically verified!"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Resend Email Section
                          Text(
                            "Didn't receive the email?",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Resend available in ",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${_resendTimer}s",
                                style: TextStyle(
                                  color: _canResendEmail 
                                    ? const Color(0xFF8B5CF6) 
                                    : Colors.white.withValues(alpha: 0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _canResendEmail ? _sendVerificationEmail : null,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF8B5CF6),
                              disabledForegroundColor: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: const Text('Resend Verification Email'),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Spam warning
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF643DF2).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF643DF2).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF8B5CF6),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Can't find the email?",
                                        style: TextStyle(
                                          color: Color(0xFF8B5CF6),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Check your spam or junk folder. The email is sent from noreply@lifeprogrex.com",
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Back to login
                          TextButton(
                            onPressed: () async {
                              await _authService.signOut();
                              if (!mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: widget.isNewUser ? 'Wrong email? ' : 'Back to start? ',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.isNewUser ? 'Go back to sign up' : 'Go back to login',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Custom Circular Back Button
              Positioned(
                top: 16.0,
                left: 20.0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await _authService.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
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

  Widget _buildStep(int number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF643DF2).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
