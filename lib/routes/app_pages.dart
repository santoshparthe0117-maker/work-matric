import 'package:get/get.dart';
import 'package:workmetric/views/add_employee.dart';
import 'package:workmetric/views/change_password_screen.dart';
import '../views/checkin_view.dart';
import '../views/forgot_password_page.dart';
import '../views/login_view.dart';
import '../views/manager_home_view.dart';
import '../views/splash_screen.dart';
import '../views/worker_history_view.dart';
import '../views/worker_detail_view.dart';
import '../views/account_view.dart';
import '../views/edit_profile_view.dart';

part 'app_routes.dart';

final routes = [
  GetPage(name: Routes.LOGIN, page: () => LoginView()),
  GetPage(name: Routes.SPLASH_SCREEN, page: () => SplashScreen()),
  GetPage(name: Routes.MANAGER_HOME, page: () => ManagerHomeView()),
  GetPage(name: Routes.WORKER_HOME, page: () => WorkerHomeView()),
  GetPage(name: Routes.WORKER_HISTORY, page: () => WorkerHistoryView()),
  GetPage(name: Routes.WORKER_DETAIL, page: () => WorkerDetailView()),
  GetPage(name: Routes.ACCOUNT, page: () => AccountView()),
  GetPage(name: Routes.EDIT_PROFILE, page: () => EditProfileView()),
  GetPage(name: Routes.ADD_EMPLOYEE, page: () => AddEmployeeView()),
  GetPage(name: Routes.CHANGE_PASSWORD, page: () => ChangePasswordView()),
  GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordPage())
];
