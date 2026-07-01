import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  static const Color primaryColor = Color(0xFF235A43);
  static const Color backgroundColor = Color(0xFFF4FBF7);
  static const Color inputColor = Color(0xFFF1F5F3);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [

          /// Background Circle
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.green.shade100.withOpacity(.5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -130,
            left: -130,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.green.shade100.withOpacity(.4),
                shape: BoxShape.circle,
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 70,
              sigmaY: 70,
            ),
            child: Container(),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [

                  const SizedBox(height: 10),

                  /// Back Button
                  Row(
                    children: [

                      InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  /// ICON
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(.12),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: primaryColor,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Atur Ulang\nKata Sandi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Buat kata sandi baru yang aman.\n"
                    "Pastikan berbeda dari kata sandi sebelumnya.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// CARD
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 18,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Kata Sandi Baru",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Obx(
                          () => TextField(
                            controller: controller.passwordC,
                            obscureText: controller.hidePassword.value,
                            decoration: InputDecoration(
                              hintText: "Masukkan kata sandi baru",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: controller.togglePassword,
                                icon: Icon(
                                  controller.hidePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              filled: true,
                              fillColor: inputColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Konfirmasi Kata Sandi",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Obx(
                          () => TextField(
                            controller: controller.confirmPasswordC,
                            obscureText:
                                controller.hideConfirmPassword.value,
                            decoration: InputDecoration(
                              hintText: "Masukkan ulang kata sandi",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed:
                                    controller.toggleConfirmPassword,
                                icon: Icon(
                                  controller.hideConfirmPassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              filled: true,
                              fillColor: inputColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                                                const SizedBox(height: 25),

                        /// PASSWORD STRENGTH
                        Obx(() {
                          double strength = controller.passwordStrength.value;

                          Color color;

                          String text;

                          if (strength < 0.3) {
                            color = Colors.red;
                            text = "Lemah";
                          } else if (strength < 0.7) {
                            color = Colors.orange;
                            text = "Sedang";
                          } else {
                            color = Colors.green;
                            text = "Kuat";
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              const SizedBox(height: 10),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  minHeight: 8,
                                  value: strength,
                                  color: color,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                text,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 25),

                        
                        
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Simpan Kata Sandi",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Row(
                    children: [

                      Icon(
                        Icons.security,
                        color: primaryColor,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Gunakan kata sandi yang unik dan jangan membagikannya kepada siapa pun.",
                          style: TextStyle(
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//   Widget _item(RxBool value, String title) {
//     return Obx(
//       () => Padding(
//         padding: const EdgeInsets.only(bottom: 12),
//         child: Row(
//           children: [

//             Icon(
//               value.value
//                   ? Icons.check_circle
//                   : Icons.radio_button_unchecked,
//               color: value.value
//                   ? Colors.green
//                   : Colors.grey,
//             ),

//             const SizedBox(width: 12),

//             Text(
//               title,
//               style: TextStyle(
//                 color: value.value
//                     ? Colors.green
//                     : Colors.black54,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}