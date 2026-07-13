import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import '../controllers/security_password_controller.dart';

class SecurityPasswordView extends GetView<SecurityPasswordController> {
  const SecurityPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Keamanan Akun",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // =========================
              // BANNER
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA5D6A7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.primary,
                        size: 38,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Keamanan Akun",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Lindungi akun Anda menggunakan kata sandi yang kuat, login biometrik, dan autentikasi dua langkah.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // UBAH KATA SANDI
              // =========================
              Obx(
                () => _buildNavigationTile(
                  title: "Ubah Kata Sandi",
                  subtitle: "Verifikasi OTP diperlukan sebelum mengubah",
                  icon: Icons.lock_outline_rounded,
                  iconBgColor: const Color(0xFFE8F5E9),
                  iconColor: AppColors.primary,
                  isLoading: controller.isRequestingOtp.value,
                  onTap: controller.isRequestingOtp.value
                      ? null
                      : () => controller.goToChangePassword(),
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // LOGIN BIOMETRIK (FACE)
              // =========================
              Obx(() {
                if (controller.isCheckingFaceStatus.value) {
                  return _buildSectionCard(
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (!controller.isFaceRegistered.value) {
                  // Wajah belum terdaftar → tampilkan ajakan aktivasi
                  return _buildFaceCard(isRegistered: false);
                }

                // Wajah sudah terdaftar → tampilkan "Nonaktifkan"
                return _buildFaceCard(isRegistered: true);
              }),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Login biometrik hanya digunakan untuk membuka sesi login pada perangkat ini. Jika Anda logout, maka login ulang menggunakan email dan password akan diperlukan.",
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.grey.shade700,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // SECTION CARD (generic container)
  // =====================================================

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  // =====================================================
  // NAVIGATION TILE (Ubah Kata Sandi)
  // =====================================================

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: iconBgColor,
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // FACE CARD (Aktifkan / Nonaktifkan)
  // =====================================================

  Widget _buildFaceCard({required bool isRegistered}) {
    return _buildSectionCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isRegistered
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFE0F7FA),
            child: Icon(
              isRegistered ? Icons.face_retouching_natural : Icons.fingerprint,
              color: isRegistered ? AppColors.primary : Colors.teal,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Login Wajah",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isRegistered ? "Wajah sudah terdaftar ✓" : "Wajah belum terdaftar",
                  style: TextStyle(
                    color: isRegistered ? AppColors.primary : Colors.grey,
                    fontSize: 12,
                    fontWeight: isRegistered ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isRegistered
                ? OutlinedButton(
                    key: const ValueKey('deactivate'),
                    onPressed: () => controller.deactivateFaceRecognition(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Nonaktifkan",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                : ElevatedButton(
                    key: const ValueKey('activate'),
                    onPressed: () async {
                      // Navigasi ke face register dan tunggu kembali
                      await Get.toNamed('/face-register');
                      // Refresh status wajah setelah kembali
                      await controller.refreshFaceStatus();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Aktifkan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

}