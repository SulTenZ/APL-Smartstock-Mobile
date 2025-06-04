// lib/features/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'home_controller.dart';
import '../../../common/widgets/custom_navbar.dart';
import '../../../common/widgets/custom_menu_button.dart';
import '../../../common/color/color_theme.dart';

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

              // Konten utama
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHeader(),
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
                              ),
                              CustomMenuButton(
                                title: "Catat Transaksi",
                                color: const Color(ColorTheme.primaryColor),
                                onTap: () {
                                  Navigator.pushNamed(context, '/transaction');
                                },
                                customIconPath: 'assets/images/catat_transaksi.png',
                              ),
                              CustomMenuButton(
                                title: "Statistik Laba",
                                color: const Color(ColorTheme.primaryColor),
                                onTap: () {
                                  _showComingSoonDialog(context);
                                },
                                customIconPath: 'assets/images/statistik_laba.png',
                                isComingSoon: true,
                              ),
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
            // Kosongkan atau isi sesuai kebutuhan
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 20),
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

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(ColorTheme.backgroundColor),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(ColorTheme.secondaryColor).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(ColorTheme.primaryColor).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(ColorTheme.primaryColor),
                        Color(0xFF424242),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(ColorTheme.primaryColor).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.construction, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  "Segera Hadir!",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(ColorTheme.primaryColor),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Fitur Statistik Laba sedang dikembangkan dan akan segera tersedia saat Proyek Profesional.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(ColorTheme.textColor),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(ColorTheme.primaryColor),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      "Tutup",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
