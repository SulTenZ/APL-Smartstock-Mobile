// lib/features/stock/product/product_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/color/color_theme.dart';
import 'product_controller.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductController>(context, listen: false)
          .getProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final controller = context.read<ProductController>();
      if (!controller.isLoadingMore && controller.hasMore) {
        controller.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProductController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "DAFTAR PRODUK",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF222222),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final result =
                            await Navigator.pushNamed(context, '/product/create');
                        if (result == true) {
                          controller.getProducts(refresh: true);
                        }
                      },
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) => controller.searchProducts(value),
                decoration: InputDecoration(
                  hintText: 'Cari Produk',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<ProductController>(
                builder: (context, consumerController, child) {
                  if (consumerController.isLoading && consumerController.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (consumerController.products.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada produk yang tersedia'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: consumerController.products.length + (consumerController.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == consumerController.products.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final product = consumerController.products[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(ColorTheme.secondaryColor)
                                .withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.9),
                              blurRadius: 8,
                              spreadRadius: -3,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(ColorTheme.secondaryColor)
                                      .withOpacity(0.08),
                                  border: Border.all(
                                    color: const Color(ColorTheme.secondaryColor)
                                        .withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(ColorTheme.primaryColor)
                                          .withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: product['image'] != null
                                      ? Image.network(
                                          product['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: const Color(
                                                      ColorTheme.secondaryColor)
                                                  .withOpacity(0.1),
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Color(
                                                    ColorTheme.secondaryColor),
                                                size: 32,
                                              ),
                                            );
                                          },
                                          loadingBuilder:
                                              (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              color: const Color(
                                                      ColorTheme.secondaryColor)
                                                  .withOpacity(0.1),
                                              child: const Center(
                                                child: CircularProgressIndicator(
                                                  color: Color(
                                                      ColorTheme.primaryColor),
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: const Color(
                                                  ColorTheme.secondaryColor)
                                              .withOpacity(0.1),
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Color(
                                                ColorTheme.secondaryColor),
                                            size: 32,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['nama'] ?? '-',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: const Color(
                                            ColorTheme.primaryColor),
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            ColorTheme.primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                                    ColorTheme.primaryColor)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "Rp${product['hargaJual'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _calculateTotalStock(
                                                    product) <=
                                                (product['minStock'] ?? 0)
                                            ? Colors.red.withOpacity(0.12)
                                            : Colors.green.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _calculateTotalStock(
                                                      product) <=
                                                  (product['minStock'] ?? 0)
                                              ? Colors.red.withOpacity(0.4)
                                              : Colors.green.withOpacity(0.4),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _calculateTotalStock(product) <=
                                                    (product['minStock'] ?? 0)
                                                ? Icons.warning_rounded
                                                : Icons.check_circle_rounded,
                                            size: 14,
                                            color: _calculateTotalStock(
                                                        product) <=
                                                    (product['minStock'] ?? 0)
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Stok: ${_calculateTotalStock(product)}',
                                            style: GoogleFonts.poppins(
                                              color: _calculateTotalStock(
                                                          product) <=
                                                      (product['minStock'] ?? 0)
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color(ColorTheme.primaryColor),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                                  ColorTheme.primaryColor)
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        onTap: () async {
                                          await Navigator.pushNamed(
                                            context,
                                            '/product/detail',
                                            arguments: {'id': product['id']},
                                          );
                                          controller.getProducts(
                                              refresh: true);
                                        },
                                        child: const SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        onTap: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialog(
                                              title: const Text('Hapus Produk'),
                                              content: const Text(
                                                  'Apakah Anda yakin ingin menghapus produk ini?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child:
                                                      const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child:
                                                      const Text('Hapus'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            final success =
                                                await controller.deleteProduct(
                                                    product['id']);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(success
                                                      ? 'Produk berhasil dihapus'
                                                      : 'Gagal menghapus produk: ${controller.errorMessage ?? 'Terjadi kesalahan'}'),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: Icon(
                                            Icons.delete_rounded,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalStock(dynamic product) {
    if (product['sizes'] == null) return 0;
    final sizes = List<Map<String, dynamic>>.from(product['sizes']);
    return sizes
        .fold<num>(0, (total, size) => total + (size['quantity'] ?? 0))
        .toInt();
  }
}