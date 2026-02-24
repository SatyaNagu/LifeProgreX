import 'package:flutter/material.dart';

class PaginationDots extends StatelessWidget {
  final int currentIndex; // 0 for Screen 1, 1 for Screen 2, 2 for Screen 3

  const PaginationDots({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16.0,
      left: 0,
      right: 0,
      height: 44, // Match back button height for perfect vertical centering
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(0),
          const SizedBox(width: 8),
          _buildDot(1),
          const SizedBox(width: 8),
          _buildDot(2),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    if (index == currentIndex) {
      return const BlinkingDot();
    } else if (index < currentIndex) {
      // Previous (Purple)
      return Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF643DF2), // Distinct Purple
          shape: BoxShape.circle,
        ),
      );
    } else {
      // Upcoming (Grey)
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2), // Faded Grey
          shape: BoxShape.circle,
        ),
      );
    }
  }
}

class BlinkingDot extends StatefulWidget {
  const BlinkingDot({super.key});

  @override
  State<BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: const Color(0xFFF97316), // Orange
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF97316).withValues(alpha: 0.5),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
