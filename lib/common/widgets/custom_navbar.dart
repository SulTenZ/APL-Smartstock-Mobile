// lib/common/widgets/custom_navbar.dart
import 'package:flutter/material.dart';
import '../color/color_theme.dart';

// Import halaman target
import '../../features/home/home_view.dart';
import '../../features/transaction_history/transaction_history_view.dart';
import '../../features/stock_history/stock_history_view.dart';
import '../../features/profile/profile_view.dart';

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
    );
  }

  Widget _buildNavIcon(BuildContext context, IconData icon, int index) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == currentIndex) return;

        String targetRoute;
        switch (index) {
          case 0:
            targetRoute = '/home';
            break;
          case 1:
            targetRoute = '/transaction-history';
            break;
          case 2:
            targetRoute = '/stock-history';
            break;
          case 3:
            targetRoute = '/profile';
            break;
          default:
            targetRoute = '/home';
        }

        navigateWithDirectionalSlide(context, targetRoute, currentIndex, index);
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
          color: isSelected ? Colors.black : const Color(ColorTheme.secondaryColor),
          size: 22,
        ),
      ),
    );
  }

  void navigateWithDirectionalSlide(BuildContext context, String routeName, int from, int to) {
    final isBack = to < from;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => getTargetPage(routeName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideTween = Tween<Offset>(
            begin: Offset(isBack ? -0.2 : 0.2, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutExpo));

          return SlideTransition(
            position: animation.drive(slideTween),
            child: child,
          );
        },
      ),
    );
  }

  Widget getTargetPage(String routeName) {
    switch (routeName) {
      case '/home':
        return const HomeView();
      case '/transaction-history':
        return const TransactionHistoryView();
      case '/stock-history':
        return const StockHistoryView();
      case '/profile':
        return const ProfileView();
      default:
        return const HomeView();
    }
  }
}