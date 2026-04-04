import 'package:flutter/material.dart';
import '../models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  final AchievementDefinition definition;
  final UserAchievement progress;
  final bool isDark;

  const AchievementCard({
    super.key,
    required this.definition,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05);

    double percent = (progress.currentValue / definition.targetValue).clamp(0.0, 1.0);
    bool isUnlocked = progress.isUnlocked;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: definition.rarityColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  definition.badge,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              if (isUnlocked)
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24)
              else
                Icon(Icons.lock_outline, color: subTextColor.withValues(alpha: 0.3), size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            definition.name,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            definition.requirement,
            style: TextStyle(
              color: subTextColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                isUnlocked ? const Color(0xFF10B981) : definition.rarityColor,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isUnlocked ? 'Completed' : '${progress.currentValue}/${definition.targetValue}',
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Divider(height: 32, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(
                       color: definition.rarityColor.withValues(alpha: 0.1),
                       borderRadius: BorderRadius.circular(6),
                     ),
                     child: Text(
                       definition.rarityLabel,
                       style: TextStyle(
                         color: definition.rarityColor,
                         fontSize: 10,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                   const SizedBox(width: 8),
                   Text(
                     '•  +${definition.points} Points',
                     style: TextStyle(
                       color: subTextColor,
                       fontSize: 11,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                ],
              ),
              if (isUnlocked && progress.unlockedAt != null)
                Text(
                  'Unlocked: ${_formatDate(progress.unlockedAt!)}',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
