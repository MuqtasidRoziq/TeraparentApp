import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/modules/login/controllers/login_controller.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';


class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final Color primaryColor = const Color(0xff2F7D69);

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

          // Background circle bawah kiri
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
                      Image.asset(
                        "assets/images/login.png",
                        width: 130,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Teraparent",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Mendukung setiap langkah\nperkembangan buah hati Anda.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Selamat Datang Kembali",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Silakan masuk untuk melanjutkan perjalanan Anda.",
                              style: TextStyle(color: Colors.black54),
                            ),

                            const SizedBox(height: 24),

                            const Text(
                              "Email Address",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 8),

                            TextField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                hintText: "contoh@email.com",
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Lupa Kata Sandi?",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Obx(
                              () => TextField(
                                controller:
                                    controller.passwordController,
                                obscureText: controller.isHidden.value,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.lock_outline),
                                  hintText: "••••••••",
                                  suffixIcon: IconButton(
                                    onPressed:
                                        controller.togglePassword,
                                    icon: Icon(
                                      controller.isHidden.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: (){
                                  Get.toNamed(Routes.HOME);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text("Atau"),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),

                            const SizedBox(height: 20),

                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.g_mobiledata,
                                  size: 30),
                              label: const Text(
                                "Daftar dengan Google",
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize:
                                    const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
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
                          const Text("Belum punya akun?"),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Text(
                              "Daftar",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
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