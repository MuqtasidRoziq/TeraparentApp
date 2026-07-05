import 'package:get/route_manager.dart';

SnackbarController SnackbarSuccess(title, message){
  return Get.snackbar(
    title, 
    message);
}