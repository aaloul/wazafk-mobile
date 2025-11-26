import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_engagement_repository.dart';
import 'package:wazafak_app/repository/engagement/engagement_detail_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_dispute_repository.dart';
import 'package:wazafak_app/repository/engagement/submit_engagement_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class EngagementDetailsController extends GetxController {
  final _repository = EngagementDetailRepository();
  final _acceptRejectRepository = AcceptRejectEngagementRepository();
  final _submitEngagementRepository = SubmitEngagementRepository();
  final _submitDisputeRepository = SubmitDisputeRepository();

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

  // Negotiation fields
  final TextEditingController negotiationPriceController =
  TextEditingController();
  final TextEditingController negotiationHoursController =
  TextEditingController();
  final TextEditingController negotiationMessageController =
  TextEditingController();
  var negotiationRangeStart = Rx<DateTime?>(null);
  var negotiationRangeEnd = Rx<DateTime?>(null);
  var negotiationFocusedDay = DateTime
      .now()
      .obs;
  var negotiationRangeSelectionMode = RangeSelectionMode.toggledOn.obs;

  // Dispute fields
  final TextEditingController disputeReasonController =
  TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;

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

      // if (arg.hashcode != null) {
      //   fetchEngagementDetails(arg.hashcode!);
      // }
    } else if (arg is String) {
      // fetchEngagementDetails(arg);
    }
  }

  Future<void> acceptEngagement() async {
    if (engagement.value?.hashcode == null) return;

    try {
      isAccepting.value = true;

      final response = await _acceptRejectRepository.acceptRejectEngagement(
        hashcode: engagement.value!.hashcode!, accept: true,
      );

      if (response.success == true) {
        constants.showSnackBar(
          'Engagement accepted successfully',
          SnackBarStatus.SUCCESS,
        );

        // Update engagement status locally
        engagement.value!.status = 1;
        engagement.refresh();

        // Go back to previous screen
        Get.back(result: true);
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
        hashcode: engagement.value!.hashcode!, accept: false,
      );

      if (response.success == true) {
        constants.showSnackBar(
          'Engagement rejected successfully',
          SnackBarStatus.SUCCESS,
        );

        // Update engagement status locally
        engagement.value!.status = -1;
        engagement.refresh();

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

  void onNegotiationRangeSelected(DateTime? start, DateTime? end,
      DateTime focused) {
    negotiationFocusedDay.value = focused;
    negotiationRangeStart.value = start;
    negotiationRangeEnd.value = end;
  }

  String formatNegotiationDateRange() {
    if (negotiationRangeStart.value == null) return 'No dates selected';

    final startStr =
    DateFormat('MMM dd, yyyy').format(negotiationRangeStart.value!);

    if (negotiationRangeEnd.value == null) {
      return startStr;
    }

    final endStr =
    DateFormat('MMM dd, yyyy').format(negotiationRangeEnd.value!);
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

      final startDateStr =
      DateFormat('yyyy-MM-dd').format(negotiationRangeStart.value!);

      String? endDateStr;
      if (negotiationRangeEnd.value != null) {
        endDateStr =
            DateFormat('yyyy-MM-dd').format(negotiationRangeEnd.value!);
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


      final response =
      await _submitEngagementRepository.submitEngagement(data);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Negotiation submitted successfully',
          SnackBarStatus.SUCCESS,
        );

        // Close the bottom sheet and go back
        Get.back(); // Close bottom sheet
        Get.back(result: true); // Go back to previous screen
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

        // Close the bottom sheet and go back
        Get.back(); // Close bottom sheet
        Get.back(result: true); // Go back to previous screen
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to submit dispute',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error submitting dispute: $e');
      constants.showSnackBar(
        'Error submitting dispute',
        SnackBarStatus.ERROR,
      );
    } finally {
      isSubmittingDispute.value = false;
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
