import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/engagement/submit_engagement_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class ApplyJobController extends GetxController {
  final SubmitEngagementRepository _submitEngagementRepository =
      SubmitEngagementRepository();

  var job = Rxn<Job>();
  var isLoading = false.obs;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  var selectedDuration = Rxn<String>();
  var cvFile = Rxn<File>();
  var cvFileBase64 = Rxn<String>();
  var cvFileName = Rxn<String>();
  var cvFileSize = Rxn<int>();

  final List<String> durationOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '12',
    '16',
    '20',
    '24',
  ];

  @override
  void onInit() {
    super.onInit();

    // Get job from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Job) {
      job.value = arguments;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    budgetController.dispose();
    super.onClose();
  }

  Future<void> pickCV(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        cvFile.value = file;
        cvFileName.value = result.files.single.name;
        cvFileSize.value = result.files.single.size;

        // Convert to base64
        final bytes = await file.readAsBytes();
        cvFileBase64.value =
            "data:application/pdf;base64,${base64Encode(bytes)}";

        constants.showSnackBar(
          'CV selected successfully',
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error selecting CV: $e', SnackBarStatus.ERROR);
      print('Error picking CV: $e');
    }
  }

  void removeCv() {
    cvFile.value = null;
    cvFileBase64.value = null;
    cvFileName.value = null;
    cvFileSize.value = null;
  }

  String getFormattedFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  Future<void> submitApplication() async {
    // Validate form
    if (budgetController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter your budget', SnackBarStatus.ERROR);
      return;
    }

    if (selectedDuration.value == null) {
      constants.showSnackBar('Please select a duration', SnackBarStatus.ERROR);
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      constants.showSnackBar(
        'Please enter a description',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> data = {
        'type': 'JA',
        'job': job.value!.hashcode!,
        'unit_price': budgetController.text.trim(),
        'estimated_hours': selectedDuration.value!,
        'message_to_client': descriptionController.text.trim(),
      };

      // Add CV if provided (as base64)
      if (cvFileBase64.value != null) {
        data['freelancer_cv'] = cvFileBase64.value!;
      }

      final response = await _submitEngagementRepository.submitEngagement(data);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Application submitted successfully',
          SnackBarStatus.SUCCESS,
        );

        // Go back to previous screen
        Get.back();
      } else {
        if (response.message != null) {
          constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
        }
      }
    } catch (e) {
      constants.showSnackBar(
        'Error submitting application: $e',
        SnackBarStatus.ERROR,
      );
      print('Error submitting application: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
