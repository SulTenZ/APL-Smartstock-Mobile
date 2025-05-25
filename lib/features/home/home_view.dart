import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';
import '../../../common/widgets/custom_navbar.dart';
import '../../../common/widgets/custom_menu_button.dart';
import '../stock/manage_stock_view.dart';
import '../transaction/transaction_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header - Centered Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Center(
                    child: Text(
                      "MENU UTAMA",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Menu Buttons with spacing from header
                Expanded(
                  child: Column(
                    children: [
                      CustomMenuButton(
                        icon: Icons.inventory_2,
                        title: "Manajemen Stok",
                        color: Colors.indigo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ManageStockView()),
                          );
                        },
                      ),
                      CustomMenuButton(
                        icon: Icons.shopping_cart,
                        title: "Catat Transaksi",
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TransactionView()),
                          );
                        },
                      ),
                      CustomMenuButton(
                        icon: Icons.bar_chart,
                        title: "Statistik Laba",
                        color: Colors.orange,
                        onTap: () {
                          // Belum diimplementasikan
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
}
