// lib/features/transaction/transaction_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_controller.dart';

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
    // Tunggu sampai frame pertama sudah dirender baru fetch data!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInit) {
        Provider.of<TransactionController>(context, listen: false).initData();
        _isInit = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, controller, _) {
        // HAPUS segala inisialisasi/fetch di sini!
        return Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xFFF2F2F2),
            elevation: 0,
            title: const Text(
              "Transaksi",
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () => _showCart(context, controller),
                    ),
                    if (controller.cart.isNotEmpty)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.black,
                          child: Text(
                            '${controller.cart.length}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  onChanged: controller.setSearch,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Tipe Produk'),
                        value: controller.selectedProductTypeId,
                        items:
                            controller.productTypes
                                .map<DropdownMenuItem<String>>((type) {
                                  return DropdownMenuItem(
                                    value: type['id'].toString(),
                                    child: Text(type['name']),
                                  );
                                })
                                .toList(),
                        onChanged: (val) => controller.setFilter(typeId: val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('Kategori'),
                        value: controller.selectedCategoryId,
                        items:
                            controller.categories.map<DropdownMenuItem<int>>((cat) {
                              return DropdownMenuItem(
                                value: cat['id'],
                                child: Text(cat['nama']),
                              );
                            }).toList(),
                        onChanged: (val) => controller.setFilter(categoryId: val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children:
                      controller.brands.map((brand) {
                        final isSelected =
                            controller.selectedBrandId == brand['id'].toString();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(brand['nama']),
                            selected: isSelected,
                            onSelected: (_) {
                              final selected =
                                  controller.selectedBrandId == brand['id'].toString();
                              controller.setFilter(
                                brandId: selected ? null : brand['id'].toString(),
                              );
                            },
                            selectedColor: Colors.grey[700],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            backgroundColor: Colors.grey[300],
                          ),
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 8),
              Expanded(
                child:
                    controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : controller.products.isEmpty
                        ? const Center(
                          child: Text(
                            "Produk tidak Ditemukan",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          itemCount: controller.products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.7,
                              ),
                          itemBuilder: (context, index) {
                            final product = controller.products[index];
                            return GestureDetector(
                              onTap:
                                  () => _showProductDetail(
                                    context,
                                    product,
                                    controller,
                                  ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.zero,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.zero,
                                        child: Image.network(
                                          product['image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            product['nama'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "Rp${product['hargaJual']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => StatefulBuilder(
            builder: (context, setState) {
              final stokUkuran =
                  selectedSizeId != null
                      ? sizes.firstWhere(
                        (s) => s['size']['id'] == selectedSizeId,
                      )['quantity']
                      : 0;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Stok tersedia: ${product['stock']}"),
                    const SizedBox(height: 8),
                    if (selectedSizeId != null)
                      Text("Stok ukuran ini: $stokUkuran"),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(product['image'], width: 80),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text("Ukuran: "),
                                DropdownButton<String>(
                                  value: selectedSizeId,
                                  items:
                                      sizes.map<DropdownMenuItem<String>>((item) {
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
                                      selectedSizeLabel =
                                          selected['size']['label'];
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Jumlah : "),
                                IconButton(
                                  onPressed: () => setState(() {
                                    if (quantity > 1) quantity--;
                                  }),
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(quantity.toString()),
                                IconButton(
                                  onPressed: () => setState(() => quantity++),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                      ),
                      onPressed: () {
                        if (selectedSizeId == null) return;
                        controller.addToCart({
                          ...product,
                          'quantity': quantity,
                          'size': selectedSizeLabel,
                          'sizeId': selectedSizeId,
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Tambah",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              final totalHarga = controller.totalHarga;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Keranjang Anda",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (controller.cart.isEmpty)
                    const Center(child: Text("Belum ada item di keranjang")),
                  ...controller.cart.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final int qty = item['quantity'];
                    final double price = item['hargaJual']?.toDouble() ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item['image'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'] ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Harga : Rp${price.toStringAsFixed(0)}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Kategori : ${item['brand']?['nama'] ?? '-'}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Ukuran : ${item['size'] ?? '-'}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Text("Jumlah :"),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        if (qty > 1) {
                                          controller.cart[index]['quantity']--;
                                        } else {
                                          controller.removeFromCart(index);
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    '$qty',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        controller.cart[index]['quantity']++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Harga",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Rp${totalHarga.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                          controller.cart.isEmpty
                              ? null
                              : () => Navigator.pushNamed(
                                context,
                                '/transaction_submission',
                              ),
                      child: const Text(
                        "Lanjutkan Transaksi",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
