import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/components/sheets/image_source_bottom_sheet.dart';
import 'package:wazafak_app/networking/services/member/profile_service.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

class PersonalInformationController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final titleController = TextEditingController();
  final emailController = TextEditingController();
  final portfolioLinkController = TextEditingController();
  final aboutController = TextEditingController();

  var selectedGender = ''.obs;
  var selectedDate = Rxn<DateTime>();
  var profileImage = Rxn<XFile>();
  var isLoading = false.obs;

  final genders = ['Male', 'Female'];
  final ProfileService _profileService = ProfileService();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    firstNameController.text = Prefs.getFName;
    lastNameController.text = Prefs.getLName;
    emailController.text = Prefs.getEmail;
    portfolioLinkController.text = Prefs.getWebsite;
    aboutController.text = Prefs.getInfo;
    titleController.text = Prefs.getProfileTitle;

    // Auto-fill gender with proper capitalization
    if (Prefs.getGender.isNotEmpty) {
      String gender = Prefs.getGender.toLowerCase();
      if (gender == 'male' || gender == 'm' || gender == 'M') {
        selectedGender.value = genders.first;
      } else if (gender == 'female' || gender == 'f' || gender == 'F') {
        selectedGender.value = genders[1];
      } else {
        selectedGender.value = Prefs.getGender;
      }
    }

    if (Prefs.getDob.isNotEmpty) {
      try {
        selectedDate.value = DateTime.parse(Prefs.getDob);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
  }

  Future<void> showImageSourceDialog(BuildContext context) async {
    final XFile? image = await ImageSourceBottomSheet.show(context);
    if (image != null) {
      profileImage.value = image;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      // Prepare data
      Map<String, dynamic> data = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'gender': selectedGender.value.substring(0, 1),
        'website': portfolioLinkController.text,
        'info': aboutController.text,
        'title': titleController.text,
      };

      if (selectedDate.value != null) {
        data['date_of_birth'] = selectedDate.value!.toIso8601String();
      }

      // Update profile
      final response = await _profileService.editProfile(data);

      if (response.success == true) {
        Prefs.saveUser(response.data!);

        // Update profile image if changed
        if (profileImage.value != null) {
          await updateProfileImage();
        }

        constants.showSnackBar(
          response.message ?? 'Profile updated successfully',
          SnackBarStatus.SUCCESS,
        );

        Get.back();
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to update profile',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating profile: $e',
        SnackBarStatus.ERROR,
      );
      print('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage() async {
    try {
      if (profileImage.value == null) return;

      final response = await _profileService.editProfileImage(
          profileImage.value!.path);

      if (response.success == true) {
        // Update local storage if response contains new image URL
        Prefs.saveUser(response.data!);
      }
    } catch (e) {
      print('Error updating profile image: $e');
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    portfolioLinkController.dispose();
    aboutController.dispose();
    titleController.dispose();
    super.onClose();
  }
}
