import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeManager _themeManager = ThemeManager();

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeProgreX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B4DFF),
          brightness: _themeManager.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Soft bright gradient as shown in image
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEAF5F3), // very soft mint tint
              Color(0xFFF6F8FB), // soft white/blueish
              Color(0xFFF3EAF2), // soft lavender tint
            ],
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

            // Logo in circular white container
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'Assets/ui_icon.svg',
                    width: 55, 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Gradient App Title
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF13D3E8), Color(0xFF66BB6A)], // Cyan to Green
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: const Text(
                'LifeProgreX',
                style: TextStyle(
                  fontSize: 38, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Your Personal Growth Companion',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),

            // Feature Chips
            Column(
              children: [
                _buildPill('Track Progress', Icons.trending_up, const Color(0xFF13C6DF)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPill('Earn Rewards', Icons.workspace_premium, const Color(0xFFFDB913)),
                    const SizedBox(width: 12),
                    _buildPill('AI Insights', Icons.bolt, const Color(0xFFA565FF)),
                  ],
                ),
              ],
            ),

            const Expanded(child: SizedBox(height: 16)),

            // Card with Emojis & Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '🎯 ✨ 🚀',
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Transform your daily habits into lasting achievements with AI-powered insights',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10C655), // Bright green dot
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Free forever',
                        style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '•',
                        style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'No credit card required',
                        style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF5095FC), Color(0xFF13C6DF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5095FC).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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

            const SizedBox(height: 32),

            // Bottom Statistics Row
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem('• 50K+ USERS'),
                  const SizedBox(width: 16),
                  _buildStatItem('• 1M+ HABITS'),
                  const SizedBox(width: 16),
                  _buildStatItem('• 4.9 RATING'),
                ],
              ),
            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPill(String text, IconData iconData, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4), // Soft transparent white
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF9E9E9E), // Light grey
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _onboardingCompleted;
  bool _firebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Run initializations in parallel
    await Future.wait([
      Firebase.initializeApp(),
      _loadOnboardingStatus(),
    ]);
    if (mounted) {
      setState(() {
        _firebaseInitialized = true;
      });
    }
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_firebaseInitialized || _onboardingCompleted == null) {
      return const LoadingScreen();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          return LandingScreen(
            userName: snapshot.data!.displayName ?? 'User',
          );
        }
        
        // If not logged in, decide whether to show welcome (MyHomePage) or LoginScreen
        if (!_onboardingCompleted!) {
          return const MyHomePage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
