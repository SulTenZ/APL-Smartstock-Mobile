import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'features/splash/splash_view.dart';
import 'features/authentication/login/login_view.dart';
import 'features/authentication/register/register_view.dart';
import 'features/authentication/registerOTP/register_otp_view.dart';
import 'features/home/home_view.dart';
import 'features/stock/manage_stock_view.dart';
import 'features/stock/product/product_controller.dart';
import 'features/profile/profile_controller.dart';
import 'features/profile/profile_view.dart';
import 'features/transaction/transaction_view.dart';
import 'features/transaction/transaction_controller.dart';
import 'features/transaction/transaction_submission/transaction_submission_controller.dart';
import 'features/transaction/transaction_submission/transaction_submission_view.dart';
import 'features/transaction_history/transaction_history_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(create: (_) => TransactionController()), // ⬅️ Tambahkan ini
      ],
      child: MaterialApp(
        title: 'E-Inventory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashView(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/home': (context) => const HomeView(),
          '/manage-stock': (context) => const ManageStockView(),
          '/profile': (context) => const ProfileView(),
          '/transaction': (context) => const TransactionView(),
          '/transaction-history': (context) => const TransactionHistoryView(),
          '/transaction_submission': (context) {
            // ⬇️ Ambil controller lama yang sudah punya cart
            final transactionController = Provider.of<TransactionController>(
              context,
              listen: false,
            );
          

            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: transactionController), // ⬅️ Ini penting
                ChangeNotifierProvider(
                  create: (_) => TransactionSubmissionController(),
                ),
              ],
              child: const TransactionSubmissionView(),
            );
          },
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
