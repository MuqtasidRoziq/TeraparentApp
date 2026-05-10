import 'package:get/get.dart';

class RegisterController extends GetxController {
  var isPasswordHidden = true.obs;
  var isChecked = false.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }
}