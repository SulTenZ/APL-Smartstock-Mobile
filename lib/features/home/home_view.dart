import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';
import '../../../common/widgets/custom_navbar.dart';
import '../../../common/widgets/custom_sub_menu_button.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<HomeController>(
                      builder: (context, controller, _) {
                        return Text(
                          'Halo, ${controller.userName}!',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF222222),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none, color: Color(0xFF555555)),
                        onPressed: () {
                          // Aksi notifikasi
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Section Title
                const Text(
                  "Menu Utama",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 20),

                // Menu Buttons
                CustomSubMenuButton(
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
                CustomSubMenuButton(
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
                CustomSubMenuButton(
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
        ),
        bottomNavigationBar: CustomNavbar(
          currentIndex: 0,
          onTap: (index) {
            // Tambahkan logika navigasi sesuai kebutuhan
          },
        ),
      ),
    );
  }
}
