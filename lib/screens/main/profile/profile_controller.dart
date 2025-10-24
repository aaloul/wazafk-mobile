import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:wazafak_app/components/dialog/dialog_helper.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/repository/account/delete_account_repository.dart';
import 'package:wazafak_app/repository/account/logout_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../model/SettingsModel.dart';

class ProfileController extends GetxController {
  final _logoutRepository = LogoutRepository();
  final _deleteAccountRepository = DeleteAccountRepository();

  var isLoading = false.obs;
  // Settings groups
  final List<SettingsGroup> settingsGroups = [
    SettingsGroup(
      title: 'Settings',
      items: [
        SettingsModel(
          title: 'Personal Information',
          icon: AppIcons.menuPersonalInfo,
          id: 0,
        ),
        SettingsModel(
          title: 'My Documents',
          icon: AppIcons.menuDocuments,
          id: 1,
        ),
        SettingsModel(
          title: 'My Addresses',
          icon: AppIcons.menuAddresses,
          id: 2,
        ),
        SettingsModel(
          title: 'Notifications',
          icon: AppIcons.menuNotifications,
          id: 3,
        ),
        SettingsModel(
          title: 'Login & Security',
          icon: AppIcons.menuSecurity,
          id: 4,
        ),
        SettingsModel(
          title: 'Payments & Earnings',
          icon: AppIcons.menuEarnings,
          id: 5,
        ),
        SettingsModel(
          title: 'Privacy & Sharing',
          icon: AppIcons.menuPrivacy,
          id: 6,
        ),
        SettingsModel(
          title: 'Change Language',
          icon: AppIcons.menuLanguage,
          id: 7,
        ),
        SettingsModel(
          title: 'Way of Payment',
          icon: AppIcons.menuPayment,
          id: 8,
        ),
        SettingsModel(
          title: 'Working Days',
          icon: AppIcons.menuWorkingDays,
          id: 9,
        ),
      ],
    ),
    SettingsGroup(
      title: 'Rewards & Credits',
      items: [
        SettingsModel(title: 'Share App', icon: AppIcons.menuShare, id: 10),
      ],
    ),
    SettingsGroup(
      title: 'Support',
      items: [
        SettingsModel(title: 'About Us', icon: AppIcons.menuAbout, id: 11),
        SettingsModel(title: 'Help Center', icon: AppIcons.menuHelp, id: 12),
        SettingsModel(
          title: 'Give Us Feedback',
          icon: AppIcons.menuFeedback,
          id: 13,
        ),
      ],
    ),
    SettingsGroup(
      title: '',
      items: [
        SettingsModel(title: 'Logout', icon: AppIcons.menuLogout, id: 14),
        SettingsModel(
          title: 'Delete Account',
          icon: AppIcons.menuDelete,
          id: 15,
        ),
      ],
    ),
  ];

  void handleSettingsItemClick(int id) {
    switch (id) {
      case 0: // Personal Information
        Get.toNamed(RouteConstant.personalInformationScreen);
        break;
      case 1: // My Documents
        Get.toNamed(RouteConstant.myDocumentsScreen);
        break;
      case 2: // My Addresses
        Get.toNamed(RouteConstant.myAddressesScreen);
        break;
      case 3: // Notifications
        Get.toNamed(RouteConstant.profileNotificationsScreen);
        break;
      case 4: // Login & Security
        Get.toNamed(RouteConstant.loginSecurityScreen);
        break;
      case 5: // Payments & Earnings
        Get.toNamed(RouteConstant.paymentsEarningsScreen);
        break;
      case 6: // Privacy & Sharing
        Get.toNamed(RouteConstant.privacySharingScreen);
        break;
      case 7: // Change Language
        Get.toNamed(RouteConstant.changeLanguageScreen);
        break;
      case 8: // Way of Payment
        Get.toNamed(RouteConstant.wayOfPaymentScreen);
        break;
      case 9: // Working Days
        Get.toNamed(RouteConstant.workingDaysScreen);
        break;
      case 10: // Share App
        Get.toNamed(RouteConstant.shareAppScreen);
        break;
      case 11: // About Us
        Get.toNamed(RouteConstant.aboutUsScreen);
        break;
      case 12: // Help Center
        Get.toNamed(RouteConstant.helpCenterScreen);
        break;
      case 13: // Give Us Feedback
        Get.toNamed(RouteConstant.giveFeedbackScreen);
        break;
      case 14: // Logout
        logout();
        break;
      case 15: // Delete Account
        deleteAccount();
        break;
    }
  }

  Future<void> logout() async {
    DialogHelper.showAgreementPopup(
      Get.context!,
      'Are you sure you want to logout?',
      'Logout',
      'Cancel',
          () async {
        try {
          isLoading.value = true;
          final response = await _logoutRepository.logout();

          if (response.success == true) {
            Prefs.clearUser();
            Get.back();
            Get.offAllNamed(RouteConstant.phoneNumberScreen);
            constants.showSnackBar(
                response.message ?? 'Logged out successfully',
                SnackBarStatus.SUCCESS);
          } else {
            constants.showSnackBar(
                response.message ?? 'Logout failed', SnackBarStatus.ERROR);
          }
        } catch (e) {
          constants.showSnackBar('Error: $e', SnackBarStatus.ERROR);
        } finally {
          isLoading.value = false;
        }
      },
      isLoading,
    );
  }

  Future<void> deleteAccount() async {
    DialogHelper.showAgreementPopup(
      Get.context!,
      'Are you sure you want to delete your account? This action cannot be undone.',
      'Delete',
      'Cancel',
          () async {
        try {
          isLoading.value = true;
          final response = await _deleteAccountRepository.deleteAccount();

          if (response.success == true) {
            Prefs.clearUser();
            Get.back();
            Get.offAllNamed(RouteConstant.phoneNumberScreen);
            constants.showSnackBar(
                response.message ?? 'Account deleted successfully',
                SnackBarStatus.SUCCESS);
          } else {
            constants.showSnackBar(
                response.message ?? 'Failed to delete account',
                SnackBarStatus.ERROR);
          }
        } catch (e) {
          constants.showSnackBar('Error: $e', SnackBarStatus.ERROR);
        } finally {
          isLoading.value = false;
        }
      },
      isLoading,
    );
  }

  void shareApp() {
    // Share.share('Check out Wazafak app!');
  }

  void navigateToServices() {
    Get.toNamed(RouteConstant.addJobScreen);
  }

  void navigateToPacks() {
    Get.toNamed(RouteConstant.packsScreen);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
