import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/child_model.dart';
import '../../../data/services/child_service.dart';
import '../../../routes/app_pages.dart';

class ChildDataController extends GetxController {
  final namaAnakC = TextEditingController();
  final usiaC = TextEditingController();
  final tinggiC = TextEditingController();
  final beratC = TextEditingController();
  final initialDevelopmentNoteC = TextEditingController();

  final ChildCreateService _childService = Get.find<ChildCreateService>();

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
    final usiaText = usiaC.text.trim();
    final tinggiText = tinggiC.text.trim();
    final beratText = beratC.text.trim();
    final note = initialDevelopmentNoteC.text.trim();

    if (namaAnak.isEmpty ||
        usiaText.isEmpty ||
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

    final usiaTahun = int.tryParse(usiaText);
    final tinggi = double.tryParse(tinggiText);
    final berat = double.tryParse(beratText);

    if (usiaTahun == null || usiaTahun < 0) {
      Get.snackbar(
        "Error",
        "Usia anak tidak valid",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

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
        name: namaAnak,
        birthDate: selectedDate.value!,
        ageYear: usiaTahun,
        gender: backendGender,
        heightCm: tinggi,
        weightKg: berat,
        initialDevelopmentNote: note.isEmpty ? null : note,
      );

      final result = await _childService.createChild(
        request: request,
      );

      if (result.success) {

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
  void onClose() {
    // namaAnakC.dispose();
    // usiaC.dispose();
    // tinggiC.dispose();
    // beratC.dispose();
    // initialDevelopmentNoteC.dispose();
    debugPrint("ChildDataController onClose dipanggil");
    super.onClose();
  }
}