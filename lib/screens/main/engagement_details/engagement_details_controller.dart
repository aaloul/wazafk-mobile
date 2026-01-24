import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/account/face_match_repository.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_engagement_change_request_repository.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_engagement_repository.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_finish_engagement_repository.dart';
import 'package:wazafak_app/repository/engagement/finish_engagement_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_dispute_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_engagement_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../components/dialog/dialog_helper.dart';
import '../../../constants/route_constant.dart';
import '../../../repository/engagement/engagement_detail_repository.dart';
import '../../../repository/engagement/submit_engagement_change_request_repository.dart';
import '../../../utils/Prefs.dart';
import '../../../utils/res/AppContextExtension.dart';
import 'components/finish_engagement_bottom_sheet.dart';

class EngagementDetailsController extends GetxController {
  final _engagementDetailRepository = EngagementDetailRepository();
  final _acceptRejectRepository = AcceptRejectEngagementRepository();
  final _acceptRejectChangeRequestRepository =
      AcceptRejectEngagementChangeRequestRepository();
  final _submitEngagementRepository = SubmitEngagementRepository();
  final _submitDisputeRepository = SubmitDisputeRepository();
  final _submitEngagementChangeRequestRepository =
      SubmitEngagementChangeRequestRepository();
  final _finishEngagementRepository = FinishEngagementRepository();
  final _acceptRejectFinishEngagementRepository =
      AcceptRejectFinishEngagementRepository();
  final _faceMatchRepository = FaceMatchRepository();

  final Rx<Engagement?> engagement = Rx<Engagement?>(null);
  final Rx<Service?> service = Rx<Service?>(null);
  final Rx<Package?> package = Rx<Package?>(null);
  final Rx<Job?> job = Rx<Job?>(null);
  final RxBool isPackage = false.obs;
  final RxBool isService = false.obs;
  final RxBool isJob = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAccepting = false.obs;
  final RxBool isRejecting = false.obs;
  final RxBool isNegotiating = false.obs;
  final RxBool isSubmittingDispute = false.obs;
  final RxBool isAcceptingChangeRequest = false.obs;
  final RxBool isRejectingChangeRequest = false.obs;
  final RxBool isFinishingEngagement = false.obs;
  final RxBool isAcceptingFinishEngagement = false.obs;
  final RxBool isRejectingFinishEngagement = false.obs;

  // Negotiation fields
  final TextEditingController negotiationPriceController =
      TextEditingController();
  final TextEditingController negotiationHoursController =
      TextEditingController();
  final TextEditingController negotiationMessageController =
      TextEditingController();
  var negotiationRangeStart = Rx<DateTime?>(null);
  var negotiationRangeEnd = Rx<DateTime?>(null);
  var negotiationFocusedDay = DateTime.now().obs;
  var negotiationRangeSelectionMode = RangeSelectionMode.toggledOn.obs;

  // Dispute fields
  final TextEditingController disputeReasonController = TextEditingController();

  // Deliverable file fields
  var deliverableFile = Rxn<File>();
  var deliverableFileName = Rxn<String>();
  var deliverableFileSize = Rxn<int>();
  var deliverableFileExtension = Rxn<String>();

  // Face match fields
  var faceMatchImage = Rxn<XFile>();
  var isVerifyingFaceMatch = false.obs;
  CameraController? cameraController;
  var isCameraInitialized = false.obs;
  var isCameraInitializing = false.obs;

  // Track the action after successful face verification
  String? faceVerificationAction; // 'accept_finish', 'open_finish_sheet', 'accept_engagement', 'reject_engagement'

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;

    isLoading.value = true;

