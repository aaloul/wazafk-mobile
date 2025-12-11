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
  var cvFileExtension = Rxn<String>();

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
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        cvFile.value = file;
        cvFileName.value = result.files.single.name;
        cvFileSize.value = result.files.single.size;
        cvFileExtension.value = result.files.single.extension?.toLowerCase();

        // Convert file to base64 with appropriate MIME type
        final bytes = await file.readAsBytes();
        final mimeType = _getMimeType(cvFileExtension.value);
        cvFileBase64.value = "data:$mimeType;base64,${base64Encode(bytes)}";

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
    cvFileExtension.value = null;
  }

  String _getMimeType(String? extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  IconData getFileIcon() {
    switch (cvFileExtension.value) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
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
        'unit_price': budgetController.text,
        'total_price': budgetController.text,
        'estimated_hours': selectedDuration.value!,
        'message_to_client': descriptionController.text,
        'work_location_type': job.value!.workLocationType.toString(),
        'address': "",
        'tasks_milestones': "",
        'description': "",
        'start_datetime': "",
        'expiry_datetime': "",
        'package': "",
        'services': [],
      };

      // Include CV as base64 if available
      if (cvFileBase64.value != null) {
        data['freelancer_cv'] = cvFileBase64.value!;
      } else {
        data['freelancer_cv'] = "";
      }

      final response = await _submitEngagementRepository.submitEngagement(data);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Application submitted successfully',
          SnackBarStatus.SUCCESS,
        );

        // Go back to previous screen
        Get.back();
        Get.back();
      } else {
        if (response.message != null) {
          constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
        }
      }

      print(cvFileBase64.value);
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
