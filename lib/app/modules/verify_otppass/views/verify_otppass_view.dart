import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/verify_otppass_controller.dart';

class VerifyOtppassView extends GetView<VerifyOtpPassController> {
  const VerifyOtppassView({super.key});

  static const Color primary = Color(0xFF235A43);
  static const Color background = Color(0xFFF4FBF7);
  static const Color otpColor = Color(0xFFF2F7F4);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: background,
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
            bottom: -120,
            left: -120,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.green.shade100.withOpacity(.5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Container(),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      InkWell(
                        onTap: Get.back,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 15,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      size: 60,
                      color: primary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Verifikasi Reset Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Masukkan 6 digit kode verifikasi yang telah\n"
                    "kami kirim ke email Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 17,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [

                        Icon(
                          Icons.email_outlined,
                          color: primary,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "ut********@gmail.com",
                          style: TextStyle(
                            fontSize: 17,
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Masukkan 6 digit kode verifikasi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => _otpBox(context, index),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [

                      Icon(
                        Icons.timer_outlined,
                        color: primary,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "00:52",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Kode verifikasi akan kadaluarsa dalam waktu tersebut.",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        controller.verifyOtp();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            "Lanjutkan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 10),

                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Text(
                        "Belum menerima kode?",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),

                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Kirim ulang",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpBox(BuildContext context, int index) {
    return SizedBox(
      width: 52,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: otpColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}