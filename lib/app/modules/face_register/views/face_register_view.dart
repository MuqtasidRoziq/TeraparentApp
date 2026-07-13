
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import '../controllers/face_register_controller.dart';

class FaceRegisterView extends GetView<FaceRegisterController> {
  const FaceRegisterView({super.key});

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

                  // Titles
                  const Text(
                    'Registrasi Wajah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Step indicator (3 bullets)
                  Obx(() => _buildStepIndicator()),

                  const SizedBox(height: 20),

                  // Camera Container or Error Card or Success
                  Expanded(
                    child: Center(
                      child: Obx(() {
                        if (controller.isSuccess.value) {
                          return _successOverlay(width);
                        }
                        if (controller.hasError.value) {
                          return _errorCard(width);
                        }
                        return _cameraCard(width);
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Status Banner
                  Obx(() => _statusBanner()),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // STEP INDICATOR
  // ──────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    const steps = ['Depan', 'Kiri', 'Kanan'];
    final progress = controller.stepProgress.value; // 0, 1, 2, 3

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Garis penghubung
          final lineIndex = index ~/ 2;
          final isCompleted = progress > lineIndex + 1;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 36,
            height: 2,
            color: isCompleted ? AppColors.primary : Colors.grey.shade300,
          );
        }
        final stepIndex = index ~/ 2;
        final isCompleted = progress > stepIndex;
        final isActive = progress == stepIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: isActive ? 36 : 32,
          height: isActive ? 36 : 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.primary
                : isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.grey.shade200,
            border: Border.all(
              color: isActive || isCompleted
                  ? AppColors.primary
                  : Colors.grey.shade300,
              width: isActive ? 2.5 : 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.primary : Colors.grey,
                    ),
                  ),
          ),
        );
      }),
    );
  }

  // ──────────────────────────────────────────────────
  // CAMERA CARD
  // ──────────────────────────────────────────────────
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
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Camera Preview fit
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

            // Animated oval border (rotates based on step)
            _AnimatedFaceOval(
              step: controller.currentStep.value,
              isProcessing: controller.isProcessing.value,
              width: width,
            ),

            // Arrow direction indicator
            Positioned(
              bottom: 16,
              child: _buildDirectionArrow(),
            ),

            // Processing spinner
            if (controller.isProcessing.value)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildDirectionArrow() {
    final step = controller.currentStep.value;
    IconData icon;
    String label;

    switch (step) {
      case FaceRegisterStep.left:
        icon = Icons.arrow_back_rounded;
        label = 'Putar ke Kiri';
        break;
      case FaceRegisterStep.right:
        icon = Icons.arrow_forward_rounded;
        label = 'Putar ke Kanan';
        break;
      default:
        icon = Icons.face_retouching_natural_rounded;
        label = 'Hadap Depan';
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(step),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // SUCCESS OVERLAY
  // ──────────────────────────────────────────────────
  Widget _successOverlay(double width) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated check circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Registrasi Berhasil!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Wajah Anda telah terdaftar.\nLogin wajah kini aktif untuk akun ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),

          // Confetti dots decoration
          _buildConfettiRow(),

          const SizedBox(height: 20),
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kembali ke halaman keamanan...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiRow() {
    final colors = [
      AppColors.primary,
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.amber,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.map((c) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }

  // ──────────────────────────────────────────────────
  // STATUS BANNER
  // ──────────────────────────────────────────────────
  Widget _statusBanner() {
    if (controller.isSuccess.value) return const SizedBox.shrink();

    final active = controller.isProcessing.value;
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
          if (active)
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

  // ──────────────────────────────────────────────────
  // ERROR CARD
  // ──────────────────────────────────────────────────
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

// ──────────────────────────────────────────────────
// ANIMATED FACE OVAL (rotasi oval sesuai step)
// ──────────────────────────────────────────────────
class _AnimatedFaceOval extends StatefulWidget {
  final FaceRegisterStep step;
  final bool isProcessing;
  final double width;

  const _AnimatedFaceOval({
    required this.step,
    required this.isProcessing,
    required this.width,
  });

  @override
  State<_AnimatedFaceOval> createState() => _AnimatedFaceOvalState();
}

class _AnimatedFaceOvalState extends State<_AnimatedFaceOval>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double get _targetTiltAngle {
    switch (widget.step) {
      case FaceRegisterStep.left:
        return -0.15; // Miring ke kiri
      case FaceRegisterStep.right:
        return 0.15; // Miring ke kanan
      default:
        return 0.0; // Lurus
    }
  }

  Color get _borderColor {
    if (widget.isProcessing) return Colors.orange;
    switch (widget.step) {
      case FaceRegisterStep.front:
        return AppColors.primary;
      case FaceRegisterStep.left:
        return Colors.teal;
      case FaceRegisterStep.right:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: _targetTiltAngle),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, tilt, _) {
            return Transform.rotate(
              angle: tilt,
              child: Transform.scale(
                scale: widget.isProcessing ? 1.0 : _pulseAnimation.value,
                child: Container(
                  width: widget.width * 0.58,
                  height: widget.width * 0.72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    border: Border.all(
                      color: _borderColor,
                      width: 3.5,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
