// lib/common/widgets/custom_navbar.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../color/color_theme.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(ColorTheme.backgroundColor).withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: const Color(ColorTheme.secondaryColor).withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavIcon(context, Icons.home, 0),
                _buildNavIcon(context, Icons.shopping_cart, 1),
                _buildNavIcon(context, Icons.receipt_long, 2),
                _buildNavIcon(context, Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, IconData icon, int index) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == currentIndex) return;
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
            break;
          case 1:
            Navigator.pushNamed(context, '/transaction-history');
            break;
          case 2:
            Navigator.pushNamed(context, '/stock-history');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
        }
        onTap(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.grey.shade300 : Colors.transparent,
        ),
        child: Icon(
          icon,
          color:
              isSelected
                  ? Colors.black
                  : const Color(ColorTheme.secondaryColor),
          size: 22,
        ),
      ),
    );
  }
}
