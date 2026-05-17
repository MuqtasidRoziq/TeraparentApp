import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class ChildDataController extends GetxController {
  final namaAnakC = TextEditingController();
  final usiaC = TextEditingController();
  final tinggiC = TextEditingController();
  final beratC = TextEditingController();

  RxString gender = "Laki".obs;
  var isLoading = false.obs;

  void selectGender(String value) {
    gender.value = value;
  }

  void childData() async{
    if(namaAnakC.text.isEmpty || usiaC.text.isEmpty || tinggiC.text.isEmpty || beratC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field wajib diisi",
      );
      return;
    }

      try {
        isLoading.value = true;
        await Future.delayed(
          const Duration(seconds: 2),
        );
  
        Get.offAllNamed(Routes.HOME);

        Get.snackbar(
          "Berhasil",
          "Data anak berhasil disimpan",
        );
  
      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
        );
      }
  }
}