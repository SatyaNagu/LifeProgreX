import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/theme_manager.dart';
import '../models/goal_model.dart';
import '../services/goal_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final ThemeManager _themeManager = ThemeManager();
  final GoalService _goalService = GoalService();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    super.dispose();
  }

  void _updateTheme() {
    if (mounted) setState(() {});
  }

  void _showGoalModal({GoalModel? existingGoal}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditGoalModal(goal: existingGoal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return Scaffold(
      backgroundColor: Colors.transparent, // Parent provides background typically, but we should make sure
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
              ? [const Color(0xFF1A1025), const Color(0xFF0F0A18)] 
              : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
          ),
        ),
        child: Stack(
          children: [
            // Background Blobs
            Positioned(top: -100, right: -50, child: _buildBlob(const Color(0xFFFF6B35), isDark, 200)),
            Positioned(bottom: 100, left: -50, child: _buildBlob(const Color(0xFFFF2D95), isDark, 180)),
            Positioned(top: 200, left: -100, child: _buildBlob(const Color(0xFFB24BF3), isDark, 250)),
            Positioned(bottom: -50, right: -50, child: _buildBlob(const Color(0xFFFFBF00), isDark, 200)),
            
            SafeArea(
              child: StreamBuilder<List<GoalModel>>(
                stream: _goalService.getGoalsStream(),
                builder: (context, snapshot) {
                  final goals = snapshot.data ?? [];
                  final completedGoals = goals.where((g) => g.isCompleted).length;

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildHeader(textColor, goals.length, completedGoals).animate().fadeIn(duration: 400.ms),
                      ),
                      if (goals.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: _buildProgressCard(goals.length, completedGoals),
                          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut),
                        ),
                      if (goals.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(textColor).animate().fadeIn(delay: 200.ms),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildGoalCard(goals[index], textColor)
                                    .animate()
                                    .fadeIn(delay: (200 + (index * 100)).ms)
                                    .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut),
                                );
                              },
                              childCount: goals.length,
                            ),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 96)), // Safe Bottom padding
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlob(Color color, bool isDark, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.4 : 0.08),
        shape: BoxShape.circle,
        boxShadow: [
           BoxShadow(
             color: color.withValues(alpha: isDark ? 0.4 : 0.08),
             blurRadius: 90,
             spreadRadius: 30,
           ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color textColor, int totalGoals, int completedGoals) {
    final isDark = _themeManager.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey.shade300),
                  ),
                  child: Icon(Icons.chevron_left, color: textColor, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Goals',
                    style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$totalGoals goals • $completedGoals completed',
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _showGoalModal(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFFBF00), Color(0xFFF59E0B)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int total, int completed) {
    final isDark = _themeManager.isDarkMode;
    final percentage = total > 0 ? (completed / total * 100).toInt() : 0;
    final fraction = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? [const Color(0xFF1F1033).withValues(alpha: 0.8), const Color(0xFF261547).withValues(alpha: 0.6), const Color(0xFF2D1B57).withValues(alpha: 0.4)]
              : [Colors.white.withValues(alpha: 0.8), Colors.white.withValues(alpha: 0.6)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFBF00).withValues(alpha: isDark ? 0.3 : 0.4)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1), 
            blurRadius: 20, 
            offset: const Offset(0, 10)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFBF00).withValues(alpha: isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.track_changes, color: Color(0xFFFFBF00), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Progress',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.grey.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$percentage% Complete',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: fraction),
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutCirc,
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFBF00), Color(0xFFF59E0B), Color(0xFF9FE82E)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(GoalModel goal, Color textColor) {
    final isDark = _themeManager.isDarkMode;
    final Map<GoalCategory, Map<String, dynamic>> catData = {
      GoalCategory.fitness: {'color': const Color(0xFFFF6B35), 'emoji': '💪'},
      GoalCategory.learning: {'color': const Color(0xFF00D9FF), 'emoji': '📚'},
      GoalCategory.wellness: {'color': const Color(0xFFFF2D95), 'emoji': '❤️'},
      GoalCategory.career: {'color': const Color(0xFFB24BF3), 'emoji': '💼'},
      GoalCategory.habits: {'color': const Color(0xFFFFBF00), 'emoji': '⭐'},
      GoalCategory.personal: {'color': const Color(0xFF9FE82E), 'emoji': '🎯'},
    };
    
    final categoryColor = catData[goal.category]!['color'] as Color;
    final emoji = catData[goal.category]!['emoji'] as String;
    
    final bgColor = isDark 
      ? [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.02)]
      : [Colors.white.withValues(alpha: 0.8), Colors.white.withValues(alpha: 0.6)];
    
    final borderColor = goal.isCompleted 
      ? const Color(0xFF9FE82E).withValues(alpha: 0.4) 
      : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: bgColor, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: goal.isCompleted ? [BoxShadow(color: const Color(0xFF9FE82E).withValues(alpha: 0.1), blurRadius: 10)] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Category color bar
                Container(
                  width: 4,
                  color: categoryColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkbox properly animated
                        GestureDetector(
                          onTap: () async {
                            try {
                              await _goalService.updateGoal(goal.copyWith(isCompleted: !goal.isCompleted));
                              if (!goal.isCompleted && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('🎉 Goal completed!'), backgroundColor: Color(0xFF10C655)),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: goal.isCompleted
                              ? const Icon(Icons.check_circle, color: Color(0xFF9FE82E), size: 28).animate().scale(duration: 200.ms)
                              : Icon(Icons.circle_outlined, color: isDark ? Colors.white38 : Colors.grey.shade400, size: 28),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$emoji  ${goal.title}',
                                style: TextStyle(
                                  color: goal.isCompleted 
                                      ? (isDark ? Colors.grey.shade500 : Colors.grey.shade600) 
                                      : (isDark ? Colors.white : Colors.grey.shade900),
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (goal.description.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  goal.description,
                                  style: TextStyle(
                                    color: goal.isCompleted ? (isDark ? Colors.grey.shade600 : Colors.grey.shade400) : (isDark ? Colors.white54 : Colors.grey.shade600), 
                                    fontSize: 14,
                                    decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              // Metadata & Actions row
                              Row(
                                children: [
                                  // Category Pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(color: categoryColor, shape: BoxShape.circle),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          goal.category.toString().split('.').last[0].toUpperCase() + goal.category.toString().split('.').last.substring(1),
                                          style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Target Date
                                  Icon(Icons.calendar_today, size: 12, color: isDark ? Colors.grey.shade500 : Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(goal.targetDate),
                                    style: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade500, fontSize: 12),
                                  ),
                                  const Spacer(),
                                  // Right side actions
                                  GestureDetector(
                                    onTap: () => _showGoalModal(existingGoal: goal),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00D9FF).withValues(alpha: isDark ? 0.2 : 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.edit, color: Color(0xFF00D9FF), size: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      // Optional confirmation dialog here
                                      try {
                                        await _goalService.deleteGoal(goal.id);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('🗑️ Goal deleted successfully!'), backgroundColor: Color(0xFF10C655)),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                      }
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6B35).withValues(alpha: isDark ? 0.2 : 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.delete_outline, color: Color(0xFFFF6B35), size: 16),
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor) {
    final isDark = _themeManager.isDarkMode;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFBF00).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.track_changes, color: Color(0xFFFFBF00), size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'No Goals Yet',
              style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Start your journey by creating your first goal',
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showGoalModal(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFBF00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text('Create Your First Goal', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class EditGoalModal extends StatefulWidget {
  final GoalModel? goal;

  const EditGoalModal({super.key, this.goal});

  @override
  State<EditGoalModal> createState() => _EditGoalModalState();
}

class _EditGoalModalState extends State<EditGoalModal> {
  final GoalService _goalService = GoalService();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late GoalCategory _selectedCategory;
  DateTime? _targetDate;
  bool _isLoading = false;

  final Map<GoalCategory, Map<String, dynamic>> _categoryData = {
    GoalCategory.fitness: {'icon': '💪', 'color': const Color(0xFFFF6B35)},
    GoalCategory.learning: {'icon': '📚', 'color': const Color(0xFF00D9FF)},
    GoalCategory.wellness: {'icon': '❤️', 'color': const Color(0xFFFF2D95)},
    GoalCategory.career: {'icon': '💼', 'color': const Color(0xFFB24BF3)},
    GoalCategory.habits: {'icon': '⭐', 'color': const Color(0xFFFFBF00)},
    GoalCategory.personal: {'icon': '🎯', 'color': const Color(0xFF9FE82E)},
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal?.title ?? '');
    _descController = TextEditingController(text: widget.goal?.description ?? '');
    _selectedCategory = widget.goal?.category ?? GoalCategory.fitness;
    _targetDate = widget.goal?.targetDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    if (_titleController.text.trim().isEmpty) return;
    if (_targetDate == null) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Not logged in");

      if (widget.goal == null) {
        // Create new
        final goal = GoalModel(
          id: '', 
          userId: user.uid,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          category: _selectedCategory,
          targetDate: _targetDate!,
          createdAt: DateTime.now(),
        );
        await _goalService.addGoal(goal);
      } else {
        // Update existing
        final updatedGoal = widget.goal!.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          category: _selectedCategory,
          targetDate: _targetDate!,
        );
        await _goalService.updateGoal(updatedGoal);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
             content: Text(widget.goal == null ? '🎉 Successfully created goal!' : '✅ Goal updated successfully!'), 
             backgroundColor: const Color(0xFF10C655)
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager().isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final bgColor = isDark ? const Color(0xFF1B113D) : Colors.white;
    final inputColor = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF9FAFB);
    final isEditing = widget.goal != null;

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.8)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEditing ? 'Update Goal' : 'Create New Goal', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 24),
              
              const Text('Goal Title *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g., Run 5km daily',
                  filled: true,
                  fillColor: inputColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Add details about your goal...',
                  filled: true,
                  fillColor: inputColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: GoalCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  final data = _categoryData[cat]!;
                  final color = data['color'] as Color;
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withValues(alpha: 0.1) : inputColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? color : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(data['icon'] as String, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            cat.toString().split('.').last[0].toUpperCase() + cat.toString().split('.').last.substring(1),
                            style: TextStyle(
                              color: isSelected ? color : (isDark ? Colors.white70 : Colors.black87),
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Text('Target Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: inputColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _targetDate == null ? 'Select Date' : DateFormat('MMM dd, yyyy').format(_targetDate!),
                    style: TextStyle(
                      color: _targetDate == null ? Colors.grey : textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: inputColor,
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF13C6DF), Color(0xFF8B5CF6)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                           BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(isEditing ? 'Update Goal' : 'Create Goal', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
