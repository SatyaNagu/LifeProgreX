import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utils/theme_manager.dart';
import '../utils/premium_background.dart';
import '../landing_screen.dart';
import 'analytics_screen.dart';
import '../settings.dart';
import '../services/firestore_service.dart';
import 'dart:math';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    text: json['text'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> with TickerProviderStateMixin {
  final ThemeManager _themeManager = ThemeManager();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  final String _historyKey = "lifeprogrex_ai_messages";

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _themeManager.addListener(_updateTheme);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateTheme() {
    if (mounted) setState(() {});
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_historyKey);
    if (stored != null) {
      final List<dynamic> decoded = jsonDecode(stored);
      setState(() {
        _messages.addAll(decoded.map((m) => ChatMessage.fromJson(m)).toList());
      });
      _scrollToBottom();
    } else {
      // Add welcome message if new user
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Hi! I'm MAX, your AI life coach. I've analyzed your progress and I'm here to help you achieve your goals. How can I support you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_messages.map((m) => m.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    _inputController.clear();
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });
    _saveHistory();
    _scrollToBottom();

    // Simulated "Thinking" delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final aiResponse = await _getAIResponse(text);
    
    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _saveHistory();
      _scrollToBottom();
    }
  }

  Future<String> _getAIResponse(String userMessage) async {
    final lower = userMessage.toLowerCase();
    
    // Attempt to pull user data for contextual response (simplification for demo)
    int streak = 0;
    try {
      final habits = await FirestoreService().getHabitsStream().first;
      if (habits.isNotEmpty) {
        streak = habits.map((h) => h.currentStreak).reduce(max);
      }
    } catch (_) {}

    if (lower.contains('habit') || lower.contains('streak')) {
      return "You're currently hitting a $streak-day streak! That's fantastic momentum. To improve further, try 'habit stacking'—linking a new habit to something you already do every day. Studies show this increases success rates by 65%!";
    } else if (lower.contains('mood') || lower.contains('feel')) {
      return "I've noticed from your logs that your energy tends to be highest in the mornings. Perhaps we can schedule your most challenging habits for that window? Reflecting on what triggers positive moods can help us optimize your routine.";
    } else if (lower.contains('goal') || lower.contains('improve')) {
      return "Based on your progress, you've completed several milestones this week. To maintain this growth, focus on one small 'keystone' goal tomorrow. What's the one thing that would make everything else easier?";
    } else if (lower.contains('motivation') || lower.contains('help')) {
      return "Success is the sum of small efforts repeated day in and day out. You've already made 45 total completions! Don't focus on the mountain, just focus on the next step. I'm right here with you.";
    } else if (lower.contains('report') || lower.contains('analytics')) {
      return "Your personalized growth report shows you're most consistent with wellness habits. Check your Detailed Analytics page for a full breakdown, but my immediate advice: protect that morning routine!";
    }
    
    return "That's an interesting perspective! Based on your current progress patterns, I'd suggest focusing on maintaining your consistency while gradually introducing one new small challenge. How does that sound for your next growth area?";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final themeColor = const Color(0xFFB24BF3);

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Column(
              children: [
                _buildHeader(textColor, isDark),
                Expanded(
                  child: Stack(
                    children: [
                      _buildMessagesList(isDark, textColor, themeColor),
                      if (_messages.length <= 1 && !_isTyping)
                        Positioned(
                          bottom: 100,
                          left: 0,
                          right: 0,
                          child: _buildQuickPrompts(isDark, textColor),
                        ),
                    ],
                  ),
                ),
                _buildInputArea(isDark, textColor, themeColor),
                if (MediaQuery.of(context).viewInsets.bottom == 0)
                  _buildBottomNav(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, bool isDark) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 20, right: 20, bottom: 16),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1A0B2E) : Colors.white).withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingScreen())),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.1 : 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)),
                  ),
                  child: Icon(Icons.chevron_left, color: textColor, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Coach',
                    style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Meet MAX - Your Personal Growth Guide',
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAvatarCard(isDark),
        ],
      ),
    );
  }

  Widget _buildAvatarCard(bool isDark) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB24BF3).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.asset(
              'Assets/ai_coach_max.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                'https://images.unsplash.com/photo-1675557009875-436f2976302e?q=80&w=430&auto=format&fit=crop',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF1F1033),
                  child: const Icon(Icons.smart_toy_outlined, color: Colors.white24, size: 40),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [const Color(0xFFB24BF3).withValues(alpha: 0.8), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFFFBF00), size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'MAX AI Coach',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(bool isDark, Color textColor, Color themeColor) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildTypingIndicator(isDark, themeColor);
        }
        final msg = _messages[index];
        return _buildMessageBubble(msg, isDark, textColor, themeColor);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isDark, Color textColor, Color themeColor) {
    final alignment = msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start;
    final bubbleColor = msg.isUser 
        ? themeColor 
        : (isDark ? const Color(0xFF1F1033).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9));
    final bubbleTextColor = msg.isUser ? Colors.white : (isDark ? Colors.white : const Color(0xFF111827));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: msg.isUser ? null : Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(color: bubbleTextColor, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('h:mm a').format(msg.timestamp),
                    style: TextStyle(
                      color: msg.isUser ? Colors.white60 : Colors.black45,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F1033).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) => _buildTypingDot(index, themeColor)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index, Color themeColor) {
    return _TypingDot(color: themeColor, delay: index * 200);
  }

  Widget _buildQuickPrompts(bool isDark, Color textColor) {
    final prompts = [
      "How can I improve my habits?",
      "Show me my progress",
      "I need motivation",
      "Analyze my mood patterns"
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Quick Questions:',
              style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.2,
            ),
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                   _inputController.text = prompts[index];
                   HapticFeedback.lightImpact();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: (isDark ? const Color(0xFF1F1033) : Colors.white).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    prompts[index],
                    style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark, Color textColor, Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1A0B2E) : Colors.white).withValues(alpha: 0.8),
        border: Border(top: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _inputController,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Ask MAX anything...',
                  hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[400], fontSize: 14),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [themeColor, themeColor.withValues(alpha: 0.8)]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: themeColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B), // Fixed dark gray
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LandingScreen(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }),
          _buildNavItem(Icons.bar_chart_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const AnalyticsScreen(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }),
          _buildNavItem(Icons.auto_awesome_outlined, const Color(0xFFB24BF3), true, null),
          _buildNavItem(Icons.settings_outlined, Colors.white54, false, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, Color color, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final Color color;
  final int delay;

  const _TypingDot({required this.color, required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6 * _animation.value,
          height: 6 * _animation.value,
          decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.6), shape: BoxShape.circle),
        );
      },
    );
  }
}
