import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B113D), Color(0xFF050505), Color(0xFF140A05)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
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
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last updated: Feb 2026',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      // Top Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF482B96), Color(0xFF9E5C5D)],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Fair & Transparent',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Our commitment to your trust',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // List of points
                      _buildTermItem(
                        icon: Icons.check,
                        title: '1. Acceptance of Terms',
                        description:
                            'By accessing and using LifeProgreX, you accept and agree to be bound by the terms and provision of this agreement.',
                      ),
                      _buildTermItem(
                        icon: Icons.person_outline,
                        title: '2. User Account',
                        description:
                            'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
                      ),
                      _buildTermItem(
                        icon: Icons.lock_outline,
                        title: '3. Privacy Policy',
                        description:
                            'Your use of LifeProgreX is also governed by our Privacy Policy. We collect and use your personal information to provide and improve our services.',
                      ),
                      _buildTermItem(
                        icon: Icons.balance,
                        title: '4. Data Usage',
                        description:
                            'LifeProgreX uses your habit tracking data to provide personalized insights and AI-powered recommendations. Your data is stored securely and never shared with third parties without your consent.',
                      ),
                      _buildTermItem(
                        icon: Icons.error_outline,
                        title: '5. Modifications',
                        description:
                            'We reserve the right to modify these terms at any time. Continued use of the service after changes constitutes acceptance of the new terms.',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161224),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF281E4D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF8B75F5), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
