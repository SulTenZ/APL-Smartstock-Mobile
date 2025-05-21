// lib/features/stock/product/create_product/create_product_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../data/services/product_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/brand_service.dart';
import '../../../../data/services/product_type_service.dart';
import '../../../../data/services/size_service.dart';

class CreateProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final BrandService _brandService = BrandService();
  final ProductTypeService _productTypeService = ProductTypeService();
  final SizeService _sizeService = SizeService();
  
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
  
  // Lists for dropdowns
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> brands = [];
  List<dynamic> productTypes = [];
  List<dynamic> availableSizes = [];
  
  // UI States
  bool isLoading = false;
  String? errorMessage;
  bool formSubmitting = false;
  
  // Initialization
  Future<void> init() async {
    await Future.wait([
      fetchCategories(),
      fetchBrands(),
      fetchProductTypes(),
    ]);
  }
  
  // Fetch data for dropdowns
  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      notifyListeners();
      
      final result = await _categoryService.getAllCategories(limit: 100);
      categories = List<Map<String, dynamic>>.from(result['data']);
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> fetchBrands() async {
    try {
      isLoading = true;
      notifyListeners();
      
      final result = await _brandService.getAllBrands(limit: 100);
      brands = List<Map<String, dynamic>>.from(result['data']);
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> fetchProductTypes() async {
    try {
      isLoading = true;
      notifyListeners();
      
      final result = await _productTypeService.getAllProductTypes();
      productTypes = result;
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
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
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // Set product type and clear previous size selections
  void setProductType(String? value) {
    productTypeId = value;
    sizes = []; // Clear existing size selections when product type changes
    fetchSizes(); // Fetch available sizes for selected product type
    notifyListeners();
  }
  
  // Add a size with quantity
  void addSize(String sizeId, String label, int quantity) {
    // Check if size already exists in the list
    final existingIndex = sizes.indexWhere((size) => size['sizeId'] == sizeId);
    
    if (existingIndex != -1) {
      // Update existing size
      sizes[existingIndex]['quantity'] = quantity;
    } else {
      // Add new size
      sizes.add({
        'sizeId': sizeId,
        // 'label': label,
        'quantity': quantity,
      });
    }
    
    notifyListeners();
  }
  
  // Remove a size
  void removeSize(String sizeId) {
    sizes.removeWhere((size) => size['sizeId'] == sizeId);
    notifyListeners();
  }
  
  // Update size quantity
  void updateSizeQuantity(String sizeId, int quantity) {
    final index = sizes.indexWhere((size) => size['sizeId'] == sizeId);
    if (index != -1) {
      sizes[index]['quantity'] = quantity;
      notifyListeners();
    }
  }
  
  // Set image file
  void setImageFile(File file) {
    imageFile = file;
    notifyListeners();
  }
  
  // Clear image file
  void clearImageFile() {
    imageFile = null;
    notifyListeners();
  }
  
  // Submit product creation
  Future<bool> createProduct() async {
    // Validate form data
    if (nama.isEmpty) {
      errorMessage = 'Nama produk tidak boleh kosong';
      notifyListeners();
      return false;
    }
    
    if (hargaBeli <= 0) {
      errorMessage = 'Harga beli harus lebih dari 0';
      notifyListeners();
      return false;
    }
    
    if (hargaJual <= 0) {
      errorMessage = 'Harga jual harus lebih dari 0';
      notifyListeners();
      return false;
    }
    
    if (categoryId == null) {
      errorMessage = 'Kategori harus dipilih';
      notifyListeners();
      return false;
    }
    
    if (brandId == null) {
      errorMessage = 'Brand harus dipilih';
      notifyListeners();
      return false;
    }
    
    if (productTypeId == null) {
      errorMessage = 'Tipe produk harus dipilih';
      notifyListeners();
      return false;
    }
    
    if (sizes.isEmpty) {
      errorMessage = 'Tambahkan minimal satu ukuran dengan stok';
      notifyListeners();
      return false;
    }
    
    try {
      formSubmitting = true;
      notifyListeners();
      
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
      
      formSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      formSubmitting = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Reset form
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