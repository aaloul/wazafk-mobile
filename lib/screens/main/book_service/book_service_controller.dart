import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/account/face_match_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_engagement_repository.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class BookServiceController extends GetxController {
  final _addressesRepository = AddressesRepository();
  final _submitEngagementRepository = SubmitEngagementRepository();
  final _faceMatchRepository = FaceMatchRepository();

  var service = Rx<Service?>(null);
  var package = Rx<Package?>(null);
  var isPackage = false.obs;

  // Face match fields
  var faceMatchImage = Rxn<XFile>();
  var isVerifyingFaceMatch = false.obs;
  CameraController? cameraController;
  var isCameraInitialized = false.obs;
  var isCameraInitializing = false.obs;
  var rangeStart = Rx<DateTime?>(null);
  var rangeEnd = Rx<DateTime?>(null);
  var focusedDay = DateTime.now().obs;
  var rangeSelectionMode = RangeSelectionMode.toggledOn.obs;
  var selectedServiceType = Rxn<String>();
  var selectedAddress = Rxn<Address>();
  var addresses = <Address>[].obs;
  var isLoadingAddresses = false.obs;
  var isLoading = false.obs;
  final notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Get service or package from arguments
    if (Get.arguments != null) {
      if (Get.arguments is Service) {
        service.value = Get.arguments as Service;
        isPackage.value = false;
      } else if (Get.arguments is Package) {
        package.value = Get.arguments as Package;
        isPackage.value = true;
      }
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focused) {
    if (!isSameDay(rangeStart.value, selectedDay)) {
      focusedDay.value = focused;
      rangeStart.value = selectedDay;
      rangeEnd.value = null;
    }
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focused) {
    focusedDay.value = focused;
    rangeStart.value = start;
    rangeEnd.value = end;
  }

  String formatDateRange() {
    if (rangeStart.value == null) return 'No dates selected';

    final startStr = DateFormat('MMM dd, yyyy').format(rangeStart.value!);

    if (rangeEnd.value == null) {
      return startStr;
    }

    final endStr = DateFormat('MMM dd, yyyy').format(rangeEnd.value!);
    return '$startStr - $endStr';
  }

  int getTotalDays() {
    if (rangeStart.value == null) return 0;
    if (rangeEnd.value == null) return 1;

    return rangeEnd.value!.difference(rangeStart.value!).inDays + 1;
  }

  void selectServiceType(String serviceType) {
    selectedServiceType.value = serviceType;
  }

  void selectAddress(Address address) {
    selectedAddress.value = address;
  }

  Future<void> fetchAddresses() async {
    try {
      isLoadingAddresses.value = true;
      final response = await _addressesRepository.getAddresses();

      if (response.success == true && response.data != null) {
        addresses.value = response.data!;
      } else {
        constants.showSnackBar(
          response.message ?? 'Error fetching addresses',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorFetchingAddresses(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error fetching addresses: $e');
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  Future<void> bookService() async {
    if (service.value == null && package.value == null) {
      constants.showSnackBar(
        'Service/Package information not available',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (rangeStart.value == null) {
      constants.showSnackBar(
        'Please select a date range',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (selectedServiceType.value == null) {
      constants.showSnackBar(
        'Please select a service type',
        SnackBarStatus.ERROR,
      );
      return;
    }

    // Validate address only for Onsite service type
    if ((selectedServiceType.value == 'Onsite' ||
            selectedServiceType.value == 'Hybrid') &&
        selectedAddress.value == null) {
      constants.showSnackBar('Please select a location', SnackBarStatus.ERROR);
      return;
    }

    try {
      isLoading.value = true;

      // Format start date
      final startDateStr = DateFormat('yyyy-MM-dd').format(rangeStart.value!);

      final price = isPackage.value
          ? package.value!.totalPrice.toString()
          : service.value!.unitPrice.toString();

      // Format end date if available
      String? endDateStr;
      if (rangeEnd.value != null) {
        endDateStr = DateFormat('yyyy-MM-dd').format(rangeEnd.value!);
      }

      // Map work location type to API codes
      String workLocationType = '';
      switch (selectedServiceType.value) {
        case 'Remote':
          workLocationType = 'RMT';
          break;
        case 'Hybrid':
          workLocationType = 'HYB';
          break;
        case 'Onsite':
          workLocationType = 'SIT';
          break;
      }

      Map<String, dynamic> data = {
        'type': isPackage.value ? 'PB' : 'SB',
        'start_datetime': startDateStr,
        'unit_price': price,
        'total_price': price,
        'work_location_type': workLocationType,
        'message_to_freelancer': notesController.text,
        'description': "",
        'tasks_milestones': "",
      };

      // Add service or package hashcode
      if (isPackage.value) {
        data['package'] = package.value!.hashcode!;
      } else {
        data['services'] = [service.value!.hashcode!];
      }

      // Add end date if available
      if (endDateStr != null) {
        data['expiry_datetime'] = endDateStr;
      } else {
        data['start_datetime'] = startDateStr;
      }

      // Add address only for Onsite service type
      if ((selectedServiceType.value == 'Onsite' ||
              selectedServiceType.value == 'Hybrid') &&
          selectedAddress.value != null) {
        data['address'] = selectedAddress.value!.hashcode;
      } else {
        data['address'] = '';
      }

      final response = await _submitEngagementRepository.submitEngagement(data);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Service booked successfully!',
          SnackBarStatus.SUCCESS,
        );

        // Navigate back to previous screen
        Get.back();
      } else {
        constants.showSnackBar(
          response.message ?? 'Error booking service',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorBookingService(e.toString()), SnackBarStatus.ERROR);
      print('Error booking service: $e');
    } finally {
      isLoading.value = false;
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
        Resources
            .of(Get.context!)
            .strings
            .errorInitializingCamera(e.toString()),
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
        Resources
            .of(Get.context!)
            .strings
            .errorCapturingImage(e.toString()),
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

  Future<void> verifyFaceMatchAndBook() async {
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

        // Book the service
        await bookService();

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
    notesController.dispose();
    disposeCamera();
    super.onClose();
  }
}
