import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_engagement_change_request_repository.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_engagement_repository.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_finish_engagement_repository.dart';
import 'package:wazafak_app/repository/engagement/finish_engagement_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_dispute_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_engagement_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../repository/engagement/engagement_detail_repository.dart';
import '../../../repository/engagement/submit_engagement_change_request_repository.dart';

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

  final Rx<Engagement?> engagement = Rx<Engagement?>(null);
  final Rx<Service?> service = Rx<Service?>(null);
  final Rx<Package?> package = Rx<Package?>(null);
  final Rx<Job?> job = Rx<Job?>(null);
  final RxBool isPackage = false.obs;
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
        isPackage.value = false;
        isJob.value = false;
      } else if (arg.type.toString() == 'PB' && arg.package != null) {
        package.value = arg.package;
        isPackage.value = true;
        isJob.value = false;
      } else if (arg.type.toString() == 'JA' && arg.job != null) {
        job.value = arg.job;
        isPackage.value = false;
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
            isPackage.value = false;
            isJob.value = false;
          } else if (engagement.value?.type == 'PB' &&
              engagement.value?.package != null) {
            package.value = engagement.value!.package;
            isPackage.value = true;
            isJob.value = false;
          } else if (engagement.value?.type == 'JA' &&
              engagement.value?.job != null) {
            job.value = engagement.value!.job;
            isPackage.value = false;
            isJob.value = true;
          }
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load engagement details',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error fetching engagement details: $e');
      constants.showSnackBar(
        'Error loading engagement details',
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
          'Engagement accepted successfully',
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
          response.message ?? 'Failed to accept engagement',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error accepting engagement: $e');
      constants.showSnackBar(
        'Error accepting engagement',
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
          'Engagement rejected successfully',
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
          response.message ?? 'Failed to reject engagement',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error rejecting engagement: $e');
      constants.showSnackBar(
        'Error rejecting engagement',
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

  Future<void> submitNegotiation() async {
    // Validate fields
    if (negotiationPriceController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar('Please enter a price', SnackBarStatus.ERROR);
      return;
    }

    if (negotiationHoursController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar(
        'Please enter estimated hours',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (negotiationRangeStart.value == null) {
      constants.showSnackBar(
        'Please select a date range',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (negotiationMessageController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar('Please enter a message', SnackBarStatus.ERROR);
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

      Map<String, dynamic> data = {
        'type': engagement.value!.type,
        'unit_price': negotiationPriceController.text,
        'total_price': negotiationPriceController.text,
        'estimated_hours': negotiationHoursController.text,
        'start_datetime': startDateStr,
        'message_to_client': negotiationMessageController.text,
      };

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
          response.message ?? 'Failed to submit negotiation',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error submitting negotiation: $e');
      constants.showSnackBar(
        'Error submitting negotiation',
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
        'Please enter a reason for the dispute',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (engagement.value?.hashcode == null) {
      constants.showSnackBar(
        'Engagement information not available',
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
          response.message ?? 'Dispute submitted successfully',
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
          response.message ?? 'Failed to submit dispute',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error submitting dispute: $e');
      constants.showSnackBar('Error submitting dispute', SnackBarStatus.ERROR);
    } finally {
      isSubmittingDispute.value = false;
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
          'Change request accepted successfully',
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
          response.message ?? 'Failed to accept change request',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error accepting change request: $e');
      constants.showSnackBar(
        'Error accepting change request',
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
          'Change request rejected successfully',
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
          response.message ?? 'Failed to reject change request',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error rejecting change request: $e');
      constants.showSnackBar(
        'Error rejecting change request',
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
          'File selected successfully',
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error selecting file: $e', SnackBarStatus.ERROR);
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
    if (deliverableFile.value == null) {
      constants.showSnackBar(
        'Please upload deliverables file',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isFinishingEngagement.value = true;

      final response = await _finishEngagementRepository.finishEngagement(
        engagement.value!.hashcode!,
        deliverableFile: deliverableFile.value,
      );

      if (response.success == true) {
        constants.showSnackBar(
          'Engagement finished successfully',
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

        // Go back to previous screen
        // Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to finish engagement',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error finishing engagement: $e');
      constants.showSnackBar(
        'Error finishing engagement',
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
          'Finish engagement accepted successfully',
          SnackBarStatus.SUCCESS,
        );

        // Refresh engagement details
        if (engagement.value?.hashcode != null) {
          await getEngagementDetails(engagement.value!.hashcode!);
        }

        // Go back to previous screen
        // Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to accept finish engagement',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error accepting finish engagement: $e');
      constants.showSnackBar(
        'Error accepting finish engagement',
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
          'Finish engagement rejected successfully',
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
          response.message ?? 'Failed to reject finish engagement',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error rejecting finish engagement: $e');
      constants.showSnackBar(
        'Error rejecting finish engagement',
        SnackBarStatus.ERROR,
      );
    } finally {
      isRejectingFinishEngagement.value = false;
    }
  }

  @override
  void onClose() {
    negotiationPriceController.dispose();
    negotiationHoursController.dispose();
    negotiationMessageController.dispose();
    disputeReasonController.dispose();
    super.onClose();
  }
}
