import 'package:flutter/material.dart';
import 'product_type/product_type_view.dart';
import 'category/category_view.dart';
import 'brand/brand_view.dart';
import 'size/size_view.dart';
import 'product/product_view.dart';
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
              // Header - Icon back + Judul center pakai Stack
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

              // Menu List
              Expanded(
                child: ListView(
                  children: [
                    CustomSubMenuButton(
                      icon: Icons.category,
                      title: 'Tipe Produk',
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductTypeView(),
                        ),
                      ),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.layers,
                      title: 'Kategori',
                      color: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryView(),
                        ),
                      ),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.branding_watermark,
                      title: 'Brand',
                      color: Colors.teal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrandView(),
                        ),
                      ),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.straighten,
                      title: 'Size',
                      color: Colors.amber,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SizeView(),
                        ),
                      ),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.inventory_2,
                      title: 'Produk',
                      color: Colors.deepOrange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductView(),
                        ),
                      ),
                    ),
                    CustomSubMenuButton(
                      icon: Icons.store,
                      title: 'Stok',
                      color: Colors.green,
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
    );
  }
}
