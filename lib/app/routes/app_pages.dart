import 'package:get/get.dart';

import '../modules/child_date/bindings/child_date_binding.dart';
import '../modules/child_date/views/child_date_view.dart';
import '../modules/forgotpass/bindings/forgotpass_binding.dart';
import '../modules/forgotpass/views/forgotpass_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info_pribadi/bindings/info_pribadi_binding.dart';
import '../modules/info_pribadi/views/info_pribadi_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/screening/bindings/screening_binding.dart';
import '../modules/screening/views/screening_view.dart';
import '../modules/security_password/bindings/security_password_binding.dart';
import '../modules/security_password/views/security_password_view.dart';
import '../modules/settings_notification/bindings/settings_notification_binding.dart';
import '../modules/settings_notification/views/settings_notification_view.dart';

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
      name: _Paths.SETTINGS_NOTIFICATION,
      page: () => const SettingsNotificationView(),
      binding: SettingsNotificationBinding(),
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
  ];
}
