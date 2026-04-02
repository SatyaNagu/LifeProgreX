import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'landing_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final bool isNewUser;
  final String userName;

  const WelcomeScreen({
    super.key,
    this.isNewUser = false,
    this.userName = 'Nagasai',
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to LandingScreen after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LandingScreen(userName: widget.userName),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEAF5F3), // mint
              Color(0xFFF6F8FB), // white
              Color(0xFFF3EAF2), // lavender
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo (Main UI Icon)
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'Assets/ui_icon.svg',
                            width: 100,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(
                                text: widget.isNewUser
                                    ? 'Welcome to LifeProgreX\n'
                                    : 'Welcome back to LifeProgreX\n',
                              ),
                              TextSpan(
                                text: (() {
                                  final name = FirebaseAuth.instance.currentUser?.displayName;
                                  if (name != null && name.trim().isNotEmpty) {
                                    return name.split(' ')[0];
                                  }
                                  return widget.userName.split(' ')[0];
                                })(),
                                style: const TextStyle(
                                  color: Color(0xFF8B5CF6), // Purple highlight
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
