// lib/features/splash/splash_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'splash_controller.dart';
import '../../common/color/color_theme.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final SplashController _controller = SplashController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeOutAnimation; // Tambahan untuk fade out

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000), // Diperpanjang untuk fade out
      vsync: this,
    );

    // Fade in animation (0.0 - 0.6)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Scale animation (0.0 - 0.7)
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    // Slide animation (0.2 - 0.8)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // Fade out animation (0.75 - 1.0)
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.75, 1.0, curve: Curves.easeInOut),
    ));

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    // Start entrance animations
    _animationController.forward();
    
    // Handle navigation after delay
    _controller.handleNavigation(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeOutAnimation, // Apply fade out to entire screen
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(ColorTheme.primaryColor).withOpacity(0.12),
                    const Color(ColorTheme.secondaryColor).withOpacity(0.06),
                    const Color(ColorTheme.backgroundColor),
                    const Color(0xFFF8F9FA),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Background gradient circles (same as before)
                  _buildBackgroundGradients(context),
                  
                  // Main content
                  SafeArea(
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo with glass morphism effect
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: _buildLogoContainer(),
                            ),
                            
                            const SizedBox(height: 50),
                            
                            // Text content
                            SlideTransition(
                              position: _slideAnimation,
                              child: _buildTextContent(),
                            ),
                            
                            const SizedBox(height: 70),
                            
                            // Loading indicator
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildLoadingIndicator(),
                            ),
                          ],
                        ),
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

  Widget _buildBackgroundGradients(BuildContext context) {
    return Stack(
      children: [
        // Gradient bulat di pojok kiri atas
        Positioned(
          top: -120,
          left: -120,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(ColorTheme.primaryColor).withOpacity(0.15),
                  const Color(ColorTheme.primaryColor).withOpacity(0.08),
                  const Color(ColorTheme.primaryColor).withOpacity(0.04),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
        
        // Gradient bulat di pojok kanan atas
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(ColorTheme.secondaryColor).withOpacity(0.2),
                  const Color(ColorTheme.secondaryColor).withOpacity(0.12),
                  const Color(ColorTheme.secondaryColor).withOpacity(0.06),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),
        
        // Gradient bulat di pojok kiri bawah
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(ColorTheme.secondaryColor).withOpacity(0.18),
                  const Color(ColorTheme.secondaryColor).withOpacity(0.1),
                  const Color(ColorTheme.secondaryColor).withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
        
        // Gradient bulat di pojok kanan bawah
        Positioned(
          bottom: -60,
          right: -60,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(ColorTheme.primaryColor).withOpacity(0.12),
                  const Color(ColorTheme.primaryColor).withOpacity(0.06),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoContainer() {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(ColorTheme.primaryColor).withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: 8,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, -5),
          ),
          BoxShadow(
            color: const Color(ColorTheme.secondaryColor).withOpacity(0.1),
            blurRadius: 60,
            spreadRadius: 15,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const Image(
            image: AssetImage('assets/images/logo_apl.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        // Main title
        Text(
          'APL Shoes',
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: const Color(ColorTheme.primaryColor),
            letterSpacing: 1.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Gradient line
        Container(
          width: 80,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [
                Color(ColorTheme.primaryColor),
                Color(ColorTheme.secondaryColor),
                Color(ColorTheme.primaryColor),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        Text(
          'Secondbrand',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(ColorTheme.primaryColor),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(ColorTheme.primaryColor).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(ColorTheme.primaryColor),
              ),
              backgroundColor: const Color(ColorTheme.secondaryColor).withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(ColorTheme.primaryColor),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}