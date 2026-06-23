import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

SnackbarController SnackbarSuccess(title, message){
  return Get.snackbar(
    title, 
    message);
}