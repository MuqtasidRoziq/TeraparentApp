import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/article_model.dart';
import 'package:teraparent_mobile/app/data/services/article_service.dart';

class DetailArticleController extends GetxController {
  final ArticleService _articleService = Get.find<ArticleService>();

  final article = Rxn<ArticleModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final articleId = Get.arguments as String?;
    if (articleId != null && articleId.isNotEmpty) {
      fetchArticleDetail(articleId);
    } else {
      errorMessage.value = "ID Artikel tidak valid.";
    }
  }

  Future<void> fetchArticleDetail(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _articleService.getArticleById(id);
      if (response.success && response.data != null) {
        article.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
