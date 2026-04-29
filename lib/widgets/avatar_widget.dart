import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;
  final String uid;

  const AvatarWidget({
    super.key,
    required this.width,
    required this.height,
    required this.isDark,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        String? base64Image;
        if (!snapshot.hasError && snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          base64Image = data?['profilePictureBase64'] as String?;
        }

        final photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
        final hasNetworkPhoto = photoUrl != null && photoUrl.isNotEmpty;

        ImageProvider? imageProvider;
        if (base64Image != null && base64Image.isNotEmpty) {
          try {
            imageProvider = MemoryImage(base64Decode(base64Image));
          } catch (e) {
            // Invalid base64, falls back
          }
        } else if (hasNetworkPhoto) {
          imageProvider = NetworkImage(photoUrl);
        }

        final hasImage = imageProvider != null;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF221A3D) : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFF98E2F), // Orange border
              width: 2,
            ),
            image: hasImage
                ? DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )
                : null,
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
          child: hasImage
              ? null
              : Icon(
                  Icons.person,
                  color: isDark ? Colors.white70 : const Color(0xFF9CA3AF),
                  size: width * 0.55,
                ),
        );
      },
    );
  }
}
