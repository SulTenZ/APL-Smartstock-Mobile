// lib/features/transaction/transaction_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transaction_controller.dart';
import '../../common/widgets/custom_product_card.dart';
import '../../common/color/color_theme.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInit) {
        Provider.of<TransactionController>(context, listen: false).initData();
        _isInit = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TransactionController>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAFAFA),
              Color(ColorTheme.backgroundColor),
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: SafeArea(
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
                        color: const Color(ColorTheme.primaryColor),
                      ),
                    ),
                    Text(
                      "TRANSAKSI",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: const Color(ColorTheme.primaryColor),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Consumer<TransactionController>(
                        builder: (context, cartController, _) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.shopping_cart_outlined),
                                  onPressed: () => _showCart(context, cartController),
                                  color: const Color(ColorTheme.primaryColor),
                                ),
                              ),
                              if (cartController.cart.isNotEmpty)
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(ColorTheme.primaryColor),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      '${cartController.cart.length}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: controller.setSearch,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      hintText: 'Cari Produk',
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(ColorTheme.secondaryColor),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(ColorTheme.secondaryColor),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(ColorTheme.primaryColor),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Consumer<TransactionController>(
                builder: (context, filterController, _) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(ColorTheme.secondaryColor).withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Tipe Produk',
                                    style: GoogleFonts.poppins(color: const Color(ColorTheme.secondaryColor)),
                                  ),
                                  value: filterController.selectedProductTypeId,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(ColorTheme.secondaryColor)),
                                  style: GoogleFonts.poppins(color: const Color(ColorTheme.textColor)),
                                  items: filterController.productTypes.map<DropdownMenuItem<String>>((type) {
                                    return DropdownMenuItem(
                                      value: type['id'].toString(),
                                      child: Text(type['name']),
                                    );
                                  }).toList(),
                                  onChanged: (val) => controller.setFilter(typeId: val),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 45,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: filterController.brands.map((brand) {
                            final isSelected = filterController.selectedBrandId == brand['id'].toString();
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  brand['nama'],
                                  style: GoogleFonts.poppins(
                                    color: isSelected ? Colors.white : const Color(ColorTheme.textColor),
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (_) {
                                  final selected = filterController.selectedBrandId == brand['id'].toString();
                                  controller.setFilter(brandId: selected ? null : brand['id'].toString());
                                },
                                selectedColor: const Color(ColorTheme.primaryColor),
                                backgroundColor: Colors.white,
                                checkmarkColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected
                                      ? const Color(ColorTheme.primaryColor)
                                      : const Color(ColorTheme.secondaryColor).withOpacity(0.5),
                                  width: 1,
                                ),
                                elevation: isSelected ? 4 : 1,
                                shadowColor: Colors.black.withOpacity(0.1),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Consumer<TransactionController>(
                  builder: (context, productController, _) {
                    if (productController.isLoading) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const CircularProgressIndicator(color: Color(ColorTheme.primaryColor)),
                        ),
                      );
                    }
                    if (productController.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Color(ColorTheme.secondaryColor)),
                            const SizedBox(height: 16),
                            Text(
                              "Produk tidak ditemukan",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(ColorTheme.textColor),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Coba ubah kata kunci pencarian",
                              style: GoogleFonts.poppins(fontSize: 14, color: const Color(ColorTheme.secondaryColor)),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: productController.products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final product = productController.products[index];
                        return CustomProductCard(
                          imageUrl: product['image'],
                          name: product['nama'],
                          price: product['hargaJual'],
                          onTap: () => _showProductDetail(
                            context,
                            product,
                            controller,
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
      ),
    );
  }

  void _showProductDetail(
    BuildContext context,
    Map<String, dynamic> product,
    TransactionController controller,
  ) {
    int quantity = 1;
    final List<dynamic> sizes = product['sizes'] ?? [];
    String? selectedSizeLabel =
        sizes.isNotEmpty ? sizes[0]['size']['label'] : null;
    String? selectedSizeId = sizes.isNotEmpty ? sizes[0]['size']['id'] : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          final stokUkuran = selectedSizeId != null
              ? sizes.firstWhere(
                  (s) => s['size']['id'] == selectedSizeId,
                )['quantity']
              : 0;

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(ColorTheme.secondaryColor),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['nama'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: const Color(ColorTheme.primaryColor),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(ColorTheme.secondaryColor)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "Stok: ${product['stock']}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(ColorTheme.textColor),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (selectedSizeId != null) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(ColorTheme.secondaryColor)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Stok ukuran: $stokUkuran",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(ColorTheme.textColor),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (sizes.isNotEmpty) ...[
                    Text(
                      "Pilih Ukuran",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: const Color(ColorTheme.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(ColorTheme.secondaryColor)
                              .withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedSizeId,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(ColorTheme.secondaryColor),
                        ),
                        style: GoogleFonts.poppins(
                          color: const Color(ColorTheme.textColor),
                        ),
                        items: sizes.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item['size']['id'],
                            child: Text(item['size']['label']),
                          );
                        }).toList(),
                        onChanged: (val) {
                          final selected = sizes.firstWhere(
                            (item) => item['size']['id'] == val,
                          );
                          setState(() {
                            selectedSizeId = val;
                            selectedSizeLabel = selected['size']['label'];
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  Text(
                    "Jumlah",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(ColorTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(ColorTheme.secondaryColor)
                                .withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                if (quantity > 1) quantity--;
                              }),
                              icon: const Icon(Icons.remove, size: 20),
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              color: const Color(ColorTheme.primaryColor),
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: const Color(ColorTheme.primaryColor),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => quantity++),
                              icon: const Icon(Icons.add, size: 20),
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              color: const Color(ColorTheme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(ColorTheme.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (selectedSizeId == null && sizes.isNotEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Silakan pilih ukuran terlebih dahulu.')),
                          );
                          return;
                        }
                        controller.addToCart({
                          ...product,
                          'quantity': quantity,
                          'size': selectedSizeLabel,
                          'sizeId': selectedSizeId,
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Tambah ke Keranjang",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCart(BuildContext context, TransactionController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<TransactionController>(
              builder: (context, cartController, _) {
                final totalHarga = cartController.totalHarga;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(ColorTheme.secondaryColor),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    Center(
                      child: Text(
                        "Keranjang Anda",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(ColorTheme.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: cartController.cart.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: Color(ColorTheme.secondaryColor),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Keranjang masih kosong",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: const Color(ColorTheme.textColor),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Mulai berbelanja sekarang",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(ColorTheme.secondaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: cartController.cart.length,
                              itemBuilder: (context, index) {
                                final item = cartController.cart[index];
                                final int qty = item['quantity'];
                                final double price = item['hargaJual']?.toDouble() ?? 0;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(ColorTheme.secondaryColor).withOpacity(0.2),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          item['image'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['nama'] ?? '-',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: const Color(ColorTheme.primaryColor),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    "Rp${price.toStringAsFixed(0)}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: const Color(ColorTheme.textColor),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: const Color(ColorTheme.secondaryColor).withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Text(
                                                            "${item['brand']?['nama'] ?? '-'}",
                                                            style: GoogleFonts.poppins(fontSize: 11, color: const Color(ColorTheme.secondaryColor)),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: const Color(ColorTheme.secondaryColor).withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Text(
                                                          "Size ${item['size'] ?? '-'}",
                                                          style: GoogleFonts.poppins(fontSize: 11, color: const Color(ColorTheme.secondaryColor)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: const Color(ColorTheme.secondaryColor).withOpacity(0.3)),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      // [SOLUSI]: Panggil fungsi decrement dari controller
                                                      IconButton(
                                                        icon: const Icon(Icons.remove, size: 16),
                                                        onPressed: () => cartController.decrementCartItemQuantity(index),
                                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                        color: const Color(ColorTheme.primaryColor),
                                                      ),
                                                      Container(
                                                        width: 32,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          '$qty',
                                                          style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: const Color(ColorTheme.primaryColor),
                                                          ),
                                                        ),
                                                      ),
                                                      // [SOLUSI]: Panggil fungsi increment dari controller
                                                      IconButton(
                                                        icon: const Icon(Icons.add, size: 16),
                                                        onPressed: () => cartController.incrementCartItemQuantity(index),
                                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                        color: const Color(ColorTheme.primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    
                    if (cartController.cart.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(ColorTheme.secondaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(ColorTheme.secondaryColor).withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Harga",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(ColorTheme.primaryColor),
                              ),
                            ),
                            Text(
                              "Rp${totalHarga.toStringAsFixed(0)}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(ColorTheme.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(ColorTheme.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: cartController.cart.isEmpty
                              ? null
                              : () => Navigator.pushNamed(
                                    context,
                                    '/transaction_submission',
                                  ),
                          child: Text(
                            "Lanjutkan Transaksi",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}