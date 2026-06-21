import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import 'package:teraparent_mobile/app/modules/register/controllers/register_controller.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F5),
      body: Stack(
        children: [
          // Background circle atas kanan
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade100.withOpacity(0.7),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan.shade100.withOpacity(0.7),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Logo / image
                      Image.asset("assets/logos/teralogo_transparan.png", width: 130),

                      const SizedBox(height: 20),

                      Text(
                        "Teraparent",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Buat Akun",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Mulai langkah baru penuh harapan hari ini.",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 28),

                            const Text(
                              "Nama Lengkap",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 10),

                            TextField(
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                hintText: "John Doe",
                                prefixIcon: const Icon(Icons.person_outline),
                                filled: true,
                                fillColor: const Color(0xffF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              "Email",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 10),

                            TextField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                hintText: "example@email.com",
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: const Color(0xffF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

const Text(
                              "No Handphone",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 10),

                            TextField(
                              controller: controller.phoneController,
                              // TextInputType.phone lebih disarankan daripada .number untuk nomor telepon
                              keyboardType: TextInputType.phone, 
                              decoration: InputDecoration(
                                hintText: "81234567890", // Angka 0 di depan dihilangkan karena sudah ada +62
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "🇮🇩", // Emoji Bendera Indonesia
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "+62", // Kode Negara
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Garis pembatas vertikal (Divider)
                                      Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey.shade400, 
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xffF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              "Kata Sandi",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 10),

                            Obx(
                              () => TextField(
                                controller: controller.passwordController,
                                obscureText: controller.isPasswordHidden.value,
                                decoration: InputDecoration(
                                  hintText: "••••••••",
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: controller.togglePassword,
                                    icon: Icon(
                                      controller.isPasswordHidden.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              "Konfirmasi Kata Sandi",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 10),

                            Obx(
                              () => TextField(
                                controller: controller.confirmPasswordController,
                                obscureText: controller.isConfirmPasswordHidden.value,
                                decoration: InputDecoration(
                                  hintText: "••••••••",
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: controller.toggleConfirmPassword,
                                    icon: Icon(
                                      controller.isConfirmPasswordHidden.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            Obx(
                              () => Row(
                                children: [
                                  Checkbox(
                                    value: controller.isChecked.value,
                                    onChanged: controller.toggleCheckbox,
                                    activeColor: AppColors.primary,
                                  ),

                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: "Saya setuju dengan ",
                                          ),
                                          TextSpan(
                                            text: "Ketentuan & Kebijakan",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Daftar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sudah punya akun?"),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
