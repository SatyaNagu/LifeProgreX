import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';
import '../screens/goals_screen.dart';

class AnimatedGoalsCard extends StatefulWidget {
  final int completedGoals;
  final int totalGoals;
  final int score;
  final bool hasAnyGoals;
  final ThemeManager themeManager;

  const AnimatedGoalsCard({
    super.key,
    required this.completedGoals,
    required this.totalGoals,
    required this.score,
    required this.hasAnyGoals,
    required this.themeManager,
  });

  @override
  State<AnimatedGoalsCard> createState() => _AnimatedGoalsCardState();
}

class _AnimatedGoalsCardState extends State<AnimatedGoalsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildBlob({
    required double size,
    required Color color,
    required double blur,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: blur, spreadRadius: blur / 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeManager.isDarkMode;
    final totalGoals = widget.totalGoals;
    final completedGoals = widget.completedGoals;
    final remaining = totalGoals - completedGoals;
    final progress = (widget.score / 100.0).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoalsScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1F1033).withValues(alpha: 0.8),
                    const Color(0xFF261547).withValues(alpha: 0.6),
                    const Color(0xFF2D1B57).withValues(alpha: 0.4),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.9),
                    const Color(0xFFF9FAFB).withValues(alpha: 0.6),
                  ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isDark
                ? const Color(0xFFB24BF3).withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: _buildBlob(
                  size: 160,
                  color: const Color(
                    0xFFFFBF00,
                  ).withValues(alpha: isDark ? 0.3 : 0.15),
                  blur: 64,
                ),
              ),
              Positioned(
                bottom: -32,
                left: -32,
                child: _buildBlob(
                  size: 128,
                  color: const Color(
                    0xFFB24BF3,
                  ).withValues(alpha: isDark ? 0.3 : 0.15),
                  blur: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                color: Color(0xFFFFBF00),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Today's Goals",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF111827),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (totalGoals > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFBF00), Color(0xFFF59E0B)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFBF00,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              '$completedGoals/$totalGoals',
                              style: const TextStyle(
                                color: Color(0xFF0A0E0A),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    if (!widget.hasAnyGoals)
                      Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Ready to grow? Create or continue a goal 🌱",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 6,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: AnimatedBuilder(
                                  animation: _animController,
                                  builder: (context, child) {
                                    return ShaderMask(
                                      blendMode: BlendMode.srcATop,
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withValues(alpha: 0.8),
                                            Colors.transparent,
                                          ],
                                          stops: [
                                            _animController.value - 0.3,
                                            _animController.value,
                                            _animController.value + 0.3,
                                          ],
                                          begin: const FractionalOffset(
                                            -0.5,
                                            0,
                                          ),
                                          end: const FractionalOffset(1.5, 0),
                                        ).createShader(bounds);
                                      },
                                      child: Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF6B35),
                                              Color(0xFFFFBF00),
                                              Color(0xFF9FE82E),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFFFBF00,
                                              ).withValues(alpha: 0.4),
                                              blurRadius: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                left:
                                    (MediaQuery.of(context).size.width - 88) *
                                        progress -
                                    25,
                                top: -35,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFFF2D95),
                                            Color(0xFFFF6B35),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFFF2D95,
                                            ).withValues(alpha: 0.3),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '${widget.score}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    CustomPaint(
                                      size: const Size(10, 5),
                                      painter: _GoalTrianglePainter(
                                        color: const Color(0xFFFF6B35),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          AnimatedBuilder(
                            animation: _animController,
                            builder: (context, child) {
                              final glowOp =
                                  (sin(_animController.value * pi * 2) + 1) /
                                  2; // 0 to 1
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedStatusDot(
                                    color: const Color(0xFFFFBF00),
                                    label: 'Completed: $completedGoals',
                                    isDark: isDark,
                                    glowIntensity: glowOp,
                                  ),
                                  const SizedBox(width: 32),
                                  _buildAnimatedStatusDot(
                                    color: const Color(
                                      0xFFA855F7,
                                    ), // Purple shade requested
                                    label: 'Remaining: $remaining',
                                    isDark: isDark,
                                    glowIntensity: glowOp,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedStatusDot({
    required Color color,
    required String label,
    required bool isDark,
    required double glowIntensity,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2 + (0.6 * glowIntensity)),
                blurRadius: 4 + (6 * glowIntensity),
                spreadRadius: 1 + (3 * glowIntensity),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _GoalTrianglePainter extends CustomPainter {
  final Color color;
  _GoalTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
