// lib/features/transaction/transaction_success/transaction_success_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/color/color_theme.dart';
import 'transaction_success_controller.dart';

class TransactionSuccessView extends StatefulWidget {
  final String transactionId;
  final String customerName;
  final double totalAmount;
  final List<Map<String, dynamic>> items;
  final String paymentMethod;
  final double discount;
  final String? notes;

  const TransactionSuccessView({
    super.key,
    required this.transactionId,
    required this.customerName,
    required this.totalAmount,
    required this.items,
    required this.paymentMethod,
    this.discount = 0,
    this.notes,
  });

  @override
  State<TransactionSuccessView> createState() => _TransactionSuccessViewState();
}

class _TransactionSuccessViewState extends State<TransactionSuccessView>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _slideAnim;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.4, 0.9, curve: Curves.elasticOut)),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.1, 0.6, curve: Curves.easeOut)),
    );

    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

    _animController.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _animController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionSuccessController(
        transactionId: widget.transactionId,
        customerName: widget.customerName,
        totalAmount: widget.totalAmount,
        items: widget.items,
        paymentMethod: widget.paymentMethod,
        discount: widget.discount,
        notes: widget.notes,
      ),
      child: Consumer<TransactionSuccessController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(ColorTheme.primaryColor).withOpacity(0.15),
                    const Color(ColorTheme.secondaryColor).withOpacity(0.08),
                    const Color(ColorTheme.backgroundColor),
                    const Color(0xFFF8F9FA),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      numberOfParticles: 30,
                      maxBlastForce: 20,
                      minBlastForce: 8,
                      gravity: 0.3,
                    ),
                  ),
                  _buildBackgroundCircles(context),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SlideTransition(
                            position: _slideAnim,
                            child: FadeTransition(
                              opacity: _fadeAnim,
                              child: Text(
                                "Transaksi Berhasil",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(ColorTheme.primaryColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: ScaleTransition(
                              scale: _scaleAnim,
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF9E9E9E),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white, size: 60),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      "Transaksi Sukses!",
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(ColorTheme.primaryColor),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Terima kasih telah melakukan transaksi",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Divider(color: Colors.grey.shade300),
                                    _infoRow("ID Transaksi", controller.formattedTransactionId),
                                    _infoRow("Nama Customer", controller.customerName),
                                    _infoRow("Total", controller.formattedTotal),
                                    _infoRow("Metode", widget.paymentMethod),
                                    if (widget.notes != null && widget.notes!.isNotEmpty)
                                      _infoRow("Catatan", widget.notes!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                text: "Selesai",
                                onPressed: () => controller.navigateToHome(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircles(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          left: -120,
          child: _circle(240, ColorTheme.primaryColor, 0.15),
        ),
        Positioned(
          top: -80,
          right: -80,
          child: _circle(160, ColorTheme.secondaryColor, 0.2),
        ),
        Positioned(
          bottom: -100,
          left: -100,
          child: _circle(200, ColorTheme.secondaryColor, 0.18),
        ),
        Positioned(
          bottom: -60,
          right: -60,
          child: _circle(120, ColorTheme.primaryColor, 0.12),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: -60,
          child: _circle(120, ColorTheme.secondaryColor, 0.12),
        ),
      ],
    );
  }

  Widget _circle(double size, int color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(color).withOpacity(opacity),
            Color(color).withOpacity(opacity / 2),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
    );
  }
}