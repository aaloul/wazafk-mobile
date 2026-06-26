import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:wazafak_app/components/dialog/dialog_helper.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/repository/account/delete_account_repository.dart';
import 'package:wazafak_app/repository/account/logout_repository.dart';
import 'package:wazafak_app/repository/support/last_support_conversation_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../model/SettingsModel.dart';

class ProfileController extends GetxController {
  final _logoutRepository = LogoutRepository();
  final _deleteAccountRepository = DeleteAccountRepository();
  final _lastSupportRepository = LastSupportConversationRepository();

  var isLoading = false.obs;
  // Settings groups
  List<SettingsGroup> get settingsGroups =>
      [
    SettingsGroup(
      title: Resources
          .of(Get.context!)
          .strings
          .settings,
      items: [
        // SettingsModel(
        //   title: Resources
        //       .of(Get.context!)
        //       .strings
        //       .personalInformation,
        //   icon: AppIcons.menuPersonalInfo,
        //   id: 0,
        // ),
        SettingsModel(
          title: Resources
              .of(Get.context!)
              .strings
              .calendar,
          icon: AppIcons.calendar,
          id: 16,
        ),
        SettingsModel(
          title: Resources
              .of(Get.context!)
              .strings
              .myDocuments,
          icon: AppIcons.menuDocuments,
          id: 1,
        ),
        SettingsModel(
          title: Resources
              .of(Get.context!)
              .strings
              .myAddresses,
          icon: AppIcons.menuAddresses,
          id: 2,
        ),
        SettingsModel(
          title: Resources
              .of(Get.context!)
              .strings
              .notifications,
          icon: AppIcons.menuNotifications,
          id: 3,
        ),
        SettingsModel(
          title: Resources
              .of(Get.context!)
              .strings
              .loginAndSecurity,
          icon: AppIcons.menuSecurity,
          id: 4,
        ),
        // SettingsModel(
        //   title: Resources
        //       .of(Get.context!)
        //       .strings
        //       .paymentsAndEarnings,
        //   icon: AppIcons.menuEarnings,
        //   id: 5,
        // ),
        // SettingsModel(
        //   title: Resources
        //       .of(Get.context!)
        //       .strings
        //       .privacyAndSharing,
        //   icon: AppIcons.menuPrivacy,
        //   id: 6,
        // ),
        // SettingsModel(
        //   title: Resources
        //       .of(Get.context!)
        //       .strings
        //       .changeLanguage,
        //   icon: AppIcons.menuLanguage,
        //   id: 7,
        // ),
        // SettingsModel(
        //   title: Resources
        //       .of(Get.context!)
        //       .strings
        //       .wayOfPayment,
        //   icon: AppIcons.menuPayment,
        //   id: 8,
        // ),
        // SettingsModel(
        //   title: Resources
        //       .of(Get.context!)
        //       .strings
        //       .workingDays,
        //   icon: AppIcons.menuWorkingDays,
        //   id: 9,
        // ),
      ],
    ),
    SettingsGroup(
      title: Resources
          .of(Get.context!)
          .strings
          .rewardsAndCredits,
      items: [
        SettingsModel(title: Resources
            .of(Get.context!)
            .strings
            .shareApp, icon: AppIcons.menuShare, id: 10),
        SettingsModel(title: Resources
            .of(Get.context!)
            .strings
            .voucher, icon: AppIcons.voucher, id: 30),
      ],
    ),
    SettingsGroup(
      title: Resources
          .of(Get.context!)
          .strings
          .support,
      items: [
        SettingsModel(title: Resources
            .of(Get.context!)
            .strings
            .aboutUs, icon: AppIcons.menuShare, id: 11),
        SettingsModel(title: Resources
            .of(Get.context!)
            .strings
            .helpCenter, icon: AppIcons.voucher, id: 12),
        SettingsModel(
          title: Resources
              .of(Get.context!)
              .strings
              .giveUsFeedback,
          icon: AppIcons.menuShare,
          id: 13,
        ),
      ],
    ),

        SettingsGroup(
          title: Resources
              .of(Get.context!)
              .strings
              .legal,
          items: [

            SettingsModel(
              title: Resources
                  .of(Get.context!)
                  .strings
                  .privacyAndSharing,
              icon: AppIcons.menuPrivacy,
              id: 6,
            ),

            SettingsModel(
              title: Resources
                  .of(Get.context!)
                  .strings
                  .termsOfUse,
              icon: AppIcons.voucher,
              id: 8,
            ),



          ],
        ),

    SettingsGroup(
      title: '',
      items: [
        SettingsModel(title: Resources
            .of(Get.context!)
            .strings
            .logout, icon: AppIcons.menuLogout, id: 14),
        SettingsModel(
          title: Resources
              .of(Get.context!)
              .strings
              .deleteAccount,
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
        SheetHelper.showChangeLanguageSheet(Get.context!);
        break;
      case 8: // Way of Payment
        Get.toNamed(RouteConstant.termsScreen);
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
      case 16: // My Schedule / Calendar
        Get.toNamed(RouteConstant.calendarScreen);
        break;
      case 30: // Voucher
        Get.toNamed(RouteConstant.voucherScreen);
        break;
    }
  }

  Future<void> logout() async {
    DialogHelper.showAgreementPopup(
      Get.context!,
      Resources
          .of(Get.context!)
          .strings
          .areYouSureLogout,
      Resources
          .of(Get.context!)
          .strings
          .logout,
      Resources
          .of(Get.context!)
          .strings
          .cancel,
          () async {
        try {
          isLoading.value = true;
          final response = await _logoutRepository.logout();

          if (response.success == true) {
            Prefs.clearUser();
            Get.back();
            Get.offAllNamed(RouteConstant.phoneNumberScreen);
            constants.showSnackBar(
                response.message ?? Resources
                    .of(Get.context!)
                    .strings
                    .loggedOutSuccessfully,
                SnackBarStatus.SUCCESS);
          } else {
            constants.showSnackBar(
                response.message ?? Resources
                    .of(Get.context!)
                    .strings
                    .logoutFailed,
                SnackBarStatus.ERROR);
          }
        } catch (e) {
          constants.showSnackBar(Resources
              .of(Get.context!)
              .strings
              .error(e.toString()), SnackBarStatus.ERROR);
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
      Resources
          .of(Get.context!)
          .strings
          .areYouSureDeleteAccount,
      Resources
          .of(Get.context!)
          .strings
          .delete,
      Resources
          .of(Get.context!)
          .strings
          .cancel,
          () async {
        try {
          isLoading.value = true;
          final response = await _deleteAccountRepository.deleteAccount();

          if (response.success == true) {
            Prefs.clearUser();
            Get.back();
            Get.offAllNamed(RouteConstant.phoneNumberScreen);
            constants.showSnackBar(
                response.message ?? Resources
                    .of(Get.context!)
                    .strings
                    .accountDeletedSuccessfully,
                SnackBarStatus.SUCCESS);
          } else {
            constants.showSnackBar(
                response.message ?? Resources
                    .of(Get.context!)
                    .strings
                    .failedToDeleteAccount,
                SnackBarStatus.ERROR);
          }
        } catch (e) {
          constants.showSnackBar(Resources
              .of(Get.context!)
              .strings
              .error(e.toString()), SnackBarStatus.ERROR);
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
    Get.toNamed(RouteConstant.servicesScreen);
  }

  /// Profile-tile Support entry: resume the last support conversation if one
  /// exists, otherwise drop the user into the Help Center to start a new one.
  Future<void> openSupport() async {
    try {
      isLoading.value = true;
      final response = await _lastSupportRepository.getLastSupportConversation();
      final convo = response.data;
      if (response.success == true && convo != null) {
        Get.toNamed(RouteConstant.supportChatScreen, arguments: convo);
      } else {
        Get.toNamed(RouteConstant.helpCenterScreen);
      }
    } catch (e) {
      Get.toNamed(RouteConstant.helpCenterScreen);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToPacks() {
    Get.toNamed(RouteConstant.packsScreen);
  }
  void navigateToJobs() {
    Get.toNamed(RouteConstant.myJobsScreen);
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
