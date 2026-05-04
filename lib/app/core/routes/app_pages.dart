import 'package:get/get.dart';
import '../../modules/client/tracking/views/tracking_screen.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/auth/login/views/login_view.dart';
import '../../modules/auth/login/controllers/login_controller.dart';
import '../../modules/role_selection/views/role_selection_view.dart';
import '../../modules/role_selection/controllers/role_selection_controller.dart';
import '../../modules/auth/sign_up/views/sign_up_view.dart';
import '../../modules/auth/sign_up/controllers/sign_up_controller.dart';
import '../../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../../modules/auth/forgot_password/controllers/forgot_password_controller.dart';
import '../../modules/auth/verification/views/verification_view.dart';
import '../../modules/auth/verification/controllers/verification_controller.dart';
import '../../modules/auth/reset_password/views/reset_password_view.dart';
import '../../modules/auth/reset_password/controllers/reset_password_controller.dart';
import '../../modules/auth/reset_password/views/reset_success_view.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../modules/client/service_details/views/service_details_view.dart';
import '../../modules/client/service_details/controllers/service_details_controller.dart';
import '../../modules/client/services/views/services_view.dart';
import '../../modules/client/services/controllers/services_controller.dart';
import '../../modules/client/popular_services/views/popular_services_view.dart';
import '../../modules/client/popular_services/controllers/popular_services_controller.dart';
import '../../modules/client/booking/views/booking_view.dart';
import '../../modules/client/booking/controllers/booking_controller.dart';
import '../../modules/client/camera/views/camera_view.dart';
import '../../modules/client/camera/controllers/camera_controller.dart';
import '../../modules/client/booking/views/confirm_booking_view.dart';
import '../../modules/client/chat/views/chat_view.dart';
import '../../modules/client/chat/controllers/chat_controller.dart';
import '../../modules/client/finding_artisan/views/finding_artisan_view.dart';
import '../../modules/client/finding_artisan/controllers/finding_artisan_controller.dart';
import '../../modules/client/tracking/views/tracking_view.dart';
import '../../modules/client/tracking/controllers/tracking_controller.dart';
import '../../modules/client/work_overview/views/work_overview_view.dart';
import '../../modules/client/work_overview/controllers/work_overview_controller.dart';
import '../../modules/client/payment/views/payment_view.dart';
import '../../modules/client/payment/controllers/payment_controller.dart';
import '../../modules/client/payment_success/views/payment_success_view.dart';
import '../../modules/client/payment_success/controllers/payment_success_controller.dart';
import '../../modules/client/edit_profile/views/edit_profile_view.dart';
import '../../modules/client/edit_profile/controllers/edit_profile_controller.dart';
import '../../modules/support/views/help_support_view.dart';
import '../../modules/support/views/faqs_view.dart';
import '../../modules/support/views/feedback_view.dart';
import '../../modules/support/views/privacy_policy_view.dart';
import '../../modules/support/views/terms_of_service_view.dart';
import '../../modules/support/controllers/support_controller.dart';
import '../../modules/client/sub_category/views/sub_category_view.dart';
import '../../modules/client/sub_category/controllers/sub_category_controller.dart';
import '../../modules/client/location/views/select_location_view.dart';
import '../../modules/client/location/controllers/select_location_controller.dart';
import '../../modules/client/notifications/views/notification_view.dart';
import '../../modules/client/notifications/controllers/notification_controller.dart';
import '../../modules/client/payment_method/views/payment_method_view.dart';
import '../../modules/client/payment_method/controllers/payment_method_controller.dart';
import '../../modules/client/add_card/views/add_card_view.dart';
import '../../modules/client/add_card/controllers/add_card_controller.dart';
import '../../modules/client/saved_addresses/views/saved_addresses_view.dart';
import '../../modules/client/saved_addresses/controllers/saved_addresses_controller.dart';
import '../../modules/client/security/views/security_view.dart';
import '../../modules/client/security/views/change_password_view.dart';
import '../../modules/client/security/controllers/security_controller.dart';
import '../../modules/client/get_bonus/views/get_bonus_view.dart';
import '../../modules/client/get_bonus/controllers/get_bonus_controller.dart';
import '../../modules/client/activity/views/activity_view.dart';
import '../../modules/client/activity/controllers/activity_controller.dart';
import './app_routes.dart';

