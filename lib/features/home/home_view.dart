// lib/features/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_controller.dart';
import '../../common/widgets/custom_navbar.dart';
import '../../common/widgets/custom_menu_button.dart';
import '../../common/color/color_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(ColorTheme.primaryColor).withOpacity(0.15),
                const Color(ColorTheme.secondaryColor).withOpacity(0.08),
                const Color(ColorTheme.backgroundColor),
                const Color(0xFFF8F9FA),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              _buildBackground(context),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // --- HEADER DENGAN TOMBOL NOTIFIKASI ---
                      _buildHeaderWithNotification(context),
                      // ------------------------------------
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomMenuButton(
                                title: "Manajemen Stok",
                                color: const Color(ColorTheme.primaryColor),
                                onTap: () {
                                  Navigator.pushNamed(context, '/manage-stock');
                                },
                                customIconPath: 'assets/images/manajemen_stok.png',
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms, delay: 300.ms)
                                  .slideY(begin: 0.5, end: 0),
                              CustomMenuButton(
                                title: "Catat Transaksi",
                                color: const Color(ColorTheme.primaryColor),
                                onTap: () {
                                  Navigator.pushNamed(context, '/transaction');
                                },
                                customIconPath: 'assets/images/catat_transaksi.png',
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms, delay: 400.ms)
                                  .slideY(begin: 0.5, end: 0),
                              CustomMenuButton(
                                title: "Statistik Laba",
                                color: const Color(ColorTheme.primaryColor),
                                onTap: () {
                                  Navigator.pushNamed(context, '/graph');
                                },
                                customIconPath: 'assets/images/statistik_laba.png',
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms, delay: 500.ms)
                                  .slideY(begin: 0.5, end: 0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavbar(
          currentIndex: 0,
          onTap: (index) {
            // Logika navbar Anda tetap di sini
          },
        ),
      ),
    );
  }

  // --- WIDGET HEADER BARU YANG MENGGANTIKAN _buildHeader LAMA ---
  Widget _buildHeaderWithNotification(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded agar title tetap di tengah
          const Spacer(),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  "MENU UTAMA",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: const Color(ColorTheme.primaryColor),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [
                        Color(ColorTheme.primaryColor),
                        Color(ColorTheme.secondaryColor),
                        Color(ColorTheme.primaryColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Spacer untuk menyeimbangkan dan mendorong tombol ke kanan
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Consumer<HomeController>(
                builder: (context, controller, child) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, size: 30, color: Color(ColorTheme.primaryColor)),
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/notifications');
                          controller.fetchUnreadCount();
                        },
                      ),
                      if (controller.unreadCount > 0)
                        Container(
                           padding: const EdgeInsets.all(4),
                           decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${controller.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -150,
          left: -150,
          child: _buildCircle(300, ColorTheme.primaryColor),
        ),
        Positioned(
          top: -100,
          right: -100,
          child: _buildCircle(200, ColorTheme.secondaryColor),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          right: -200,
          child: _buildCircle(400, ColorTheme.primaryColor),
        ),
        Positioned(
          bottom: -180,
          left: -180,
          child: _buildCircle(360, ColorTheme.secondaryColor),
        ),
        Positioned(
          bottom: -80,
          right: -80,
          child: _buildCircle(160, ColorTheme.primaryColor),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: -60,
          child: _buildCircle(120, ColorTheme.secondaryColor),
        ),
      ],
    );
  }

  Widget _buildCircle(double size, int colorCode) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(colorCode).withOpacity(0.2),
            Color(colorCode).withOpacity(0.1),
            Color(colorCode).withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
    );
  }
}