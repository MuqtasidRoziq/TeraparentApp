import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({super.key});

  static const Color primaryColor = Color(0xFF235A43);
  static const Color backgroundColor = Color(0xFFF4FBF7);
  static const Color inputColor = Color(0xFFF1F5F3);

  double responsive(
    double width,
    double value, {
    double min = 0,
    double max = double.infinity,
  }) {
    return (width * value).clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final horizontalPadding = responsive(width, 0.065, min: 20, max: 32);
    final cardPadding = responsive(width, 0.055, min: 16, max: 24);
    final iconSize = responsive(width, 0.15, min: 46, max: 64);
    final titleSize = responsive(width, 0.075, min: 24, max: 32);
    final subtitleSize = responsive(width, 0.038, min: 13, max: 16);

    final otpBoxSize = ((width - (horizontalPadding * 2) - (cardPadding * 2) - 45) / 6)
        .clamp(38, 52)
        .toDouble();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -height * 0.11,
            right: -width * 0.18,
            child: Container(
              width: width * 0.58,
              height: width * 0.58,
              decoration: BoxDecoration(
                color: const Color(0xFFD8F3DC).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -height * 0.12,
            left: -width * 0.2,
            child: Container(
              width: width * 0.65,
              height: width * 0.65,
              decoration: BoxDecoration(
                color: const Color(0xFFCDEFE4).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(height: responsive(height, 0.015, min: 10, max: 20)),

                          Row(
                            children: [
                              InkWell(
                                onTap: () => Get.back(),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: responsive(width, 0.12, min: 42, max: 48),
                                  height: responsive(width, 0.12, min: 42, max: 48),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: responsive(height, 0.035, min: 18, max: 34)),

                          Container(
                            width: responsive(width, 0.28, min: 92, max: 120),
                            height: responsive(width, 0.28, min: 92, max: 120),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.12),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.mark_email_read_rounded,
                              size: iconSize,
                              color: primaryColor,
                            ),
                          ),

                          SizedBox(height: responsive(height, 0.03, min: 18, max: 28)),

                          Text(
                            'Verifikasi OTP',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),

                          SizedBox(height: responsive(height, 0.012, min: 8, max: 12)),

                          Obx(
                            () => Text(
                              'Masukkan 6 digit kode OTP yang telah dikirim ke\n${controller.email.value}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: subtitleSize,
                                height: 1.5,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          SizedBox(height: responsive(height, 0.04, min: 24, max: 36)),

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: cardPadding,
                              vertical: responsive(height, 0.035, min: 22, max: 30),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Kode OTP',
                                    style: TextStyle(
                                      fontSize: responsive(width, 0.055, min: 20, max: 24),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Cek inbox atau folder spam email Anda.',
                                    style: TextStyle(
                                      fontSize: responsive(width, 0.035, min: 13, max: 15),
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),

                                SizedBox(height: responsive(height, 0.035, min: 22, max: 28)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    6,
                                    (index) => _otpBox(index, otpBoxSize),
                                  ),
                                ),

                                SizedBox(height: responsive(height, 0.04, min: 26, max: 34)),

                                Obx(
                                  () => SizedBox(
                                    width: double.infinity,
                                    height: responsive(height, 0.07, min: 52, max: 58),
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : controller.verifyOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        disabledBackgroundColor:
                                            primaryColor.withOpacity(0.5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: controller.isLoading.value
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              'Verifikasi',
                                              style: TextStyle(
                                                fontSize: responsive(width, 0.043, min: 16, max: 18),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Obx(
                                  () {
                                    final canResend = controller.secondsLeft.value == 0;

                                    return Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        const Text(
                                          'Belum menerima kode? ',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: canResend
                                              ? controller.resendOtp
                                              : null,
                                          child: Text(
                                            canResend
                                                ? 'Kirim ulang'
                                                : '${controller.secondsLeft.value}s',
                                            style: TextStyle(
                                              color: canResend
                                                  ? primaryColor
                                                  : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          Padding(
                            padding: EdgeInsets.only(
                              top: responsive(height, 0.025, min: 18, max: 26),
                              bottom: responsive(height, 0.025, min: 18, max: 30),
                            ),
                            child: const Text(
                              'Pastikan kode OTP tidak diberikan kepada siapa pun.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpBox(int index, double boxSize) {
    return SizedBox(
      width: boxSize,
      height: boxSize + 10,
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: boxSize * 0.48,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: inputColor,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 1.8,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            controller.focusNodes[index + 1].requestFocus();
          }

          if (value.isEmpty && index > 0) {
            controller.focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}