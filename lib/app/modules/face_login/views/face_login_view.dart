import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import '../controllers/face_login_controller.dart';

class FaceLoginView extends GetView<FaceLoginController> {
  const FaceLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: Stack(
        children: [
          // Background soft decor circles
          Positioned(
            top: -height * 0.12,
            right: -width * 0.22,
            child: Container(
              width: width * 0.72,
              height: width * 0.72,
              decoration: BoxDecoration(
                color: AppColors.softGreen.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -height * 0.13,
            left: -width * 0.25,
            child: Container(
              width: width * 0.75,
              height: width * 0.75,
              decoration: BoxDecoration(
                color: AppColors.softGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Header navigation
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: AppColors.primary,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                          shadowColor: Colors.black12,
                          elevation: 4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Verifikasi Wajah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Posisikan wajah Anda pada kamera.\nSistem akan memindai secara otomatis.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Camera or Error View
                  Expanded(
                    child: Center(
                      child: Obx(() {
                        if (controller.hasError.value) {
                          return _errorCard(width);
                        }
                        return _cameraCard(width);
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Status bar container
                  Obx(() => _statusBar()),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cameraCard(double width) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Obx(() {
        if (!controller.isCameraReady.value ||
            controller.cameraController == null ||
            !controller.cameraController!.value.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Camera Preview Frame
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.cameraController!.value.previewSize!.height,
                    height: controller.cameraController!.value.previewSize!.width,
                    child: CameraPreview(controller.cameraController!),
                  ),
                ),
              ),
            ),

            // Pulsing Green/Blue circular indicator
            Container(
              width: width * 0.58,
              height: width * 0.72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                border: Border.all(
                  color: controller.isMatched.value
                      ? Colors.green
                      : controller.isVerifying.value
                          ? Colors.orange
                          : AppColors.primary,
                  width: 3,
                ),
              ),
            ),

            // Verification status indicator overlay
            if (controller.isVerifying.value)
              const Positioned(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4,
                ),
              ),

            if (controller.isMatched.value)
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _statusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (controller.isMatched.value)
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
            )
          else if (controller.isVerifying.value)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          else
            const Icon(
              Icons.face_retouching_natural_rounded,
              color: AppColors.primary,
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              controller.statusText.value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(double width) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Kamera Bermasalah',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: controller.retryCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}