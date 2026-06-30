import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/forgotpass_controller.dart';

class ForgotpassView extends GetView<ForgotPasswordController> {
  const ForgotpassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Background Blur
          Positioned(
            top: 120,
            left: -70,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xff6BC8A4).withOpacity(.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: -120,
            top: 150,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xffC6F3E4).withOpacity(.25),
                shape: BoxShape.circle,
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 80,
              sigmaY: 80,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// Header
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: Get.back,
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back,
                            color: Color(0xff216B59),
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff216B59),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 55),

                  /// Illustration
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 190,
                        height: 190,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffD8F4EA),
                        ),
                      ),

                      const Icon(
                        Icons.shield,
                        size: 80,
                        color: Color(0xff216B59),
                      ),

                      Positioned(
                        bottom: 18,
                        right: 0,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: Color(0xffFFD58F),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.key,
                            color: Color(0xff795A24),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Lupa Kata Sandi?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Jangan khawatir, hal ini biasa terjadi.\n"
                    "Masukkan email Anda di bawah ini dan kami\n"
                    "akan mengirimkan kode OTP untuk\n"
                    "memverifikasi akun Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 45),

                  /// Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Alamat Email",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "nama@email.com",
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xff216B59),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.sendOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff216B59),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Kirim Kode OTP",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text: "Butuh bantuan lebih lanjut? ",
                                ),
                                TextSpan(
                                  text: "Hubungi\nAdmin",
                                  style: TextStyle(
                                    color: Color(0xff216B59),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}