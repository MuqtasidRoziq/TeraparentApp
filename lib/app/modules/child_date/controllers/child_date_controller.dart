import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChildDataController extends GetxController {
  final namaAnakC = TextEditingController();
  final usiaC = TextEditingController();
  final tinggiC = TextEditingController();
  final beratC = TextEditingController();

  RxString gender = "Laki".obs;

  void selectGender(String value) {
    gender.value = value;
  }

  void lanjutkan() {
    Get.offAllNamed('/home');
  }
}