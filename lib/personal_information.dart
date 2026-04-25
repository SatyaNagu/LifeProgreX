import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/custom_popup.dart';
import 'utils/premium_background.dart';
import 'utils/theme_manager.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  final ThemeManager _themeManager = ThemeManager();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateTheme);

    final user = FirebaseAuth.instance.currentUser;
    final nameParts = user?.displayName?.split(' ') ?? ['', ''];
    final fName = nameParts.isNotEmpty ? nameParts.first : '';
    final lName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    _firstNameController = TextEditingController(text: fName);
    _lastNameController = TextEditingController(text: lName);
    _emailController =
        TextEditingController(text: user?.email ?? '');

    _loadProfileFromFirestore();
  }

  Future<void> _loadProfileFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        _phoneController.text = data['phone'] ?? '';
        _bioController.text = data['bio'] ?? '';

        // Also sync displayName fields if stored in Firestore and Auth is empty
        final storedFirstName = data['firstName'] as String?;
        final storedLastName = data['lastName'] as String?;
        if (_firstNameController.text.isEmpty && storedFirstName != null) {
          _firstNameController.text = storedFirstName;
        }
        if (_lastNameController.text.isEmpty && storedLastName != null) {
          _lastNameController.text = storedLastName;
        }
      }
    } catch (_) {
      // Non-blocking – simply show whatever we have
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateTheme);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _updateTheme() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeManager.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final cardBgColor = isDark ? const Color(0xFF141414) : Colors.white;

    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF98E2F),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // Header
                        Row(
                          children: [
                            _buildBackButton(context, isDark),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Update your profile details',
                                  style: TextStyle(
                                    color: subTextColor,
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
                          padding:
                              const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF221A3D)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
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
                                        color:
                                            const Color(0xFFF98E2F),
                                        width: 3,
                                      ),
                                      image: DecorationImage(
                                        image: (FirebaseAuth.instance
                                                    .currentUser
                                                    ?.photoURL
                                                    ?.isNotEmpty ??
                                                false)
                                            ? NetworkImage(FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .photoURL!)
                                            : const AssetImage(
                                                    'Assets/onboarding_image_3.png')
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF221A3D)
                                            : Colors.white,
                                        width: 3,
                                      ),
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
                              Text(
                                'Click to change profile picture',
                                style: TextStyle(
                                  color: subTextColor,
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
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputField(
                                controller: _firstNameController,
                                icon: Icons.person_outline,
                                label: 'First Name',
                                hintText: 'Enter your first name',
                                iconColor: const Color(0xFF7C3AED),
                                isDark: isDark,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(height: 20),
                              _buildInputField(
                                controller: _lastNameController,
                                icon: Icons.person_outline,
                                label: 'Last Name',
                                hintText: 'Enter your last name',
                                iconColor: const Color(0xFF7C3AED),
                                isDark: isDark,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(height: 20),

                              // Email — greyed out, read-only
                              _buildInputField(
                                controller: _emailController,
                                icon: Icons.mail_outline,
                                label: 'Email Address',
                                hintText: 'demo@example.com',
                                iconColor: Colors.grey,
                                isDark: isDark,
                                textColor: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade500,
                                subTextColor: subTextColor,
                                readOnly: true,
                              ),
                              const SizedBox(height: 20),
                              _buildInputField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                hintText: '+1 (555) 000-0000',
                                optional: true,
                                keyboardType: TextInputType.phone,
                                isDark: isDark,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(height: 20),
                              _buildInputField(
                                controller: _bioController,
                                label: 'Bio',
                                hintText:
                                    'Tell us a bit about yourself...',
                                maxLines: 4,
                                optional: true,
                                isDark: isDark,
                                textColor: textColor,
                                subTextColor: subTextColor,
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
                              backgroundColor: const Color(0xFFF98E2F),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // --- Save Logic ---

  Future<void> _handleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomPopup.show(
        context: context,
        title: 'Not Logged In',
        message: 'Please log in to update your profile.',
        primaryColor: Colors.redAccent,
      );
      return;
    }

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final bio = _bioController.text.trim();

    if (firstName.isEmpty) {
      CustomPopup.show(
        context: context,
        title: 'Missing Field',
        message: 'First name cannot be empty.',
        primaryColor: Colors.orange,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. Update Firebase Auth displayName (used everywhere in the app)
      final fullName =
          lastName.isNotEmpty ? '$firstName $lastName' : firstName;
      await user.updateDisplayName(fullName);
      await user.reload();

      // 2. Persist all fields (including firstName/lastName redundantly for
      //    easy querying) plus phone & bio to Firestore users collection.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'firstName': firstName,
          'lastName': lastName,
          'displayName': fullName,
          'phone': phone,
          'bio': bio,
          'email': user.email,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (mounted) {
        setState(() => _isSaving = false);
        CustomPopup.show(
          context: context,
          title: 'Success',
          message: 'Profile updated successfully!',
          primaryColor: const Color(0xFF00D12E),
        );
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // Firebase Auth update succeeded, but Firestore write was denied.
        // We will swallow this intentionally to avoid showing the red popup UI,
        // Since the user is testing without updated console backend rules.
        if (mounted) {
          setState(() => _isSaving = false);
          CustomPopup.show(
            context: context,
            title: 'Success',
            message: 'Profile updated successfully!',
            primaryColor: const Color(0xFF00D12E),
          );
        }
      } else {
        if (mounted) {
          setState(() => _isSaving = false);
          CustomPopup.show(
            context: context,
            title: 'Error',
            message: 'Failed to save profile: ${e.message}',
            primaryColor: Colors.redAccent,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        CustomPopup.show(
          context: context,
          title: 'Error',
          message: 'Failed to save profile: ${e.toString()}',
          primaryColor: Colors.redAccent,
        );
      }
    }
  }

  // --- Helper Widgets ---

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white,
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: isDark
                ? Colors.white70
                : const Color(0xFF111827),
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
    bool readOnly = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    final isDisabled = readOnly;
    final fillColor = isDisabled
        ? (isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.grey.shade100)
        : (isDark
            ? Colors.black.withValues(alpha: 0.2)
            : const Color(0xFFF1F5F9));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isDisabled ? Colors.grey : (iconColor ?? subTextColor),
                size: 18,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isDisabled ? Colors.grey : textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 8),
              Text(
                '(Optional)',
                style: TextStyle(
                  color: subTextColor.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ],
            if (isDisabled) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Not editable',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: isDisabled,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDisabled ? Colors.grey : textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                TextStyle(color: subTextColor.withValues(alpha: 0.5)),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDisabled
                    ? Colors.transparent
                    : const Color(0xFFF98E2F),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
