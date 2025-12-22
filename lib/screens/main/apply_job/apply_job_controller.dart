import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/account/face_match_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_engagement_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class ApplyJobController extends GetxController {
  final SubmitEngagementRepository _submitEngagementRepository =
      SubmitEngagementRepository();
  final FaceMatchRepository _faceMatchRepository = FaceMatchRepository();

  var job = Rxn<Job>();
  var isLoading = false.obs;

  // Face match fields
  var faceMatchImage = Rxn<XFile>();
  var isVerifyingFaceMatch = false.obs;
  CameraController? cameraController;
  var isCameraInitialized = false.obs;
  var isCameraInitializing = false.obs;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  var cvFile = Rxn<File>();
  var cvFileBase64 = Rxn<String>();
  var cvFileName = Rxn<String>();
  var cvFileSize = Rxn<int>();
  var cvFileExtension = Rxn<String>();


  @override
  void onInit() {
    super.onInit();

    // Get job from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Job) {
      job.value = arguments;
    }
  }

  Future<void> initializeCamera() async {
    try {
      isCameraInitializing.value = true;

      // Get available cameras
      final cameras = await availableCameras();

      // Find front camera
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Initialize camera controller
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      constants.showSnackBar(
        'Error initializing camera: $e',
        SnackBarStatus.ERROR,
      );
      print('Error initializing camera: $e');
    } finally {
      isCameraInitializing.value = false;
    }
  }

  Future<void> takePictureFromCamera() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      constants.showSnackBar(
        'Camera not initialized',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      final image = await cameraController!.takePicture();
      faceMatchImage.value = image;
      constants.showSnackBar(
        'Image captured successfully',
        SnackBarStatus.SUCCESS,
      );
    } catch (e) {
      constants.showSnackBar(
        'Error capturing image: $e',
        SnackBarStatus.ERROR,
      );
      print('Error taking picture: $e');
    }
  }

  void disposeCamera() {
    cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
  }

  void retakePicture() {
    faceMatchImage.value = null;
  }

  Future<void> verifyFaceMatchAndSubmit() async {
    if (faceMatchImage.value == null) {
      constants.showSnackBar(
        'Please capture an image first',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isVerifyingFaceMatch.value = true;

      // Get the file from XFile
      final imageFile = File(faceMatchImage.value!.path);

      // Call face match API with the file
      final response = await _faceMatchRepository.faceMatch(imageFile);

      if (response.success == true) {
        constants.showSnackBar(
          'Face verified successfully',
          SnackBarStatus.SUCCESS,
        );

        // Close the bottom sheet
        if (Get.isBottomSheetOpen == true) {
          Get.back();
        }

        // Submit the application
        await submitApplication();

        // Clear the face match image
        faceMatchImage.value = null;
      } else {
        constants.showSnackBar(
          response.message ?? 'Face verification failed',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error verifying face match: $e');
      constants.showSnackBar(
        'Error verifying face match',
        SnackBarStatus.ERROR,
      );
    } finally {
      isVerifyingFaceMatch.value = false;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    budgetController.dispose();
    disposeCamera();
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
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorSelectingCv(e.toString()),
        SnackBarStatus.ERROR,
      );
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
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .pleaseEnterYourBudget,
        SnackBarStatus.ERROR,
      );
      return;
    }



    if (descriptionController.text.trim().isEmpty) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .enterYourMessage,
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> data = {
        'type': 'JA',
        'job': job.value!.hashcode!,
        'unit_price': null,
        'total_price': budgetController.text,
        'estimated_hours': '',
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
