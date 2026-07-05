import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/child_model.dart';
import '../../../data/services/child_service.dart';
import '../../../routes/app_pages.dart';

class ChildDataController extends GetxController {

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final namaAnakC = TextEditingController();
  final usiaC = TextEditingController();
  final tinggiC = TextEditingController();
  final beratC = TextEditingController();
  final initialDevelopmentNoteC = TextEditingController();

  final ChildService _childService = Get.find<ChildService>();

  final RxString gender = "Laki-Laki".obs;
  final isLoading = false.obs;
  final selectedDate = Rxn<DateTime>();

  void selectGender(String value) {
    gender.value = value;
  }

  String get backendGender {
    return gender.value == "Laki-Laki" ? "MALE" : "FEMALE";
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  Future<void> createChild() async {
    final namaAnak = namaAnakC.text.trim();
    final tinggiText = tinggiC.text.trim();
    final beratText = beratC.text.trim();
    final note = initialDevelopmentNoteC.text.trim();

    if (namaAnak.isEmpty ||
        tinggiText.isEmpty ||
        beratText.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field wajib diisi",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        "Error",
        "Tanggal lahir wajib dipilih",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    else if(selectedDate.value==DateTime.now()){
      Get.snackbar(
        "Error",
        "Mohon Tidak Menggunakan Tanggal Sekarang",
        snackPosition: SnackPosition.BOTTOM
      );
    }

    final tinggi = double.tryParse(tinggiText);
    final berat = double.tryParse(beratText);

    if (tinggi == null || tinggi <= 0) {
      Get.snackbar(
        "Error",
        "Tinggi badan tidak valid",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (berat == null || berat <= 0) {
      Get.snackbar(
        "Error",
        "Berat badan tidak valid",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final request = ChildRequestModel(
        childName: namaAnak,
        birthDate: selectedDate.value!,
        gender: backendGender,
        heightCm: tinggi,
        weightKg: berat,
        initialDevelopmentNote: note.isEmpty ? null : note,
      );

      final result = await _childService.createChild(
        request: request,
      );

      if (result.success) {
        final child = result.data!.child;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        
        await storage.write(key: 'childId', value: child.id);
        await prefs.setString("childName", child.childName);
        await prefs.setString("birthDate", child.birthDate.toString());
        await prefs.setString("gender", child.gender);
        await prefs.setDouble("heightCm", child.heightCm);
        await prefs.setDouble("weightCm", child.weightKg);
        await prefs.setBool('has_child_data', true);
        debugPrint("has_child_data : ${prefs.get('has_child_data')}");
        debugPrint('chiildId ${storage.read(key: 'childId')}');
        debugPrint('name ${prefs.get('name')}');
        
        Get.snackbar(
          "Berhasil",
          result.message.isNotEmpty
              ? result.message
              : "Data anak berhasil disimpan",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(Routes.HOME);

      } else {
        Get.snackbar(
          "Gagal",
          result.message.isNotEmpty
              ? result.message
              : "Gagal menyimpan data anak",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      print("Error saat membuat data anak: $e");
    } finally {
        if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    print("=== CHILD DATA CONTROLLER INIT $hashCode ===");
  }

  @override
  void onClose() {
    print("=== CHILD DATA CONTROLLER CLOSE $hashCode ===");

    namaAnakC.dispose();
    usiaC.dispose();
    tinggiC.dispose();
    beratC.dispose();
    initialDevelopmentNoteC.dispose();

    super.onClose();
  }
}