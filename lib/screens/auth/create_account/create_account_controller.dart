import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/sheets/image_source_bottom_sheet.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/InterestOptionsResponse.dart';
import 'package:wazafak_app/repository/account/register_repository.dart';
import 'package:wazafak_app/repository/app/interest_options_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';

import '../../../utils/utils.dart';

class CreateAccountController extends GetxController {
  final InterestOptionsRepository _interestOptionsRepository =
      InterestOptionsRepository();
  final RegisterRepository _registerRepository = RegisterRepository();

  var index = 0.obs;
  List<String> genders = ["Male", "Female"];

  var selectedGender = "".obs;
  var selectedTab = "personal_id".obs;

  var isInterestOptionsLoading = false.obs;
  var isRegistering = false.obs;
  final selectedDate = Rxn<DateTime?>();

  RxList<InterestOption> interests = <InterestOption>[].obs;

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final titleController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Image picker
  final ImagePicker _picker = ImagePicker();

  // Identity images
  final Rxn<XFile> frontIdImage = Rxn<XFile>();
  final Rxn<XFile> backIdImage = Rxn<XFile>();
  final Rxn<XFile> passportImage = Rxn<XFile>();

  // Profile image
  final Rxn<XFile> profileImage = Rxn<XFile>();

  Future<void> getInterestOptions() async {
    isInterestOptionsLoading(true);
    try {
      final response = await _interestOptionsRepository.getInterestOptions();
      if (response.success ?? false) {
        interests.value = response.data ?? [];
      }
      isInterestOptionsLoading(false);
    } catch (e) {
      isInterestOptionsLoading(false);

      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  String mobile = '';

  @override
  Future<void> onInit() async {
    super.onInit();
    mobile = Get.arguments["mobile"];
    getInterestOptions();
    selectedGender.value = genders.first;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    titleController.dispose();
  }

  Future<String?> convertImageToBase64(XFile image) async {
    try {
      final bytes = await File(image.path).readAsBytes();
      return "data:image/jpeg;base64,${base64Encode(bytes)}";
    } catch (e) {
      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
      return null;
    }
  }

  Future<void> pickImageFromCamera(BuildContext context, String type) async {
    try {
      final XFile? image = await ImageSourceBottomSheet.show(context);

      if (image != null) {
        if (type == 'front_id') {
          frontIdImage.value = image;
        } else if (type == 'back_id') {
          backIdImage.value = image;
        } else if (type == 'passport') {
          passportImage.value = image;
        }
      }
    } catch (e) {
      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  Future<void> showImageSourceDialog(BuildContext context) async {
    try {
      final XFile? image = await ImageSourceBottomSheet.show(context);

      if (image != null) {
        profileImage.value = image;
      }
    } catch (e) {
      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  Future<void> register() async {
    isRegistering(true);
    try {
      // Get selected interests
      List<String> selectedInterests = interests
          .where((interest) => interest.selected.value)
          .map((interest) => interest.hashcode.toString())
          .toList();

      // Format date
      String? formattedDate;
      if (selectedDate.value != null) {
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
      }

      // Prepare registration data
      Map<String, dynamic> data = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'title': titleController.text,
        'mobile': mobile,
        'document_type': selectedTab.value == "passport" ? "PP" : "ID",
        'email': emailController.text,
        'password': passwordController.text,
        'gender': selectedGender.value == "Male" ? "M" : "F",
        'date_of_birth': formattedDate,
        'interests': selectedInterests,
      };

      // Add profile image as base64 if available
      if (profileImage.value != null) {
        final base64Image = await convertImageToBase64(profileImage.value!);
        if (base64Image != null) {
          data['image'] = base64Image;
        }
      }


      // Add identity images as base64 if available
      if (selectedTab.value == 'personal_id') {
        if (frontIdImage.value != null) {
          final base64Image = await convertImageToBase64(frontIdImage.value!);
          if (base64Image != null) {
            data['document_1'] = base64Image;
          }
        }
        if (backIdImage.value != null) {
          final base64Image = await convertImageToBase64(backIdImage.value!);
          if (base64Image != null) {
            data['document_2'] = base64Image;
          }
        }


      } else if (selectedTab.value == 'passport') {
        if (passportImage.value != null) {
          final base64Image = await convertImageToBase64(passportImage.value!);
          if (base64Image != null) {
            data['document_passport'] = base64Image;
          }
        }
      }

      data['document_foreign_legal_1'] = "";
      data['document_foreign_legal_2'] = "";
      data['document_foreign_paperwork'] = "";


      final response = await _registerRepository.register(data);

      if (response.success ?? false) {
        Prefs.saveUser(response.data!);
        Prefs.setToken(response.data!.token.toString());
        constants.showSnackBar(
          response.message ?? 'Registration successful',
          SnackBarStatus.SUCCESS,
        );
        Get.toNamed(RouteConstant.selectPortalScreen);
      } else {
        constants.showSnackBar(
          response.message ?? 'Registration failed',
          SnackBarStatus.ERROR,
        );
      }
      isRegistering(false);
    } catch (e) {
      isRegistering(false);
      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  void verifyStep1() {
    // Validate step 1 fields
    if (firstNameController.text.isEmpty) {
      constants.showSnackBar('First name is required', SnackBarStatus.ERROR);
      return;
    }
    if (lastNameController.text.isEmpty) {
      constants.showSnackBar('Last name is required', SnackBarStatus.ERROR);
      return;
    }
    if (titleController.text.isEmpty) {
      constants.showSnackBar('Title is required', SnackBarStatus.ERROR);
      return;
    }
    if (emailController.text.isEmpty) {
      constants.showSnackBar('Email is required', SnackBarStatus.ERROR);
      return;
    }
    if (passwordController.text.isEmpty) {
      constants.showSnackBar('Password is required', SnackBarStatus.ERROR);
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      constants.showSnackBar(
          'Confirm password is required', SnackBarStatus.ERROR);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      constants.showSnackBar('Passwords do not match', SnackBarStatus.ERROR);
      return;
    }

    index.value = 1;
  }

  void verifyStep2() {
    index.value = 2;
  }

  void verifyStep3() {
    register();
  }
}
