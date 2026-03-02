import 'package:flutter/material.dart';
import 'utils/custom_popup.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController _firstNameController = TextEditingController(text: 'Demo');
  final TextEditingController _lastNameController = TextEditingController(text: 'User');
  final TextEditingController _emailController = TextEditingController(text: 'demo@example.com');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // Header Loop
                Row(
                  children: [
                    _buildBackButton(context),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Update your profile details',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Profile Image Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF221A3D), // Deep purple card
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFF98E2F), // Orange border
                                width: 3,
                              ),
                              image: const DecorationImage(
                                image: AssetImage('Assets/onboarding_image_3.png'), 
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED), // Purple floating action button
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF221A3D), width: 3), // Match card background
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Click to change profile picture',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Form Fields Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414), // Very dark gray, almost black
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        controller: _firstNameController,
                        icon: Icons.person_outline,
                        label: 'First Name',
                        hintText: 'Demo',
                        iconColor: const Color(0xFF7C3AED),
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                        label: 'Last Name',
                        hintText: 'User',
                        iconColor: const Color(0xFF7C3AED),
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _emailController,
                        icon: Icons.mail_outline,
                        label: 'Email Address',
                        hintText: 'demo@example.com',
                        iconColor: const Color(0xFF7C3AED),
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hintText: '+1 (555) 000-0000',
                        optional: true,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _bioController,
                        label: 'Bio',
                        hintText: 'Tell us a bit about yourself...',
                        maxLines: 4,
                        optional: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF98E2F), // Orange
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSaving 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.05),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white70,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    IconData? icon,
    required String label,
    required String hintText,
    Color? iconColor,
    int maxLines = 1,
    bool optional = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? Colors.white54, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 8),
              const Text(
                '(Optional)',
                style: TextStyle(
                  color: Colors.white30,
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.2), // Dark inset
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF98E2F)), // Orange focus
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSaving = false);
      CustomPopup.show(
        context: context,
        title: 'Success',
        message: 'Profile Updated Successfully!',
        primaryColor: const Color(0xFF00D12E),
      );
    }
  }
}
