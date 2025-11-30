// lib/features/stock/product/create_product/create_product_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../data/services/product_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/brand_service.dart';
import '../../../../data/services/product_type_service.dart';
import '../../../../data/services/size_service.dart';
import '../../../../data/services/stock_batch_service.dart';

class CreateProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final BrandService _brandService = BrandService();
  final ProductTypeService _productTypeService = ProductTypeService();
  final SizeService _sizeService = SizeService();
  final StockBatchService _stockBatchService = StockBatchService();

  // Form data
  String nama = '';
  String deskripsi = '';
  double hargaBeli = 0.0;
  double hargaJual = 0.0;
  int? categoryId;
  int? brandId;
  String? productTypeId;
  int minStock = 0;
  String kondisi = 'BARU';
  String? stockBatchId;
  File? imageFile;
  List<Map<String, dynamic>> sizes = [];

  // Dropdown lists
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> brands = [];
  List<dynamic> productTypes = [];
  List<dynamic> availableSizes = [];
  List<Map<String, dynamic>> stockBatches = [];

  // UI states
  bool isLoading = false;
  String? errorMessage;
  bool formSubmitting = false;

  Future<void> init() async {
    await Future.wait([
      fetchCategories(),
      fetchBrands(),
      fetchProductTypes(),
      fetchStockBatches(),
    ]);
  }

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _categoryService.getAllCategories(limit: 100);
      categories = List<Map<String, dynamic>>.from(result['data']);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBrands() async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _brandService.getAllBrands(limit: 100);
      brands = List<Map<String, dynamic>>.from(result['data']);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductTypes() async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _productTypeService.getAllProductTypes();
      productTypes = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStockBatches() async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _stockBatchService.getAllStockBatches();
      stockBatches = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSizes() async {
    if (productTypeId == null) {
      availableSizes = [];
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();
      final result = await _sizeService.getAllSizes(
        productTypeId: productTypeId,
        limit: 100,
      );
      availableSizes = List<dynamic>.from(result['data']);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setProductType(String? value) {
    productTypeId = value;
    sizes = [];
    fetchSizes();
    notifyListeners();
  }

  void addSize(String sizeId, String label, int quantity) {
    final existingIndex = sizes.indexWhere((size) => size['sizeId'] == sizeId);
    if (existingIndex != -1) {
      sizes[existingIndex]['quantity'] = quantity;
    } else {
      sizes.add({'sizeId': sizeId, 'label': label, 'quantity': quantity});
    }
    notifyListeners();
  }

  void removeSize(String sizeId) {
    sizes.removeWhere((size) => size['sizeId'] == sizeId);
    notifyListeners();
  }

  void updateSizeQuantity(String sizeId, int quantity) {
    final index = sizes.indexWhere((size) => size['sizeId'] == sizeId);
    if (index != -1) {
      sizes[index]['quantity'] = quantity;
      notifyListeners();
    }
  }

  void setImageFile(File file) {
    imageFile = file;
    notifyListeners();
  }

  void clearImageFile() {
    imageFile = null;
    notifyListeners();
  }

  Future<bool> createProduct() async {
    // --- PRINT DEBUG UNTUK MELIHAT DATA YANG AKAN DIKIRIM ---
    print("🔍 [Controller] Memulai Validasi Lokal...");
    print("📝 Nama: $nama");
    print("📝 Harga Beli: $hargaBeli");
    print("📝 Harga Jual: $hargaJual");
    print("📝 Kategori ID: $categoryId");
    print("📝 Brand ID: $brandId");
    print("📝 Tipe Produk ID: $productTypeId");
    print("📝 Jumlah Sizes: ${sizes.length}");
    
    if (nama.isEmpty) {
      errorMessage = 'Nama produk tidak boleh kosong';
      print("❌ Validasi Gagal: $errorMessage");
      notifyListeners();
      return false;
    }
    if (hargaBeli <= 0) {
      errorMessage = 'Harga beli harus lebih dari 0';
      print("❌ Validasi Gagal: $errorMessage");
      notifyListeners();
      return false;
    }
    if (hargaJual <= 0) {
      errorMessage = 'Harga jual harus lebih dari 0';
      print("❌ Validasi Gagal: $errorMessage");
      notifyListeners();
      return false;
    }
    if (categoryId == null) {
      errorMessage = 'Kategori harus dipilih';
      print("❌ Validasi Gagal: $errorMessage");
      notifyListeners();
      return false;
    }
    if (brandId == null) {
      errorMessage = 'Brand harus dipilih';
      print("❌ Validasi Gagal: $errorMessage");
      notifyListeners();
      return false;
    }
    if (productTypeId == null) {
      errorMessage = 'Tipe produk harus dipilih';
      print("❌ Validasi Gagal: $errorMessage");
      notifyListeners();
      return false;
    }
    if (sizes.isEmpty) {
      errorMessage = 'Tambahkan minimal satu ukuran dengan stok';
      print("❌ Validasi Gagal: $errorMessage");
      notifyListeners();
      return false;
    }

    try {
      formSubmitting = true;
      notifyListeners();

      print("⏳ [Controller] Memanggil Service createProduct...");
      
      await _productService.createProduct(
        nama: nama,
        deskripsi: deskripsi.isEmpty ? null : deskripsi,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
        categoryId: categoryId!,
        brandId: brandId!,
        productTypeId: productTypeId!,
        minStock: minStock == 0 ? null : minStock,
        kondisi: kondisi,
        stockBatchId: stockBatchId,
        imageFile: imageFile,
        sizes: sizes,
      );

      print("✅ [Controller] Berhasil membuat produk!");
      formSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      formSubmitting = false;
      errorMessage = e.toString();
      
      print("❌ [Controller] Exception Tertangkap: $e");
      
      notifyListeners();
      return false;
    }
  }

  void resetForm() {
    nama = '';
    deskripsi = '';
    hargaBeli = 0.0;
    hargaJual = 0.0;
    categoryId = null;
    brandId = null;
    productTypeId = null;
    minStock = 0;
    kondisi = 'BARU';
    stockBatchId = null;
    imageFile = null;
    sizes = [];
    errorMessage = null;
    notifyListeners();
  }
}