import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import 'package:teraparent_mobile/app/data/services/user_services.dart';

class InfoPribadiController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final UserService _userService = Get.find<UserService>();
  final ImagePicker _picker = ImagePicker();

  var isLoading = false.obs;
  var isUploadingPhoto = false.obs;
  final profilePhotoUrl = ''.obs;
  final selectedPhotoFile = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('full_name') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    phoneController.text = prefs.getString('phone') ?? '';
    // Read same key that LoginController writes after login
    profilePhotoUrl.value = _userService.userPhotoUrl.value.isNotEmpty
        ? _userService.userPhotoUrl.value
        : (prefs.getString('photo_url') ?? '');
  }

  Future<void> pickProfilePhoto() async {
    final source = await Get.dialog<ImageSource>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Foto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Color(0xFF2B5B4B)),
                title: const Text('Kamera'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF2B5B4B)),
                title: const Text('Galeri'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        selectedPhotoFile.value = File(picked.path);
        await _uploadPhoto(File(picked.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih foto: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('ERROR PICK PHOTO: ${e.toString()}');
    }
  }

  Future<void> _uploadPhoto(File file) async {
    isUploadingPhoto.value = true;
    try {
      final response = await _userService.uploadProfilePhoto(file);
      if (response.success) {
        // UserService.uploadProfilePhoto already saves to SharedPreferences
        // and updates _userService.userPhotoUrl — just sync our local obs
        profilePhotoUrl.value = _userService.userPhotoUrl.value;
        Get.snackbar(
          'Sukses',
          'Foto profil berhasil diperbarui.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Gagal',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        debugPrint('ERROR UPLOAD PHOTO: ${response.message}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('ERROR UPLOAD PHOTO: ${e.toString()}');
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  void saveChanges() async {
    isLoading.value = true;
    try {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();

      final response = await _userService.updateProfile(
        fullName: name,
        phone: phone,
      );

      if (response.success) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('full_name', name);
        await prefs.setString('phone', phone);

        Get.snackbar(
          'Sukses',
          'Perubahan informasi pribadi berhasil disimpan.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(Routes.PROFIL);
      } else {
        Get.snackbar(
          'Gagal',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}