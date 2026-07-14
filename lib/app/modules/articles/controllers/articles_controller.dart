import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/article_model.dart';
import 'package:teraparent_mobile/app/data/services/article_service.dart';

class ArticlesController extends GetxController {
  final ArticleService _articleService = Get.find<ArticleService>();

  final articles = <ArticleModel>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'Semua'.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final filterCategory = selectedCategory.value == 'Semua' ? null : selectedCategory.value;
      final response = await _articleService.getAllArticles(
        kategori: filterCategory,
        page: 1,
        limit: 50,
      );

      if (response.success && response.data != null) {
        articles.assignAll(response.data!);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      fetchArticles();
    }
  }
}
