import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/psikolog_model.dart';
import 'package:teraparent_mobile/app/data/services/psikolog_service.dart';

class DetailPsikologController extends GetxController {
  final PsikologService _psikologService = Get.find<PsikologService>();

  var isLoading = true.obs;
  var errorMessage = "".obs;
  var psikolog = Rxn<PsikologModel>();

  // ID of the psychologist to fetch
  final String psikologId;

  DetailPsikologController(this.psikologId);

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      final response = await _psikologService.getPsikologById(psikologId);
      if (response.success && response.data != null) {
        psikolog.value = response.data;
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
