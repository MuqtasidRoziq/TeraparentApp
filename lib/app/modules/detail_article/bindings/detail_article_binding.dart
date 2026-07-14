import 'package:get/get.dart';
import '../controllers/detail_article_controller.dart';

class DetailArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailArticleController>(
      () => DetailArticleController(),
    );
  }
}
