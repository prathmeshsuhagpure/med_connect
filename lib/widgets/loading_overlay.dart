import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isDarkMode;
  final bool isUploadingImage;
  final VoidCallback? onCancelUpload;

  const LoadingOverlay({
    super.key,
    required this.isDarkMode,
    required this.isUploadingImage,
    this.onCancelUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        absorbing: true,
        child: Stack(
          children: [
            // 🔹 Blur background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withValues(alpha: 0.2),
              ),
            ),

            // 🔹 Dialog
            Center(
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),

                    Text(
                      isUploadingImage
                          ? "Uploading profile picture…"
                          : "Saving changes…",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? DarkThemeColors.textPrimary
                            : LightThemeColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (isUploadingImage && onCancelUpload != null)
                      TextButton(
                        onPressed: onCancelUpload,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Cancel Upload",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
