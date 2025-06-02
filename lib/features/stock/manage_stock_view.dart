// lib/features/stock/manage_stock_view.dart
import 'package:flutter/material.dart';
import '../../common/widgets/custom_sub_menu_button.dart';

class ManageStockView extends StatelessWidget {
  const ManageStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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

              const SizedBox(height: 40),

              Expanded(
                child: ListView(
                  children: [
                    CustomSubMenuButton(
                      icon: Icons.category,
                      title: 'Tipe Produk',
                      color: Colors.purple,
                      onTap: () => Navigator.pushNamed(context, '/product-type'),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.layers,
                      title: 'Kategori',
                      color: Colors.blue,
                      onTap: () => Navigator.pushNamed(context, '/category'),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.branding_watermark,
                      title: 'Brand',
                      color: Colors.teal,
                      onTap: () => Navigator.pushNamed(context, '/brand'),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.straighten,
                      title: 'Size',
                      color: Colors.amber,
                      onTap: () => Navigator.pushNamed(context, '/size'),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.inventory_2,
                      title: 'Produk',
                      color: Colors.deepOrange,
                      onTap: () => Navigator.pushNamed(context, '/product'),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.store,
                      title: 'Batch Stok',
                      color: Colors.indigo,
                      onTap: () => Navigator.pushNamed(context, '/stock-batch'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
