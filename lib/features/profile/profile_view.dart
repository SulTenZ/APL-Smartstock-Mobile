// lib/features/profile/profile_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_controller.dart';
import '../../../common/widgets/custom_navbar.dart';

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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Consumer<ProfileController>(
          builder: (context, controller, child) {
            if (controller.isLoadingProfile) {
              return const Center(child: CircularProgressIndicator());
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
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      const Text(
                        'PROFIL SAYA',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF222222)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueGrey.withOpacity(0.3),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                  const SizedBox(height: 36),
                  _buildProfileSection(
                    icon: Icons.person_outline,
                    title: 'Informasi Personal',
                    content: Column(
                      children: [
                        _buildInfoItem(label: 'Nama Lengkap', value: name, icon: Icons.account_circle_outlined),
                        const Divider(height: 24),
                        _buildInfoItemWithToggle(
                          label: 'Email',
                          value: email,
                          icon: Icons.email_outlined,
                          isVisible: _isEmailVisible,
                          onToggle: () => setState(() => _isEmailVisible = !_isEmailVisible),
                        ),
                        const Divider(height: 24),
                        _buildInfoItem(
                          label: 'Status Akun',
                          value: 'Aktif',
                          icon: Icons.verified_outlined,
                          valueColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileSection(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan Aplikasi',
                    content: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.notifications_none,
                          title: 'Notifikasi Push',
                          subtitle: 'Terima pemberitahuan aplikasi',
                          trailing: Switch(
                            value: true,
                            onChanged: (value) => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur akan segera tersedia'), duration: Duration(seconds: 2)),
                            ),
                            activeColor: Colors.blueGrey,
                          ),
                        ),
                        const Divider(height: 16),
                        _buildSettingItem(
                          icon: Icons.dark_mode_outlined,
                          title: 'Mode Gelap',
                          subtitle: 'Aktifkan tema gelap',
                          trailing: Switch(
                            value: false,
                            onChanged: (value) => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur akan segera tersedia'), duration: Duration(seconds: 2)),
                            ),
                            activeColor: Colors.blueGrey,
                          ),
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
                        _buildInfoItem(label: 'Versi Aplikasi', value: '1.0.0', icon: Icons.app_settings_alt_outlined),
                        const Divider(height: 24),
                        _buildInfoItem(
                            label: 'Terakhir Diperbarui', value: '28 Mei 2025', icon: Icons.update_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
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
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    onPressed: controller.isLoggingOut ? null : () => _showLogoutDialog(context, controller),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 22, color: Colors.blueGrey),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16.0), child: content),
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
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: valueColor ?? const Color(0xFF333333))),
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
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(isVisible ? value : _maskEmail(value),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF333333))),
            ],
          ),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(isVisible ? Icons.visibility : Icons.visibility_off, size: 16, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              if (subtitle != null)
                ...[const SizedBox(height: 2), Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600]))],
            ],
          ),
        ),
        trailing,
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
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [Icon(Icons.logout, color: Colors.redAccent), SizedBox(width: 8), Text('Konfirmasi Keluar')],
          ),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                controller.logout(context);
              },
              child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }
}
