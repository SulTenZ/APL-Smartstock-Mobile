// lib/features/stock/manage_stock_view.dart
import 'package:flutter/material.dart';
import '../../common/widgets/custom_sub_menu_button.dart';
import '../../common/color/color_theme.dart';

class ManageStockView extends StatelessWidget {
  const ManageStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    // Header dengan Tombol Back dan Judul
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        const Text(
                          'MANAJEMEN STOK',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // List Menu
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // KATEGORI: DATA MASTER
                          _buildCategoryHeader('DATA MASTER', Icons.storage),
                          const SizedBox(height: 8),
                          
                          CustomSubMenuButton(
                            icon: Icons.category,
                            title: 'Tipe Produk',
                            subtitle: 'Kelola tipe produk',
                            color: Colors.purple,
                            onTap: () => Navigator.pushNamed(context, '/product-type'),
                          ),
                          CustomSubMenuButton(
                            icon: Icons.layers,
                            title: 'Kategori',
                            subtitle: 'Atur kategori produk',
                            color: Colors.blue,
                            onTap: () => Navigator.pushNamed(context, '/category'),
                          ),
                          CustomSubMenuButton(
                            icon: Icons.branding_watermark,
                            title: 'Brand',
                            subtitle: 'Manajemen brand',
                            color: Colors.teal,
                            onTap: () => Navigator.pushNamed(context, '/brand'),
                          ),
                          CustomSubMenuButton(
                            icon: Icons.straighten,
                            title: 'Size',
                            subtitle: 'Pengaturan ukuran',
                            color: Colors.amber,
                            onTap: () => Navigator.pushNamed(context, '/size'),
                          ),
                          CustomSubMenuButton(
                            icon: Icons.inventory_2,
                            title: 'Produk',
                            subtitle: 'Daftar semua produk',
                            color: Colors.deepOrange,
                            onTap: () => Navigator.pushNamed(context, '/product'),
                          ),

                          const SizedBox(height: 24),

                          // KATEGORI: KELOLA STOK
                          _buildCategoryHeader('KELOLA STOK', Icons.inventory),
                          const SizedBox(height: 8),
                          
                          CustomSubMenuButton(
                            icon: Icons.store,
                            title: 'Batch Stok',
                            subtitle: 'Kelola batch stok',
                            color: Colors.indigo,
                            onTap: () => Navigator.pushNamed(context, '/stock-batch'),
                          ),
                          CustomSubMenuButton(
                            icon: Icons.history,
                            title: 'Riwayat Perubahan Stok',
                            subtitle: 'Lihat riwayat audit',
                            color: Colors.brown,
                            onTap: () => Navigator.pushNamed(context, '/audit-log'),
                          ),

                          const SizedBox(height: 24),

                          // KATEGORI: LAPORAN
                          _buildCategoryHeader('LAPORAN', Icons.assessment),
                          const SizedBox(height: 8),
                          
                          CustomSubMenuButton(
                            icon: Icons.download,
                            title: 'Unduh Laporan Keuangan',
                            subtitle: 'Download laporan',
                            color: Colors.red,
                            onTap: () => Navigator.pushNamed(context, '/report'),
                          ),

                          const SizedBox(height: 8),
                        ],
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

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF222222).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF222222),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
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