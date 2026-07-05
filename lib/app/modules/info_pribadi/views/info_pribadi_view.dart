import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/info_pribadi_controller.dart';

class InfoPribadiView extends GetView<InfoPribadiController> {
  const InfoPribadiView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2B5B4B);
    const Color inputBgColor = Color(0xFFF4F6F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Informasi Pribadi',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 28),

            // --- FOTO PROFIL ---
            Center(
              child: Stack(
                children: [
                  // Lingkaran foto
                  Obx(() {
                    final file = controller.selectedPhotoFile.value;
                    final url = controller.profilePhotoUrl.value;
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2B5B4B), Color(0xFF4CAF9A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2B5B4B).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: file != null
                            ? FileImage(file) as ImageProvider
                            : (url.isNotEmpty ? NetworkImage(url) : null),
                        child: (file == null && url.isEmpty)
                            ? const Icon(Icons.person, size: 50, color: Color(0xFFBDBDBD))
                            : null,
                      ),
                    );
                  }),
                  // Tombol edit foto
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Obx(() => GestureDetector(
                      onTap: controller.isUploadingPhoto.value ? null : controller.pickProfilePhoto,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: controller.isUploadingPhoto.value
                              ? Colors.grey
                              : primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: controller.isUploadingPhoto.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    )),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Ketuk ikon kamera untuk ganti foto',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 32),

            // --- SECTION TITLE ---
            const Text(
              'Data Diri',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            // --- FORM INPUT FIELDS ---
            _buildInputField(
              label: 'Nama Lengkap',
              icon: Icons.person_outline,
              controller: controller.nameController,
              backgroundColor: inputBgColor,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Email',
              icon: Icons.mail_outline,
              controller: controller.emailController,
              backgroundColor: inputBgColor,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
              hint: 'Email tidak dapat diubah',
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Nomor Telepon',
              icon: Icons.phone_outlined,
              controller: controller.phoneController,
              backgroundColor: inputBgColor,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),

            // --- TOMBOL SIMPAN ---
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required Color backgroundColor,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: enabled ? const Color(0xFF2C3E35) : Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: TextStyle(
            fontSize: 15,
            color: enabled ? const Color(0xFF1C2D27) : Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: enabled ? const Color(0xFF2B5B4B) : Colors.grey.shade400, size: 22),
            filled: true,
            fillColor: enabled ? backgroundColor : const Color(0xFFECECEC),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2B5B4B), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