import '../../modules/worker/job_completion/views/job_completion_view.dart';
import '../../modules/worker/job_completion/controllers/job_completion_controller.dart';
import '../../modules/worker/chat/views/worker_chat_view.dart';
import '../../modules/worker/chat/controllers/worker_chat_controller.dart';
import '../../modules/worker/job_details/views/worker_job_details_view.dart';
import '../../modules/worker/job_details/controllers/worker_job_details_controller.dart';
import '../../modules/worker/verification/views/worker_verification_view.dart';
import '../../modules/worker/verification/controllers/worker_verification_controller.dart';
import '../../modules/worker/job_details/views/worker_navigation_view.dart';
import '../../modules/worker/job_details/views/worker_job_status_view.dart';
import '../../modules/worker/job_details/views/worker_active_job_view.dart';
import '../../modules/worker/job_details/views/report_issue_view.dart';
import '../../modules/worker/job_details/controllers/worker_job_status_controller.dart';
import '../../modules/worker/job_details/controllers/report_issue_controller.dart';
import '../../modules/worker/account/views/worker_account_settings_view.dart';
import '../../modules/worker/account/controllers/worker_account_settings_controller.dart';
import '../../modules/worker/account/views/worker_saved_addresses_view.dart';
import '../../modules/worker/account/controllers/worker_saved_addresses_controller.dart';
import '../../modules/worker/account/views/worker_payment_method_view.dart';
import '../../modules/worker/account/controllers/worker_payment_method_controller.dart';
import '../../modules/worker/account/views/worker_add_card_view.dart';
import '../../modules/worker/account/controllers/worker_add_card_controller.dart';
import '../../modules/worker/account/views/my_reviews_view.dart';
import '../../modules/worker/account/controllers/my_reviews_controller.dart';
import '../../modules/worker/account/views/performance_view.dart';
import '../../modules/worker/account/controllers/performance_controller.dart';
import '../../modules/worker/tracking/views/worker_tracking_view.dart';
import '../../modules/worker/tracking/controllers/worker_tracking_controller.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(name: Routes.ONBOARDING, page: () => const OnboardingView()),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: Routes.ROLE_SELECTION,
      page: () => const RoleSelectionView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RoleSelectionController>(() => RoleSelectionController());
      }),
    ),
    GetPage(
      name: Routes.SIGN_UP,
      page: () => const SignUpView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SignUpController>(() => SignUpController());
      }),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: Routes.VERIFICATION,
      page: () => const VerificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VerificationController>(() => VerificationController());
      }),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
      }),
    ),
    GetPage(name: Routes.SUCCESS, page: () => const ResetSuccessView()),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
    ),
    GetPage(
      name: Routes.SERVICES,
      page: () => const ServicesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ServicesController>(() => ServicesController());
      }),
    ),
    GetPage(
      name: Routes.POPULAR_SERVICES,
      page: () => const PopularServicesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PopularServicesController>(
          () => PopularServicesController(),
        );
      }),
    ),
    GetPage(
      name: Routes.SUB_CATEGORY,
      page: () => const SubCategoryView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SubCategoryController>(() => SubCategoryController());
      }),
    ),
    GetPage(
      name: Routes.SERVICE_DETAILS,
      page: () => const ServiceDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ServiceDetailsController>(() => ServiceDetailsController());
      }),
    ),
    GetPage(
      name: Routes.BOOKING,
      page: () => const BookingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BookingController>(() => BookingController());
      }),
    ),
    GetPage(
      name: Routes.CAMERA,
      page: () => const CameraView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CameraController>(() => CameraController());
      }),
    ),
    GetPage(
      name: Routes.CONFIRM_BOOKING,
      page: () => const ConfirmBookingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BookingController>(
          () => BookingController(),
        ); // Share existing booking state
      }),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const ChatView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatController>(() => ChatController());
      }),
    ),
    GetPage(
      name: Routes.FINDING_ARTISAN,
      page: () => const FindingArtisanView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<FindingArtisanController>(() => FindingArtisanController());
      }),
    ),
    GetPage(
      name: Routes.TRACKING,
      page: () => const TrackingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TrackingController>(() => TrackingController());
      }),
    ),
    GetPage(
      name: Routes.TRACKINGSCREEN,
      page: () => const TrackingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TrackingController>(() => TrackingController());
      }),
    ),
    GetPage(
      name: Routes.WORK_OVERVIEW,
      page: () => const WorkOverviewView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkOverviewController>(() => WorkOverviewController());
      }),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PaymentController>(() => PaymentController());
      }),
    ),
    GetPage(
      name: Routes.PAYMENT_SUCCESS,
      page: () => const PaymentSuccessView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PaymentSuccessController>(() => PaymentSuccessController());
      }),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<EditProfileController>(() => EditProfileController());
      }),
    ),
    GetPage(
      name: Routes.HELP_SUPPORT,
      page: () => const HelpSupportView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportController>(() => SupportController());
      }),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportController>(() => SupportController());
      }),
    ),
    GetPage(
      name: Routes.TERMS_OF_SERVICE,
      page: () => const TermsOfServiceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportController>(() => SupportController());
      }),
    ),
    GetPage(
      name: Routes.FAQS,
      page: () => const FaqsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportController>(() => SupportController());
      }),
    ),
    GetPage(
      name: Routes.FEEDBACK,
      page: () => const FeedbackView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportController>(() => SupportController());
      }),
    ),
    GetPage(
      name: Routes.JOB_COMPLETION,
      page: () => const JobCompletionView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<JobCompletionController>(() => JobCompletionController());
      }),
    ),
    GetPage(
      name: Routes.WORKER_CHAT,
      page: () => const WorkerChatView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerChatController>(() => WorkerChatController());
      }),
    ),
    GetPage(
      name: Routes.WORKER_JOB_DETAILS,
      page: () => const WorkerJobDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerJobDetailsController>(
          () => WorkerJobDetailsController(),
        );
      }),
    ),
    GetPage(
      name: Routes.WORKER_NAVIGATION,
      page: () => const WorkerNavigationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerJobDetailsController>(
          () => WorkerJobDetailsController(),
        );
        Get.lazyPut<WorkerJobStatusController>(
          () => WorkerJobStatusController(),
        );
      }),
    ),
    GetPage(
      name: Routes.WORKER_JOB_STATUS,
      page: () => const WorkerJobStatusView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerJobStatusController>(
          () => WorkerJobStatusController(),
        );
      }),
    ),
    GetPage(
      name: Routes.WORKER_ACTIVE_JOB,
      page: () => const WorkerActiveJobView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerJobDetailsController>(
          () => WorkerJobDetailsController(),
        );
      }),
    ),
    GetPage(
      name: Routes.REPORT_ISSUE,
      page: () => const ReportIssueView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ReportIssueController>(() => ReportIssueController());
      }),
    ),
    GetPage(
      name: Routes.WORKER_VERIFICATION,
      page: () => const WorkerVerificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerVerificationController>(
          () => WorkerVerificationController(),
        );
      }),
    ),
    GetPage(
      name: Routes.SELECT_LOCATION,
      page: () => const SelectLocationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SelectLocationController>(() => SelectLocationController());
      }),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NotificationController>(() => NotificationController());
      }),
    ),
    GetPage(
      name: Routes.PAYMENT_METHOD,
      page: () => const PaymentMethodView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PaymentMethodController>(() => PaymentMethodController());
      }),
    ),
    GetPage(
      name: Routes.ADD_CARD,
      page: () => const AddCardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddCardController>(() => AddCardController());
      }),
    ),
    GetPage(
      name: Routes.SAVED_ADDRESSES,
      page: () => const SavedAddressesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SavedAddressesController>(() => SavedAddressesController());
      }),
    ),
    GetPage(
      name: Routes.SECURITY,
      page: () => const SecurityView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SecurityController>(() => SecurityController());
      }),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SecurityController>(() => SecurityController());
      }),
    ),
    GetPage(
      name: Routes.GET_BONUS,
      page: () => const GetBonusView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<GetBonusController>(() => GetBonusController());
      }),
    ),
    GetPage(
      name: Routes.ORDER_HISTORY,
      page: () => const ActivityView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ActivityController>(() => ActivityController());
      }),
    ),
    GetPage(
      name: Routes.WORKER_ACCOUNT_SETTINGS,
      page: () => const WorkerAccountSettingsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerAccountSettingsController>(
          () => WorkerAccountSettingsController(),
        );
      }),
    ),
    GetPage(
      name: Routes.WORKER_SAVED_ADDRESSES,
      page: () => const WorkerSavedAddressesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerSavedAddressesController>(
          () => WorkerSavedAddressesController(),
        );
      }),
    ),
    GetPage(
      name: Routes.WORKER_PAYMENT_METHOD,
      page: () => const WorkerPaymentMethodView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerPaymentMethodController>(
          () => WorkerPaymentMethodController(),
        );
      }),
    ),
    GetPage(
      name: Routes.WORKER_ADD_CARD,
      page: () => const WorkerAddCardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerAddCardController>(() => WorkerAddCardController());
      }),
    ),
    GetPage(
      name: Routes.MY_REVIEWS,
      page: () => const MyReviewsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MyReviewsController>(() => MyReviewsController());
      }),
    ),
    GetPage(
      name: Routes.PERFORMANCE,
      page: () => const PerformanceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PerformanceController>(() => PerformanceController());
      }),
    ),
    GetPage(
      name: Routes.WORKER_TRACKING,
      page: () => const WorkerTrackingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerTrackingController>(() => WorkerTrackingController());
      }),
    ),
  ];
}
