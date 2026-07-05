import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/services/screening_services.dart';
import 'package:teraparent_mobile/app/data/services/user_services.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ScreeningService _screeningService = Get.find<ScreeningService>();
  final UserService _userService = Get.find<UserService>();

  final isLoading = false.obs;
  final userName = ''.obs;
  final profileUrl = ''.obs;
  final childName = ''.obs;
  final childAge = ''.obs;
  final indication = ''.obs;
  final riskCategory = ''.obs;
  final childPhotoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      userName.value = prefs.getString('full_name') ?? 'user';
      // Use 'photo_url' — same key that LoginController saves after login
      profileUrl.value = prefs.getString('photo_url') ?? '';
      // Keep UserService in sync
      _userService.userPhotoUrl.value = profileUrl.value;
      _userService.userFullName.value = userName.value;
      childName.value = prefs.getString('childName') ?? 'Ananda';
      // Also try birthDate (key used by login) as fallback for childDob
      childPhotoUrl.value = prefs.getString('child_photo_url') ?? '';

      // Login saves 'birthDate'; fallback to 'childDob' for older sessions
      final dobStr = prefs.getString('birthDate') ?? prefs.getString('childDob');
      if (dobStr != null && dobStr.isNotEmpty) {
        try {
          final dob = DateTime.parse(dobStr);
          final now = DateTime.now();
          int age = now.year - dob.year;
          if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
            age--;
          }
          childAge.value = '$age tahun';
        } catch (e) {
          childAge.value = '';
        }
      }

      // Fetch indikasi dari screening terbaru
      final childId = await _storage.read(key: 'childId');
      if (childId != null && childId.isNotEmpty) {
        await _loadLatestScreeningIndication(childId);
      } else {
        indication.value = prefs.getString('mainIndication') ?? '';
        riskCategory.value = prefs.getString('riskCategory') ?? '';
      }
    } catch (e) {
      debugPrint('ProfileController loadProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadLatestScreeningIndication(String childId) async {
    try {
      final response = await _screeningService.getHistory(childId: childId);
      if (response.success && response.data != null && response.data!.isNotEmpty) {
        // Sort by completedAt descending and take the latest completed one
        final history = response.data!
            .where((s) => s.status == 'COMPLETED')
            .toList()
          ..sort((a, b) => (b.completedAt ?? DateTime(0)).compareTo(a.completedAt ?? DateTime(0)));

        if (history.isNotEmpty) {
          indication.value = history.first.mainIndication;
          riskCategory.value = history.first.riskCategory;
          return;
        }
      }
      // Fallback to prefs
      final prefs = await SharedPreferences.getInstance();
      indication.value = prefs.getString('mainIndication') ?? '';
      riskCategory.value = prefs.getString('riskCategory') ?? '';
    } catch (e) {
      debugPrint('Failed to load screening indication: $e');
      final prefs = await SharedPreferences.getInstance();
      indication.value = prefs.getString('mainIndication') ?? '';
      riskCategory.value = prefs.getString('riskCategory') ?? '';
    }
  }

  String get userNameText {
    if (userName.value.trim().isEmpty) {
      return 'User';
    }
    return userName.value;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'childId');
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('email');
    await prefs.remove('full_name');
    await prefs.remove('phone');
    await prefs.remove('photo_url');
    await prefs.remove('profile_url');
    await prefs.remove('is_email_verified');
    await prefs.remove('is_face_recognition_active');
    await prefs.remove('has_child_data');
    await prefs.remove('pending_otp');
    await prefs.remove('pending_otp_email');
    await prefs.remove('pending_otp_expired_at');
    await prefs.remove('mainIndication');
    await prefs.remove('riskCategory');

    debugPrint('Anda telah keluar.');

    Get.offAllNamed(Routes.LOGIN);
  }
}