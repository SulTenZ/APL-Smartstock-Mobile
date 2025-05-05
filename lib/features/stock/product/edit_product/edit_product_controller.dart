// lib/features/stock/product/edit_product/edit_product_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../data/services/product_service.dart';

class EditProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> updateProduct({
    required String id,
    required String nama,
    String? deskripsi,
    required double hargaBeli,
    required double hargaJual,
    required int categoryId,
    required int brandId,
    required String productTypeId,
    int? minStock,
    String? kondisi,
    String? stockBatchId,
    File? imageFile,
    List<Map<String, dynamic>>? sizes,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _productService.updateProduct(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
        categoryId: categoryId,
        brandId: brandId,
        productTypeId: productTypeId,
        minStock: minStock,
        kondisi: kondisi,
        stockBatchId: stockBatchId,
        imageFile: imageFile,
        sizes: sizes,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}