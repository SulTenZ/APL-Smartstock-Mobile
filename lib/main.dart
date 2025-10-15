import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

// --- IMPORT BARU ---
import 'data/services/onesignal_service.dart';

import 'features/report/report_view.dart';
import 'features/splash/splash_view.dart';
import 'features/authentication/login/login_view.dart';
import 'features/authentication/register/register_view.dart';
import 'features/authentication/registerOTP/register_otp_view.dart';
import 'features/authentication/forgotPassword/forgotPassword_view.dart';
import 'features/authentication/forgotPasswordOTP/forgotPasswordOTP_view.dart';
import 'features/authentication/resetPassword/reset_password_view.dart';
import 'features/home/home_view.dart';
import 'features/stock/manage_stock_view.dart';
import 'features/stock/product/product_controller.dart';
import 'features/stock/product_type/product_type_view.dart';
import 'features/stock/product_type/create_product_type/create_product_type_view.dart';
import 'features/stock/product_type/edit_product_type/edit_product_type_view.dart';
import 'features/stock/category/category_view.dart';
import 'features/stock/category/create_category/create_category_view.dart';
import 'features/stock/category/edit_category/edit_category_view.dart';
import 'features/stock/brand/brand_view.dart';
import 'features/stock/brand/create_brand/create_brand_view.dart';
import 'features/stock/brand/edit_brand/edit_brand_view.dart';
import 'features/stock/size/size_view.dart';
import 'features/stock/size/create_size/create_size_view.dart';
import 'features/stock/size/edit_size/edit_size_view.dart';
import 'features/stock/product/product_view.dart';
import 'features/stock/product/create_product/create_product_controller.dart';
import 'features/stock/product/create_product/create_product_view.dart';
import 'features/stock/product/detail_product/detail_product_view.dart';
import 'features/stock/product/edit_product/edit_product_view.dart';
import 'features/stock/stock_batch/stock_batch_view.dart';
import 'features/stock/stock_batch/create_stock_batch/create_stock_batch_view.dart';
import 'features/stock/stock_batch/edit_stock_batch/edit_stock_batch_view.dart';
import 'features/stock/stock_batch/detail_stock_batch/detail_stock_batch_view.dart';
import 'features/profile/profile_controller.dart';
import 'features/profile/profile_view.dart';
import 'features/transaction/transaction_view.dart';
import 'features/transaction/transaction_controller.dart';
import 'features/transaction/transaction_submission/transaction_submission_controller.dart';
import 'features/transaction/transaction_submission/transaction_submission_view.dart';
import 'features/transaction/transaction_success/transaction_success_view.dart';
import 'features/transaction_history/transaction_history_view.dart';
import 'features/transaction_history/transaction_history_detail/transaction_history_detail_view.dart';
import 'features/stock_history/stock_history_view.dart';
import 'features/graph/graph_view.dart';
import 'features/audit_log/audit_log_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // --- INISIALISASI ONESIGNAL ---
  // Inisialisasi OneSignal service saat aplikasi dimulai
  await OneSignalService().init();
  // --- AKHIR INISIALISASI ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
      ],
      child: MaterialApp(
        title: 'E-Inventory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'),
          Locale('en', 'US'),
        ],
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashView(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/forgot-password': (context) => const ForgotPasswordView(),
          '/forgot-password-otp': (context) {
            final email = ModalRoute.of(context)!.settings.arguments as String;
            return ForgotPasswordOtpView(email: email);
          },
          '/reset-password': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ResetPasswordView(email: args['email'], otp: args['otp']);
          },
          '/home': (context) => const HomeView(),
          '/manage-stock': (context) => const ManageStockView(),
          '/product-type': (context) => const ProductTypeView(),
          '/product-type/create': (context) => const CreateProductTypeView(),
          '/product-type/edit': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EditProductTypeView(id: args['id'], name: args['name']);
          },
          '/category': (context) => const CategoryView(),
          '/category/create': (context) => const CreateCategoryView(),
          '/category/edit': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EditCategoryView(
              id: args['id'],
              nama: args['nama'],
              deskripsi: args['deskripsi'],
              productTypeId: args['productTypeId'],
            );
          },
          '/brand': (context) => const BrandView(),
          '/brand/create': (context) => const CreateBrandView(),
          '/brand/edit': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EditBrandView(
              id: args['id'],
              nama: args['nama'],
              deskripsi: args['deskripsi'],
              image: args['image'],
            );
          },
          '/size': (context) => const SizeView(),
          '/size/create': (context) => const CreateSizeView(),
          '/size/edit': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EditSizeView(
              id: args['id'],
              label: args['label'],
              productTypeId: args['productTypeId'],
              initialLabel: args['label'],
              initialProductTypeId: args['productTypeId'],
            );
          },
          '/product': (context) => const ProductView(),
          '/product/create': (context) => ChangeNotifierProvider(
                create: (_) => CreateProductController()..init(),
                child: const CreateProductView(),
              ),
          '/product/detail': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return DetailProductView(productId: args['id']);
          },
          '/product/edit': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EditProductView(
              productId: args['id'],
              product: args['product'],
            );
          },
          '/stock-batch': (context) => const StockBatchView(),
          '/stock-batch/create': (context) => const CreateStockBatchView(),
          '/stock-batch/edit': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EditStockBatchView(batch: args['batch']);
          },
          '/stock-batch/detail': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return DetailStockBatchView(batchId: args['id']);
          },
          '/profile': (context) => const ProfileView(),
          '/transaction': (context) => const TransactionView(),
          '/transaction_submission': (context) {
            final transactionController = Provider.of<TransactionController>(
              context,
              listen: false,
            );
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: transactionController),
                ChangeNotifierProvider(
                  create: (_) => TransactionSubmissionController(),
                ),
              ],
              child: const TransactionSubmissionView(),
            );
          },
          '/transaction-success': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return TransactionSuccessView(
              transactionId: args['transactionId'],
              customerName: args['customerName'],
              totalAmount: args['totalAmount'],
              items: args['items'],
              paymentMethod: args['paymentMethod'],
              discount: args['discount'] ?? 0,
              notes: args['notes'],
            );
          },
          '/transaction-history': (context) => const TransactionHistoryView(),
          '/transaction-history/detail': (context) {
            final tx =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return TransactionHistoryDetailView(transaction: tx);
          },
          '/stock-history': (context) => const StockHistoryView(),
          '/graph': (context) => const GraphView(),
          '/audit-log': (context) => const AuditLogView(),
          '/report': (context) => const ReportView(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/register-otp') {
            final email = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => RegisterOtpView(email: email),
            );
          }
          return null;
        },
      ),
    );
  }
}