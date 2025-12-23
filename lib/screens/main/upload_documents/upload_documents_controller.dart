import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/repository/member/save_document_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../home/home_controller.dart';

class UploadDocumentsController extends GetxController {
  final SaveDocumentRepository _saveDocumentRepository =
      SaveDocumentRepository();

  final Rxn<XFile> frontIdImage = Rxn<XFile>();
  final Rxn<XFile> backIdImage = Rxn<XFile>();
  final Rxn<XFile> passportImage = Rxn<XFile>();

  final selectedTab = 'personal_id'.obs;
  final isLoading = false.obs;

  Future<void> pickImageFromCamera(BuildContext context, String type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        switch (type) {
          case 'front_id':
            frontIdImage.value = image;
            break;
          case 'back_id':
            backIdImage.value = image;
            break;
          case 'passport':
            passportImage.value = image;
            break;
        }
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .imageCapturedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorCapturingImage(e.toString()), SnackBarStatus.ERROR);
      print('Error picking image: $e');
    }
  }

  Future<void> uploadDocuments() async {
    // Validate based on selected tab
    if (selectedTab.value == 'passport') {
      if (passportImage.value == null) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .pleaseUploadPassportImage,
          SnackBarStatus.ERROR,
        );
        return;
      }
    } else {
      if (frontIdImage.value == null || backIdImage.value == null) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .pleaseUploadBothFrontAndBackIdImages,
          SnackBarStatus.ERROR,
        );
        return;
      }
    }

    try {
      isLoading.value = true;

      String documentType = selectedTab.value == 'passport' ? 'PP' : 'ID';

      // Convert XFiles to Files
      File? frontIdFile;
      File? backIdFile;
      File? passportFile;

      if (selectedTab.value == 'passport') {
        if (passportImage.value != null) {
          passportFile = File(passportImage.value!.path);
        }
      } else {
        if (frontIdImage.value != null) {
          frontIdFile = File(frontIdImage.value!.path);
        }
        if (backIdImage.value != null) {
          backIdFile = File(backIdImage.value!.path);
        }
      }

      final response = await _saveDocumentRepository.saveDocument(
        documentType: documentType,
        frontId: frontIdFile,
        backId: backIdFile,
        passport: passportFile,
      );

      if (response.success == true) {
        final controller = Get.find<HomeController>();
        controller.fetchProfile();

        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .documentsUploadedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
        // Go back to previous screen
        Get.back();
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToUploadDocuments,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorUploadingDocuments(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error uploading documents: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
