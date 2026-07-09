import 'package:get/get.dart';

import '../modules/Riwayat/bindings/riwayat_binding.dart';
import '../modules/Riwayat/views/riwayat_view.dart';
import '../modules/activities/bindings/activities_binding.dart';
import '../modules/activities/views/activities_view.dart';
import '../modules/activity_success/bindings/activity_success_binding.dart';
import '../modules/activity_success/views/activity_success_view.dart';
import '../modules/ahli_terapis/bindings/ahli_terapis_binding.dart';
import '../modules/ahli_terapis/views/ahli_terapis_view.dart';
import '../modules/child_date/bindings/child_date_binding.dart';
import '../modules/child_date/views/child_date_view.dart';
import '../modules/detail_activity/bindings/detail_activity_binding.dart';
import '../modules/detail_activity/views/detail_activity_view.dart';
import '../modules/face_login/bindings/face_login_binding.dart';
import '../modules/face_login/views/face_login_view.dart';
import '../modules/face_register/bindings/face_register_binding.dart';
import '../modules/face_register/views/face_register_view.dart';
import '../modules/forgotpass/bindings/forgotpass_binding.dart';
import '../modules/forgotpass/views/forgotpass_view.dart';
import '../modules/grafik_perkembangan/bindings/grafik_perkembangan_binding.dart';
import '../modules/grafik_perkembangan/views/grafik_perkembangan_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info_pribadi/bindings/info_pribadi_binding.dart';
import '../modules/info_pribadi/views/info_pribadi_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation_bar/bindings/navigation_bar_binding.dart';
import '../modules/navigation_bar/views/navigation_bar_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/result_screening/bindings/result_screening_binding.dart';
import '../modules/result_screening/views/result_screening_view.dart';
import '../modules/screening/bindings/screening_binding.dart';
import '../modules/screening/views/screening_view.dart';
import '../modules/security_password/bindings/security_password_binding.dart';
import '../modules/security_password/views/security_password_view.dart';
import '../modules/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/verify_otp/views/verify_otp_view.dart';
import '../modules/verify_otppass/bindings/verify_otppass_binding.dart';
import '../modules/verify_otppass/views/verify_otppass_view.dart';
import '../modules/verify_success/bindings/verify_success_binding.dart';
import '../modules/verify_success/views/verify_success_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FORGOTPASS,
      page: () => const ForgotpassView(),
      binding: ForgotpassBinding(),
    ),
    GetPage(
      name: _Paths.INFO_PRIBADI,
      page: () => const InfoPribadiView(),
      binding: InfoPribadiBinding(),
    ),
    GetPage(
      name: _Paths.SECURITY_PASSWORD,
      page: () => const SecurityPasswordView(),
      binding: SecurityPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SCREENING,
      page: () => const ScreeningView(),
      binding: ScreeningBinding(),
    ),
    GetPage(
      name: _Paths.CHILD_DATE,
      page: () => const ChildDataView(),
      binding: ChildDataBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITIES,
      page: () => const ActivitiesView(),
      binding: ActivitiesBinding(),
    ),
    GetPage(
      name: _Paths.AHLI_TERAPIS,
      page: () => const AhliTerapisView(),
      binding: AhliTerapisBinding(),
    ),
    GetPage(
      name: _Paths.GRAFIK_PERKEMBANGAN,
      page: () => const GrafikPerkembanganView(),
      binding: GrafikPerkembanganBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_ACTIVITY,
      page: () => const DetailActivityView(),
      binding: DetailActivityBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY_SUCCESS,
      page: () => const ActivitySuccessView(),
      binding: ActivitySuccessBinding(),
    ),
    GetPage(
      name: _Paths.RESULT_SCREENING,
      page: () => const ResultScreeningView(),
      binding: ResultScreeningBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_SUCCESS,
      page: () => const VerifySuccessView(),
      binding: VerifySuccessBinding(),
    ),
    GetPage(
      name: _Paths.FACE_REGISTER,
      page: () => const FaceRegisterView(),
      binding: FaceRegisterBinding(),
    ),
    GetPage(
      name: _Paths.FACE_LOGIN,
      page: () => const FaceLoginView(),
      binding: FaceLoginBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_OTPPASS,
      page: () => const VerifyOtppassView(),
      binding: VerifyOtppassBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_BAR,
      page: () => const NavigationBarView(),
      binding: NavigationBarBinding(),
    ),
  ];
}
