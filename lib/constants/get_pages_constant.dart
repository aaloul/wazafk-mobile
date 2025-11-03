import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/all_categories/all_categories_screen.dart';
import 'package:wazafak_app/screens/main/apply_job/apply_job_screen.dart';
import 'package:wazafak_app/screens/main/book_service/book_service_screen.dart';
import 'package:wazafak_app/screens/main/job_applicants/job_applicants_screen.dart';
import 'package:wazafak_app/screens/main/profile/jobs/add_job/add_job_screen.dart';
import 'package:wazafak_app/screens/main/profile/notification_settings/notification_settings_screen.dart';

import '../screens/auth/create_account/create_account_screen.dart';
import '../screens/auth/login_password/login_password_screen.dart';
import '../screens/auth/onboarding/onboarding_screen.dart';
import '../screens/auth/phone_number/phone_number_screen.dart';
import '../screens/auth/reset_password/reset_password_screen.dart';
import '../screens/auth/select_portal/select_portal_screen.dart';
import '../screens/auth/splash/splash_screen.dart';
import '../screens/auth/verification/verification_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/common/terms/terms_screen.dart';
import '../screens/main/job_details/job_details_screen.dart';
import '../screens/main/main_navigation_screen.dart';
import '../screens/main/member_profiles/employer_member_profile/employer_member_profile_screen.dart';
import '../screens/main/member_profiles/employer_rate_member/employer_rate_member_screen.dart';
import '../screens/main/member_profiles/freelancer_member_profile/freelancer_member_profile_screen.dart';
import '../screens/main/package_details/package_details_screen.dart';
import '../screens/main/profile/about_us/about_us_screen.dart';
import '../screens/main/profile/change_language/change_language_screen.dart';
import '../screens/main/profile/give_feedback/give_feedback_screen.dart';
import '../screens/main/profile/help_center/help_center_screen.dart';
import '../screens/main/profile/jobs/my_jobs/my_jobs_screen.dart';
import '../screens/main/profile/login_security/change_password/change_password_screen.dart';
import '../screens/main/profile/login_security/login_alerts/login_alerts_screen.dart';
import '../screens/main/profile/login_security/login_security_screen.dart';
import '../screens/main/profile/login_security/saved_login/saved_login_screen.dart';
import '../screens/main/profile/login_security/where_logged_in/where_logged_in_screen.dart';
import '../screens/main/profile/my_addresses/add_address/add_address_screen.dart';
import '../screens/main/profile/my_addresses/my_addresses_screen.dart';
import '../screens/main/profile/my_addresses/select_location/select_location_screen.dart';
import '../screens/main/profile/my_documents/my_documents_screen.dart';
import '../screens/main/profile/packages/add_package/add_package_screen.dart';
import '../screens/main/profile/packages/packs_screen.dart';
import '../screens/main/profile/payments_earnings/payments_earnings_screen.dart';
import '../screens/main/profile/personal_information/personal_information_screen.dart';
import '../screens/main/profile/privacy_sharing/privacy_sharing_screen.dart';
import '../screens/main/profile/services/add_service/add_service_screen.dart';
import '../screens/main/profile/services/services_screen.dart';
import '../screens/main/profile/share_app/invite_friends/invite_friends_screen.dart';
import '../screens/main/profile/share_app/share_app_screen.dart';
import '../screens/main/profile/way_of_payment/way_of_payment_screen.dart';
import '../screens/main/profile/working_days/working_days_screen.dart';
import '../screens/main/search/search_screen.dart';
import '../screens/main/service_details/service_details_screen.dart';
import '../screens/main/subcategories/subcategories_screen.dart';

List<GetPage> getPages = [
  GetPage(
    name: RouteConstant.splashScreen,
    page: () => const SplashScreen(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: RouteConstant.onboardingScreen,
    page: () => const OnboardingScreen(),
    transition: Transition.rightToLeftWithFade,
  ),

  GetPage(
    name: RouteConstant.phoneNumberScreen,
    page: () => PhoneNumberScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.termsScreen,
    page: () => TermsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.loginPasswordScreen,
    page: () => LoginPasswordScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.verificationScreen,
    page: () => VerificationScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.changePasswordScreen,
    page: () => ChangePasswordScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.resetPasswordScreen,
    page: () => ResetPasswordScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.createAccountScreen,
    page: () => CreateAccountScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.selectPortalScreen,
    page: () => SelectPortalScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.mainNavigationScreen,
    page: () => MainNavigationScreen(),
    transition: Transition.rightToLeftWithFade,
  ),

  GetPage(
    name: RouteConstant.chatScreen,
    page: () => ChatScreen(),
    transition: Transition.rightToLeftWithFade,
  ),

  // Profile screens
  GetPage(
    name: RouteConstant.personalInformationScreen,
    page: () => PersonalInformationScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.myDocumentsScreen,
    page: () => MyDocumentsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.myAddressesScreen,
    page: () => MyAddressesScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.profileNotificationsScreen,
    page: () => NotificationSettingsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.loginSecurityScreen,
    page: () => LoginSecurityScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.paymentsEarningsScreen,
    page: () => PaymentsEarningsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.privacySharingScreen,
    page: () => PrivacySharingScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.changeLanguageScreen,
    page: () => ChangeLanguageScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.wayOfPaymentScreen,
    page: () => WayOfPaymentScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.workingDaysScreen,
    page: () => WorkingDaysScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.aboutUsScreen,
    page: () => AboutUsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.helpCenterScreen,
    page: () => HelpCenterScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.giveFeedbackScreen,
    page: () => GiveFeedbackScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.servicesScreen,
    page: () => ServicesScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.addServiceScreen,
    page: () => AddServiceScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.packsScreen,
    page: () => PacksScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.addPackageScreen,
    page: () => AddPackageScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.myJobsScreen,
    page: () => MyJobsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.addJobScreen,
    page: () => AddJobScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.shareAppScreen,
    page: () => ShareAppScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.addAddressScreen,
    page: () => AddAddressScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.savedLoginScreen,
    page: () => SavedLoginScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.whereLoggedInScreen,
    page: () => WhereLoggedInScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.loginAlertsScreen,
    page: () => LoginAlertsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.inviteFriendsScreen,
    page: () => InviteFriendsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.selectLocationScreen,
    page: () => SelectLocationScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.jobDetailsScreen,
    page: () => JobDetailsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.serviceDetailsScreen,
    page: () => ServiceDetailsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.packageDetailsScreen,
    page: () => PackageDetailsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.jobApplicantsScreen,
    page: () => JobApplicantsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.employerMemberProfileScreen,
    page: () => EmployerMemberProfileScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.applyJobScreen,
    page: () => ApplyJobScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.employerRateMemberScreen,
    page: () => EmployerRateMemberScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.freelancerMemberProfileScreen,
    page: () => FreelancerMemberProfileScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.bookServiceScreen,
    page: () => BookServiceScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.searchScreen,
    page: () => SearchScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.subcategoriesScreen,
    page: () => SubcategoriesScreen(),
    preventDuplicates: false,
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.allCategoriesScreen,
    page: () => AllCategoriesScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
];