    if (arg is Engagement) {
      engagement.value = arg;

      // Set service, package, or job based on engagement type
      if (arg.type.toString() == 'SB' &&
          arg.services != null &&
          arg.services!.isNotEmpty) {
        service.value = arg.services!.first;
        isService.value = true;
        isPackage.value = false;
        isJob.value = false;
      } else if (arg.type.toString() == 'PB' && arg.package != null) {
        package.value = arg.package;
        isPackage.value = true;
        isJob.value = false;
        isService.value = false;
      } else if (arg.type.toString() == 'JA' && arg.job != null) {
        job.value = arg.job;
        isPackage.value = false;
        isService.value = false;
        isJob.value = true;
      }

      if (arg.hashcode != null) {
        getEngagementDetails(arg.hashcode!);
      }
    } else if (arg is String) {
      getEngagementDetails(arg);
    }
  }

  Future<void> getEngagementDetails(String hashcode) async {
    try {
      final response = await _engagementDetailRepository.getEngagement(
        hashcode,
      );

      if (response.success == true && response.data != null) {
        // Parse the engagement from response
        final Engagement? engagementData = response.data?.list?.first;
        if (engagementData != null) {
          engagement.value = engagementData;

          // Update service, package, or job based on engagement type
          if (engagement.value?.type == 'SB' &&
              engagement.value?.services != null &&
              engagement.value!.services!.isNotEmpty) {
            service.value = engagement.value!.services!.first;
            isService.value = true;
            isPackage.value = false;
            isJob.value = false;
          } else if (engagement.value?.type == 'PB' &&
              engagement.value?.package != null) {
            package.value = engagement.value!.package;
            isPackage.value = true;
            isJob.value = false;
            isService.value = false;
          } else if (engagement.value?.type == 'JA' &&
              engagement.value?.job != null) {
            job.value = engagement.value!.job;
            isPackage.value = false;
            isService.value = false;
            isJob.value = true;
          }
        }
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadTaskDetails,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error fetching Task details: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorLoadingTaskDetails,
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoading.value = false;
  }
  }

  Future<void> acceptEngagement() async {
    if (engagement.value?.hashcode == null) return;

    try {
      isAccepting.value = true;

      final response = await _acceptRejectRepository.acceptRejectEngagement(
        hashcode: engagement.value!.hashcode!,
        accept: true,
      );

      if (response.success == true) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .taskAcceptedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // // Go back to previous screen
        // Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToAcceptTask,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error accepting Task: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorAcceptingTask,
        SnackBarStatus.ERROR,
      );
    } finally {
      isAccepting.value = false;
    }
  }

  Future<void> rejectEngagement() async {
    if (engagement.value?.hashcode == null) return;

    try {
      isRejecting.value = true;

      final response = await _acceptRejectRepository.acceptRejectEngagement(
        hashcode: engagement.value!.hashcode!,
        accept: false,
      );

      if (response.success == true) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .taskRejectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Go back to previous screen
        Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToRejectTask,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error rejecting Task: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorRejectingTask,
        SnackBarStatus.ERROR,
      );
    } finally {
      isRejecting.value = false;
    }
  }

  void onNegotiationDaySelected(DateTime selectedDay, DateTime focused) {
    if (!isSameDay(negotiationRangeStart.value, selectedDay)) {
      negotiationFocusedDay.value = focused;
      negotiationRangeStart.value = selectedDay;
      negotiationRangeEnd.value = null;
    }
  }

  void onNegotiationRangeSelected(DateTime? start,
      DateTime? end,
      DateTime focused,) {
    negotiationFocusedDay.value = focused;
    negotiationRangeStart.value = start;
    negotiationRangeEnd.value = end;
  }

  String formatNegotiationDateRange() {
    if (negotiationRangeStart.value == null) return 'No dates selected';

    final startStr = DateFormat(
      'MMM dd, yyyy',
    ).format(negotiationRangeStart.value!);

    if (negotiationRangeEnd.value == null) {
      return startStr;
    }

    final endStr = DateFormat(
      'MMM dd, yyyy',
    ).format(negotiationRangeEnd.value!);
    return '$startStr - $endStr';
  }

  int getNegotiationTotalDays() {
    if (negotiationRangeStart.value == null) return 0;
    if (negotiationRangeEnd.value == null) return 1;

    return negotiationRangeEnd.value!
        .difference(negotiationRangeStart.value!)
        .inDays +
        1;
  }

  String getPriceLabel() {
    if (isPackage.value || isJob.value) {
      return Resources.of(Get.context!).strings.totalPrice;
    } else if (isService.value) {
      if (service.value?.pricingType == 'U') {
        return Resources.of(Get.context!).strings.hourlyRate;
      } else {
        return Resources.of(Get.context!).strings.totalPrice;
      }
    }
    return Resources.of(Get.context!).strings.price;
  }

  Future<void> submitNegotiation() async {
    // Validate fields
    if (negotiationPriceController.text
        .trim()
        .isEmpty && negotiationHoursController.text
        .trim()
        .isEmpty && negotiationRangeStart.value == null &&
        negotiationMessageController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseMakeChange, SnackBarStatus.ERROR);
      return;
    }


    try {
      isNegotiating.value = true;

      final startDateStr = DateFormat(
        'yyyy-MM-dd',
      ).format(negotiationRangeStart.value!);

      String? endDateStr;
      if (negotiationRangeEnd.value != null) {
        endDateStr = DateFormat(
          'yyyy-MM-dd',
        ).format(negotiationRangeEnd.value!);
      }

      Map<String, dynamic> data = {};

      // Handle price based on type
      if (negotiationPriceController.text.trim().isNotEmpty) {
        if (isPackage.value || isJob.value) {
          // For package or job, send total_price
          data['total_price'] = negotiationPriceController.text;
        } else if (isService.value) {
          // For service, check pricing type
          if (service.value?.pricingType == 'U') {
            // Hourly rate - send unit_price
            data['unit_price'] = negotiationPriceController.text;
          } else {
            // Fixed price - send total_price
            data['total_price'] = negotiationPriceController.text;
          }
        }
      }

      // Add other fields
      if (negotiationHoursController.text.trim().isNotEmpty) {
        data['estimated_hours'] = negotiationHoursController.text;
      }

      if (negotiationRangeStart.value != null) {
        data['start_datetime'] = startDateStr;
      }

      if (negotiationMessageController.text.trim().isNotEmpty) {
        if (isJob.value) {
          data['message_to_client'] = negotiationMessageController.text;
        } else {
          data['message_to_freelancer'] = negotiationMessageController.text;
        }
      }

      // Add end date if available
      if (endDateStr != null) {
        data['expiry_datetime'] = endDateStr;
      }

      final response = await _submitEngagementChangeRequestRepository
          .submitEngagementChangeRequest(
        engagement.value!.hashcode.toString(),
        data,
      );

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Negotiation submitted successfully',
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Close the bottom sheet and go back
        Get.back(); // Close bottom sheet
        // Get.back(result: true); // Go back to previous screen
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToSubmitNegotiation,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error submitting negotiation: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorSubmittingNegotiation(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isNegotiating.value = false;
    }
  }

  Future<void> submitDispute() async {
    // Validate reason field
    if (disputeReasonController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .pleaseEnterReasonForDispute,
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (engagement.value?.hashcode == null) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .taskInformationNotAvailable,
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isSubmittingDispute.value = true;

      Map<String, dynamic> disputeData = {
        'reason': disputeReasonController.text.trim(),
      };

      final response = await _submitDisputeRepository.submitDispute(
        engagement.value!.hashcode!,
        disputeData,
      );

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .disputeSubmittedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Close the bottom sheet and go back
        Get.back(); // Close bottom sheet
        // Get.back(result: true); // Go back to previous screen
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToSubmitDispute,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error submitting dispute: $e');
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorSubmittingDispute, SnackBarStatus.ERROR);
    } finally {
      isSubmittingDispute.value = false;
    }
  }

  bool get shouldRateItem {
    final engagementType = engagement.value?.type;

    if (engagementType == 'JA') {
      // Job Application: Job belongs to CLIENT
      // Only rate job if we're rating the CLIENT
      return targetUserType == 'C';
    } else {
      // Service/Package Booking: Service belongs to FREELANCER
      // Only rate service if we're rating the FREELANCER
      return targetUserType == 'F';
    }
  }

  // Determine if we're rating a freelancer or client
  String get targetUserType {
    final currentUserId = Prefs.getId;
    if (engagement.value?.clientHashcode.toString() == currentUserId) {
      // Current user is client, so we're rating the freelancer
      return 'F';
    } else {
      // Current user is freelancer, so we're rating the client
      return 'C';
    }
  }
  Future<void> acceptChangeRequest() async {
    if (engagement.value?.hashcode == null) return;

    try {
      isAcceptingChangeRequest.value = true;

      final response = await _acceptRejectChangeRequestRepository
          .acceptRejectEngagementChangeRequest(
        hashcode: engagement.value!.changeRequests!.first.hashcode!,
        accept: true,
      );

      if (response.success == true) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .changeRequestAcceptedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Go back to previous screen
        Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToAcceptChangeRequest,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error accepting change request: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorAcceptingChangeRequest(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isAcceptingChangeRequest.value = false;
    }
  }

  Future<void> rejectChangeRequest() async {
    if (engagement.value?.hashcode == null) return;

    try {
      isRejectingChangeRequest.value = true;

      final response = await _acceptRejectChangeRequestRepository
          .acceptRejectEngagementChangeRequest(
        hashcode: engagement.value!.changeRequests!.first.hashcode!,
        accept: false,
      );

      if (response.success == true) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .changeRequestRejectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Go back to previous screen
        Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToRejectChangeRequest,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error rejecting change request: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorRejectingChangeRequest(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isRejectingChangeRequest.value = false;
    }
  }

  Future<void> pickDeliverableFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'zip',
          'rar',
          'jpg',
          'jpeg',
          'png'
        ],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        deliverableFile.value = file;
        deliverableFileName.value = result.files.single.name;
        deliverableFileSize.value = result.files.single.size;
        deliverableFileExtension.value =
            result.files.single.extension?.toLowerCase();

        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .fileSelectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorSelectingFile(e.toString()), SnackBarStatus.ERROR);
      print('Error picking file: $e');
    }
  }

  void removeDeliverableFile() {
    deliverableFile.value = null;
    deliverableFileName.value = null;
    deliverableFileSize.value = null;
    deliverableFileExtension.value = null;
  }

  IconData getDeliverableFileIcon() {
    switch (deliverableFileExtension.value) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String getDeliverableFileSize() {
    if (deliverableFileSize.value == null) return '';
    final sizeInKB = deliverableFileSize.value! / 1024;
    if (sizeInKB < 1024) {
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else {
      final sizeInMB = sizeInKB / 1024;
      return '${sizeInMB.toStringAsFixed(2)} MB';
    }
  }

  Future<void> finishEngagement() async {
    if (engagement.value?.hashcode == null) return;

    // Validate that file is uploaded
    // if (deliverableFile.value == null) {
    //   constants.showSnackBar(
    //     Resources
    //         .of(Get.context!)
    //         .strings
    //         .pleaseUploadDeliverablesFile,
    //     SnackBarStatus.ERROR,
    //   );
    //   return;
    // }

    try {
      isFinishingEngagement.value = true;

      final response = await _finishEngagementRepository.finishEngagement(
        engagement.value!.hashcode!,
        deliverableFile: deliverableFile.value,
      );

      if (response.success == true) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .taskFinishedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Clear the file
        removeDeliverableFile();

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Close bottom sheet if open
        if (Get.isBottomSheetOpen == true) {
          Get.back(); // Close bottom sheet
        }

        // Show rating dialog
        _showRatingDialog();

        // Go back to previous screen
        // Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToFinishTask,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error finishing Task: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorFinishingTask(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isFinishingEngagement.value = false;
    }
  }

  Future<void> acceptFinishEngagement() async {
    if (engagement.value?.hashcode == null) return;

    try {
      isAcceptingFinishEngagement.value = true;

      final response =
      await _acceptRejectFinishEngagementRepository
          .acceptRejectFinishEngagement(
        engagement.value!.hashcode!,
        true,
      );

      if (response.success == true) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .finishTaskAcceptedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Show rating dialog
        _showRatingDialog();

        // Go back to previous screen
        // Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToAcceptFinishTask,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error accepting finish engagement: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorAcceptingFinishTask(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isAcceptingFinishEngagement.value = false;
    }
  }

  Future<void> rejectFinishEngagement() async {
    if (engagement.value?.hashcode == null) return;

    try {
      isRejectingFinishEngagement.value = true;

      final response =
      await _acceptRejectFinishEngagementRepository
          .acceptRejectFinishEngagement(
        engagement.value!.hashcode!,
        false,
      );

      if (response.success == true) {
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .finishTaskRejectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Show bottom sheet asking employer to contact freelancer
        _showContactFreelancerDialog();
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToRejectFinishTask,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error rejecting finish Task: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorRejectingFinishTask(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isRejectingFinishEngagement.value = false;
    }
  }

  void _showContactFreelancerDialog() {
    if (engagement.value == null) return;

    // Get freelancer info
    final freelancerHashcode = engagement.value!.freelancerHashcode;
    final freelancerName = '${engagement.value!.freelancerFirstName ?? ''} ${engagement.value!.freelancerLastName ?? ''}'.trim();

    if (freelancerHashcode == null || freelancerHashcode.isEmpty) {
      return;
    }

    // Show dialog asking user to contact freelancer
    DialogHelper.showAgreementPopup(
      Get.context!,
      Resources.of(Get.context!).strings.wouldYouLikeToContactFreelancer,
      Resources.of(Get.context!).strings.openConversation,
      Resources.of(Get.context!).strings.cancel,
      () {
        // Close dialog
        Navigator.pop(Get.context!);

        // Navigate to conversation screen
        Get.toNamed(
          RouteConstant.conversationMessagesScreen,
          arguments: {
            'member_hashcode': freelancerHashcode,
            'member_name': freelancerName.isNotEmpty ? freelancerName : 'Freelancer',
          },
        );
      },
      false.obs, // Not a loading state
      agreeColor: Get.context!.resources.color.colorPrimary,
    );
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
        Resources
            .of(Get.context!)
            .strings
            .cameraNotInitialized,
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      final image = await cameraController!.takePicture();
      faceMatchImage.value = image;
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .imageCapturedSuccessfully,
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

  Future<void> captureFaceMatchImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        faceMatchImage.value = image;
        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .imageCapturedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error capturing image: $e',
        SnackBarStatus.ERROR,
      );
      print('Error capturing face match image: $e');
    }
  }

  Future<void> verifyFaceMatch() async {
    if (faceMatchImage.value == null) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .pleaseCaptureImageFirst,
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
          Resources
              .of(Get.context!)
              .strings
              .faceVerifiedSuccessfully,
          SnackBarStatus.SUCCESS,
        );

        // Close the bottom sheet
        if (Get.isBottomSheetOpen == true) {
          Get.back();
        }

        // Handle different actions based on faceVerificationAction
        if (faceVerificationAction == 'accept_finish') {
          // Call accept finish engagement API
          await acceptFinishEngagement();
        } else if (faceVerificationAction == 'open_finish_sheet') {
          // Open finish engagement bottom sheet
          await Get.bottomSheet(
            FinishEngagementBottomSheet(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        } else if (faceVerificationAction == 'accept_engagement') {
          // Call accept engagement API
          await acceptEngagement();
        } else if (faceVerificationAction == 'reject_engagement') {
          // Call reject engagement API
          await rejectEngagement();
        }

        // Clear the face match image and reset action
        faceMatchImage.value = null;
        faceVerificationAction = null;
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .faceVerificationFailed,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error verifying face match: $e');
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .errorVerifyingFaceMatch(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isVerifyingFaceMatch.value = false;
    }
  }

  void _showRatingDialog() {
    if (engagement.value == null) return;

    // Check if already rated
    if (engagement.value!.isMemberRated == true &&
        engagement.value!.isSubjectRated == true) {
      return; // Already rated, don't show dialog
    }

    // Show dialog asking user to rate
    DialogHelper.showAgreementPopup(
      Get.context!,
      Resources.of(Get.context!).strings.wouldYouLikeToRateThisTask,
      Resources.of(Get.context!).strings.rateNow,
      Resources.of(Get.context!).strings.later,
      () {
        // Navigate to rate engagement screen
        Navigator.pop(Get.context!);
        Get.toNamed(
          RouteConstant.rateEngagementScreen,
          arguments: engagement.value,
        );
      },
      false.obs, // Not a loading state
      agreeColor: Get.context!.resources.color.colorPrimary,
    );
  }

  @override
  void onClose() {
    negotiationPriceController.dispose();
    negotiationHoursController.dispose();
    negotiationMessageController.dispose();
    disputeReasonController.dispose();
    disposeCamera();
    super.onClose();
  }
}
