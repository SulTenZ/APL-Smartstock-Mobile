// lib/features/profile/profile_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_controller.dart';
import '../../../common/widgets/custom_navbar.dart';
import '../../../common/color/color_theme.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isEmailVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProfileController>(context, listen: false);
      controller.initializeProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: Consumer<ProfileController>(
            builder: (context, controller, child) {
              if (controller.isLoadingProfile) {
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
                    child: const CircularProgressIndicator(
                      color: Color(ColorTheme.primaryColor),
                    ),
                  ),
                );
              }

              final name = controller.cachedName ?? 'Pengguna';
              final email = controller.cachedEmail ?? 'email@example.com';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(ColorTheme.primaryColor),
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        Text(
                          'PROFIL SAYA',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(ColorTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(ColorTheme.secondaryColor).withOpacity(0.2),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: const Color(ColorTheme.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(ColorTheme.textColor),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _buildProfileSection(
                      icon: Icons.person_outline,
                      title: 'Informasi Personal',
                      content: Column(
                        children: [
                          _buildInfoItem(
                            label: 'Nama Lengkap',
                            value: name,
                            icon: Icons.account_circle_outlined,
                          ),
                          const Divider(height: 24, color: Color(0xFFE0E0E0)),
                          _buildInfoItemWithToggle(
                            label: 'Email',
                            value: email,
                            icon: Icons.email_outlined,
                            isVisible: _isEmailVisible,
                            onToggle: () => setState(() => _isEmailVisible = !_isEmailVisible),
                          ),
                          const Divider(height: 24, color: Color(0xFFE0E0E0)),
                          _buildInfoItem(
                            label: 'Status Akun',
                            value: 'Aktif',
                            icon: Icons.verified_outlined,
                            valueColor: const Color(ColorTheme.successColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProfileSection(
                      icon: Icons.info_outline,
                      title: 'Informasi Aplikasi',
                      content: Column(
                        children: [
                          _buildInfoItem(
                            label: 'Versi Aplikasi',
                            value: '1.0.0',
                            icon: Icons.app_settings_alt_outlined,
                          ),
                          const Divider(height: 24, color: Color(0xFFE0E0E0)),
                          _buildInfoItem(
                            label: 'Terakhir Diperbarui',
                            value: '28 Mei 2025',
                            icon: Icons.update_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(ColorTheme.errorColor).withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(ColorTheme.errorColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        icon: controller.isLoggingOut
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.logout),
                        label: Text(
                          controller.isLoggingOut ? 'Keluar...' : 'Keluar',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: controller.isLoggingOut ? null : () => _showLogoutDialog(context, controller),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomNavbar(currentIndex: 3, onTap: (index) {}),
    );
  }

  Widget _buildProfileSection({required IconData icon, required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(ColorTheme.secondaryColor).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(ColorTheme.primaryColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 22, color: const Color(ColorTheme.primaryColor)),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(ColorTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: const Color(ColorTheme.secondaryColor).withOpacity(0.2),
          ),
          Padding(padding: const EdgeInsets.all(20.0), child: content),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(ColorTheme.secondaryColor)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: const Color(ColorTheme.secondaryColor),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: valueColor ?? const Color(ColorTheme.textColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItemWithToggle({
    required String label,
    required String value,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(ColorTheme.secondaryColor)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: const Color(ColorTheme.secondaryColor),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isVisible ? value : _maskEmail(value),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(ColorTheme.textColor),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(ColorTheme.secondaryColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              size: 16,
              color: const Color(ColorTheme.secondaryColor),
            ),
          ),
        ),
      ],
    );
  }

  String _maskEmail(String email) {
    if (email.isEmpty || !email.contains('@')) return email;
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) return '${username[0]}***@$domain';
    return '${username.substring(0, 2)}***@$domain';
  }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              const Icon(Icons.logout, color: Color(ColorTheme.errorColor)),
              const SizedBox(width: 8),
              Text(
                'Konfirmasi Keluar',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(ColorTheme.primaryColor),
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(ColorTheme.textColor),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: const Color(ColorTheme.secondaryColor),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(ColorTheme.errorColor),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                controller.logout(context);
              },
              child: Text(
                'Keluar',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
