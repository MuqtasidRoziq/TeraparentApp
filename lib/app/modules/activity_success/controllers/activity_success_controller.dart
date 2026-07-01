import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';

class ActivitySuccessController extends GetxController {
  late final Rxn<DailyActivityModel> activity;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    activity = Rxn<DailyActivityModel>(
      args is DailyActivityModel ? args : null,
    );
  }

  String get title => activity.value?.title ?? 'Aktivitas';
  String get domainLabel => activity.value?.domainLabel ?? '';
}
