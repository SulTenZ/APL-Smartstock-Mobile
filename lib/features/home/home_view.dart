// lib/features/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'home_controller.dart';
import '../../../common/widgets/custom_navbar.dart';
import '../../../common/widgets/custom_menu_button.dart';
import '../../../common/color/color_theme.dart';
import '../stock/manage_stock_view.dart';
import '../transaction/transaction_view.dart';

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
                const Color(ColorTheme.primaryColor).withOpacity(0.15), // Warna utama dengan opacity
                const Color(ColorTheme.secondaryColor).withOpacity(0.08), // Warna sekunder dengan opacity
                const Color(ColorTheme.backgroundColor), // Putih
                const Color(0xFFF8F9FA), // Very light gray
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Gradient bulat besar di pojok kiri atas (mirip gambar)
              Positioned(
                top: -150,
                left: -150,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(ColorTheme.primaryColor).withOpacity(0.2),
                        const Color(ColorTheme.primaryColor).withOpacity(0.1),
                        const Color(ColorTheme.primaryColor).withOpacity(0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Gradient bulat di pojok kanan atas
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(ColorTheme.secondaryColor).withOpacity(0.25),
                        const Color(ColorTheme.secondaryColor).withOpacity(0.15),
                        const Color(ColorTheme.secondaryColor).withOpacity(0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Gradient bulat besar di sisi kanan (mirip gambar)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                right: -200,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(ColorTheme.primaryColor).withOpacity(0.18),
                        const Color(ColorTheme.primaryColor).withOpacity(0.12),
                        const Color(ColorTheme.primaryColor).withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Gradient bulat di pojok kiri bawah
              Positioned(
                bottom: -180,
                left: -180,
                child: Container(
                  width: 360,
                  height: 360,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(ColorTheme.secondaryColor).withOpacity(0.2),
                        const Color(ColorTheme.secondaryColor).withOpacity(0.12),
                        const Color(ColorTheme.secondaryColor).withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Gradient bulat kecil di pojok kanan bawah
              Positioned(
                bottom: -80,
                right: -80,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(ColorTheme.primaryColor).withOpacity(0.15),
                        const Color(ColorTheme.primaryColor).withOpacity(0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Gradient bulat tambahan di tengah kiri
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: -60,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(ColorTheme.secondaryColor).withOpacity(0.12),
                        const Color(ColorTheme.secondaryColor).withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Konten utama - MENGGUNAKAN STRUKTUR ASLI
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Header Section - MENGGUNAKAN STRUKTUR ASLI
                      Padding(
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
                            // GARIS DENGAN GRADIENT
                            Container(
                              width: 60,
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
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

                      // Menu Items (Scrollable) - MENGGUNAKAN STRUKTUR ASLI
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomMenuButton(
                                title: "Manajemen Stok",
                                color: const Color(ColorTheme.primaryColor),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ManageStockView()),
                                  );
                                },
                                customIconPath: 'assets/images/manajemen_stok.png',
                              ),
                              CustomMenuButton(
                                title: "Catat Transaksi",
                                color: const Color(ColorTheme.primaryColor),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TransactionView()),
                                  );
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
            // Navigasi sesuai kebutuhan
          },
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
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
                  child: const Icon(
                    Icons.construction,
                    color: Colors.white,
                    size: 40,
                  ),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(ColorTheme.primaryColor),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shadowColor: Colors.transparent,
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