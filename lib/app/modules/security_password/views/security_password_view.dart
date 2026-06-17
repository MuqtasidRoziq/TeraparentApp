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
              // PASSWORD CARD
              // =========================
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Ubah Kata Sandi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildPasswordField(
                      label: "Kata Sandi Lama",
                      hint: "Masukkan kata sandi",
                      controller: controller.currentPasswordController,
                      isObscure: controller.isCurrentObscure,
                    ),

                    const SizedBox(height: 16),

                    _buildPasswordField(
                      label: "Kata Sandi Baru",
                      hint: "Masukkan kata sandi",
                      controller: controller.currentPasswordController,
                      isObscure: controller.isCurrentObscure,
                    ),

                    const SizedBox(height: 16),

                    _buildPasswordField(
                      label: "Konfirmasi Kata Sandi Baru",
                      hint: "Masukkan kata sandi",
                      controller: controller.currentPasswordController,
                      isObscure: controller.isCurrentObscure,
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.updatePassword();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Perbarui Kata Sandi",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // LOGIN BIOMETRIK
              // =========================
              Obx(
                () => _buildToggleCard(
                  title: "Login Biometrik",
                  subtitle: "Fingerprint / Face Unlock",
                  icon: Icons.fingerprint,
                  iconBgColor: const Color(0xFFE0F7FA),
                  iconColor: Colors.teal,
                  value: controller.isBiometricEnabled.value,
                  onChanged: (val) => controller.isBiometricEnabled.value = val,
                  activeColor: AppColors.primary,
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // 2FA
              // =========================
              Obx(
                () => _buildToggleCard(
                  title: "Autentikasi 2FA",
                  subtitle: "Verifikasi tambahan saat login",
                  icon: Icons.phonelink_lock,
                  iconBgColor: const Color(0xFFFFF3E0),
                  iconColor: Colors.orange,
                  value: controller.is2FAEnabled.value,
                  onChanged: (val) => controller.is2FAEnabled.value = val,
                  activeColor: AppColors.primary,
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // INFO CARD
              // =========================
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
  // SECTION CARD
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
  // PASSWORD FIELD
  // =====================================================

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required RxBool isObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),

        Obx(
          () => TextField(
            controller: controller,
            obscureText: isObscure.value,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isObscure.value ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => isObscure.toggle(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildSecurityTile({
  //   required String title,
  //   required String subtitle,
  //   required IconData icon,
  //   required Color iconBg,
  //   required Color iconColor,
  //   required bool value,
  //   required Function(bool) onChanged,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(22),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: iconBg,
  //             borderRadius: BorderRadius.circular(14),
  //           ),
  //           child: Icon(icon, color: iconColor),
  //         ),

  //         const SizedBox(width: 16),

  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                 ),
  //               ),

  //               const SizedBox(height: 4),

  //               Text(
  //                 subtitle,
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   height: 1.4,
  //                   color: Colors.grey.shade600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         Switch.adaptive(
  //           value: value,
  //           onChanged: onChanged,
  //           activeColor: AppColors.primary,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool value,
    required Function(bool) onChanged,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }
}
