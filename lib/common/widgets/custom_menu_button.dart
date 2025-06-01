// lib/common/widgets/custom_menu_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../color/color_theme.dart';

class CustomMenuButton extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final String? customIconPath;
  final bool isComingSoon;

  const CustomMenuButton({
    Key? key,
    this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.customIconPath,
    this.isComingSoon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(ColorTheme.backgroundColor),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(ColorTheme.secondaryColor).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (customIconPath != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          customIconPath!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      Icon(icon, size: 40, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(ColorTheme.textColor),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Coming Soon Badge
              if (isComingSoon)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(ColorTheme.primaryColor),
                          Color(0xFF424242),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(ColorTheme.primaryColor).withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Segera",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
