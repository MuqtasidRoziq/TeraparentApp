import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_success_controller.dart';

class VerifySuccessView extends GetView<VerifySuccessController> {
  const VerifySuccessView({super.key});

  static const Color primaryColor = Color(0xFF235A43);
  static const Color backgroundColor = Color(0xFFF4FBF7);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double responsive(
      double value, {
      double min = 0,
      double max = double.infinity,
    }) {
      return (width * value).clamp(min, max).toDouble();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -height * 0.12,
            right: -width * 0.2,
            child: Container(
              width: width * 0.7,
              height: width * 0.7,
              decoration: BoxDecoration(
                color: const Color(0xFFD8F3DC).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -height * 0.13,
            left: -width * 0.24,
            child: Container(
              width: width * 0.75,
              height: width * 0.75,
              decoration: BoxDecoration(
                color: const Color(0xFFCDEFE4).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive(0.08, min: 24, max: 36),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.4, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: responsive(0.34, min: 120, max: 150),
                        height: responsive(0.34, min: 120, max: 150),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.16),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: responsive(0.2, min: 74, max: 92),
                          color: primaryColor,
                        ),
                      ),
                    ),

                    SizedBox(height: responsive(0.08, min: 28, max: 38)),

                    Text(
                      'Verifikasi Berhasil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive(0.075, min: 26, max: 32),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Akun Anda berhasil diverifikasi.\nSelanjutnya lengkapi data anak terlebih dahulu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive(0.04, min: 14, max: 16),
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 36),

                    SizedBox(
                      width: responsive(0.08, min: 28, max: 34),
                      height: responsive(0.08, min: 28, max: 34),
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}