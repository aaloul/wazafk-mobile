import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/engagement/submit_engagement_repository.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class BookServiceController extends GetxController {
  final _addressesRepository = AddressesRepository();
  final _submitEngagementRepository = SubmitEngagementRepository();

  var service = Rx<Service?>(null);
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
    // Get service from arguments
    if (Get.arguments != null && Get.arguments is Service) {
      service.value = Get.arguments as Service;
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
        'Error fetching addresses: $e',
        SnackBarStatus.ERROR,
      );
      print('Error fetching addresses: $e');
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  Future<void> bookService() async {
    if (service.value == null) {
      constants.showSnackBar(
        'Service information not available',
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
    if (selectedServiceType.value == 'Onsite' &&
        selectedAddress.value == null) {
      constants.showSnackBar('Please select a location', SnackBarStatus.ERROR);
      return;
    }

    try {
      isLoading.value = true;

      // Format start date
      final startDateStr = DateFormat('yyyy-MM-dd').format(rangeStart.value!);

      // Format end date if available
      String? endDateStr;
      if (rangeEnd.value != null) {
        endDateStr = DateFormat('yyyy-MM-dd').format(rangeEnd.value!);
      }

      Map<String, dynamic> data = {
        'type': 'SR', // SR = Service Request
        'service': service.value!.hashcode!,
        'start_date': startDateStr,
        'service_type': selectedServiceType.value!,
        'message_to_client': notesController.text.trim(),
      };

      // Add end date if available
      if (endDateStr != null) {
        data['end_date'] = endDateStr;
      }

      // Add address only for Onsite service type
      if (selectedServiceType.value == 'Onsite' &&
          selectedAddress.value != null) {
        data['address'] = selectedAddress.value!.hashcode;
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
      constants.showSnackBar('Error booking service: $e', SnackBarStatus.ERROR);
      print('Error booking service: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
