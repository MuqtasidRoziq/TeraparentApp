import 'package:shared_preferences/shared_preferences.dart';

class OtpSessionService {
  static const String _pendingOtpKey = 'pending_otp';
  static const String _pendingOtpEmailKey = 'pending_otp_email';
  static const String _pendingOtpExpiredAtKey = 'pending_otp_expired_at';

  Future<void> savePendingOtp({
    required String email,
    int validSeconds = 120,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final expiredAt = DateTime.now()
        .add(Duration(seconds: validSeconds))
        .millisecondsSinceEpoch;

    await prefs.setBool(_pendingOtpKey, true);
    await prefs.setString(_pendingOtpEmailKey, email);
    await prefs.setInt(_pendingOtpExpiredAtKey, expiredAt);
  }

  Future<bool> hasPendingOtp() async {
    final prefs = await SharedPreferences.getInstance();

    final isPending = prefs.getBool(_pendingOtpKey) ?? false;
    final email = prefs.getString(_pendingOtpEmailKey);

    return isPending && email != null && email.isNotEmpty;
  }

  Future<String?> getPendingEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pendingOtpEmailKey);
  }

  Future<int> getRemainingSeconds() async {
    final prefs = await SharedPreferences.getInstance();

    final expiredAt = prefs.getInt(_pendingOtpExpiredAtKey);

    if (expiredAt == null) return 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    final remaining = ((expiredAt - now) / 1000).ceil();

    return remaining > 0 ? remaining : 0;
  }

  Future<void> clearPendingOtp() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_pendingOtpKey);
    await prefs.remove(_pendingOtpEmailKey);
    await prefs.remove(_pendingOtpExpiredAtKey);
  }
}