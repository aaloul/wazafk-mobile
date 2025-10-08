import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/networking/services/member/profile_service.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

class PersonalInformationController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
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

    // Auto-fill gender with proper capitalization
    if (Prefs.getGender.isNotEmpty) {
      String gender = Prefs.getGender.toLowerCase();
      if (gender == 'male' || gender == 'm') {
        selectedGender.value = 'Male';
      } else if (gender == 'female' || gender == 'f') {
        selectedGender.value = 'Female';
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

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = image;
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      profileImage.value = image;
    }
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
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
    super.onClose();
  }
}
