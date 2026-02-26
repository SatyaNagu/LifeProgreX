import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeProgreX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E1A50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Consistent flat gradient matching Onboarding
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B113D), Color(0xFF050505), Color(0xFF140A05)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: child,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: SafeArea(
        child: Column(
          children: [
            // Push content up slightly by removing the top Spacer and using a fixed small padding
            const SizedBox(height: 50),

            // X Logo
            Center(
              child: SvgPicture.asset(
                'Assets/ui_icon.svg',
                width: 120, // Slightly reduced to ensure it fits small screens
              ),
            ),
            const SizedBox(height: 16),

            // Gradient App Title
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFFFB380)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: const Text(
                'LifeProgreX',
                style: TextStyle(
                  fontSize: 44, // Slightly scaled to prevent word wrap
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Progress made simple',
              style: TextStyle(
                color: Color(0xFFD3D3D3),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Feature Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFeatureChip(
                          Icons.show_chart,
                          const Color(0xFF4B23B7), // Deep purple
                          'Track Progress',
                        ),
                        const SizedBox(width: 12),
                        _buildFeatureChip(
                          Icons.emoji_events_outlined,
                          const Color(0xFFE26830), // Warm orange
                          'Earn Rewards',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureChip(
                      Icons.bolt,
                      const Color(0xFF4B23B7), // Deep purple
                      'AI Insights',
                    ),
                  ],
                ),
              ),
            ),

            // The main spacer to push the buttons firmly to the bottom
            const Spacer(),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B4DFF), Color(0xFF5A31F4)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B4DFF).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the onboarding screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GET STARTED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Login / Sign Up Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSecondaryButton('LOGIN', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSecondaryButton('SIGN UP', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Statistics Row
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem('• 50K+ USERS'),
                  const SizedBox(width: 20),
                  _buildStatItem('• 1M+ HABITS'),
                  const SizedBox(width: 20),
                  _buildStatItem('• 4.9 RATING'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData iconData, Color iconBgColor, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(
          0xFF1B1824,
        ).withValues(alpha: 0.8), // Semi-transparent dark bg
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF0F0C16).withValues(alpha: 0.5),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF8E8E8E),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}
