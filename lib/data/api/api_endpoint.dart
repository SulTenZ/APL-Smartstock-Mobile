// lib/data/api/api_endpoint.dart
import 'api_constant.dart';

class ApiEndpoint {
  // Auth
  static const login = "${ApiConstant.baseUrl}/auth/login";
  static const register = "${ApiConstant.baseUrl}/auth/register";
  static const verifyOtp = "${ApiConstant.baseUrl}/auth/verify-otp";
  static const resendOtp = "${ApiConstant.baseUrl}/auth/resend-otp";
  static const forgotPassword = "${ApiConstant.baseUrl}/auth/forgot-password";
  static const verifyResetOtp = "${ApiConstant.baseUrl}/auth/verify-reset-otp";
  static const resetPassword = "${ApiConstant.baseUrl}/auth/reset-password";

  // Product Type
  static const productTypes = "${ApiConstant.baseUrl}/product-types";
  static String productTypeById(String id) => "$productTypes/$id";

  // Category
  static const categories = "${ApiConstant.baseUrl}/category";
  static String categoryById(String id) => "$categories/$id";

  // Brand
  static const brands = "${ApiConstant.baseUrl}/brand";
  static String brandById(String id) => "$brands/$id";

  // Size
  static const sizes = "${ApiConstant.baseUrl}/size";
  static String sizeById(String id) => "$sizes/$id";

  // Product
  static const products = "${ApiConstant.baseUrl}/product";
  static String productById(String id) => "$products/$id";
  static String productLowStock = "$products/low-stock";
  static String productSyncStock = "$products/sync-stocks";
  static String productSizes(String productId) => "$products/$productId/sizes";
  static String productSizeDetail(String productId, String sizeId) =>
      "$products/$productId/sizes/$sizeId";

  // Product Size
  static String productSizeById(String productSizeId) =>
      "${ApiConstant.baseUrl}/product-size/$productSizeId";
  
  // Customer
  static const customers = "${ApiConstant.baseUrl}/customer";
  static String customerById(String id) => "$customers/$id";

  // Stock Batch
  static const stockBatches = "${ApiConstant.baseUrl}/stock-batch";
  static String stockBatchById(String id) => "$stockBatches/$id";

  // Transaction
  static const transactions = "${ApiConstant.baseUrl}/transaction";
  static String transactionById(String id) => "$transactions/$id";
  static const salesReport = "$transactions/report/sales";
  static const profitReport = "$transactions/report/profit";

  // Graph
  static const graphProfitReport = "${ApiConstant.baseUrl}/graph/profit-report";

  // Audit Log
  static const auditLogs = "${ApiConstant.baseUrl}/audit-log";

  // Reports
  static const financialSummary = "${ApiConstant.baseUrl}/reports/financial-summary";
  static const downloadFinancialSummary = "${ApiConstant.baseUrl}/reports/financial-summary/download";
}
