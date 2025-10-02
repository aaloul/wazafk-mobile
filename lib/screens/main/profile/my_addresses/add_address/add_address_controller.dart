import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class AddAddressController extends GetxController {
  final _repository = AddressesRepository();

  final labelController = TextEditingController();
  final addressController = TextEditingController();
  final streetController = TextEditingController();
  final buildingController = TextEditingController();
  final apartmentController = TextEditingController();

  var isLoading = false.obs;
  var isEditMode = false.obs;
  String? editHashcode;

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode
    final Address? address = Get.arguments as Address?;
    if (address != null) {
      isEditMode.value = true;
      editHashcode = address.hashcode;
      _populateFields(address);
    }
  }

  void _populateFields(Address address) {
    labelController.text = address.label ?? '';
    addressController.text = address.address ?? '';
    streetController.text = address.street ?? '';
    buildingController.text = address.building ?? '';
    apartmentController.text = address.apartment ?? '';
  }

  Future<void> saveAddress() async {
    if (!_validateFields()) {
      return;
    }

    try {
      isLoading.value = true;

      final data = {
        'label': labelController.text,
        'address': addressController.text,
        'street': streetController.text,
        'building': buildingController.text,
        'apartment': apartmentController.text,
      };

      final response = isEditMode.value
          ? await _repository.saveAddress(editHashcode!, data)
          : await _repository.addAddress(data);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ??
              (isEditMode.value
                  ? 'Address updated successfully'
                  : 'Address added successfully'),
          SnackBarStatus.SUCCESS,
        );
        Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ??
              (isEditMode.value
                  ? 'Failed to update address'
                  : 'Failed to add address'),
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error ${isEditMode.value ? 'updating' : 'adding'} address: $e',
        SnackBarStatus.ERROR,
      );
      print('Error ${isEditMode.value ? 'updating' : 'adding'} address: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateFields() {
    if (labelController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter a label', SnackBarStatus.ERROR);
      return false;
    }
    if (addressController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter an address', SnackBarStatus.ERROR);
      return false;
    }
    if (streetController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter a street', SnackBarStatus.ERROR);
      return false;
    }
    if (buildingController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter a building', SnackBarStatus.ERROR);
      return false;
    }
    if (apartmentController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter an apartment', SnackBarStatus.ERROR);
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    labelController.dispose();
    addressController.dispose();
    streetController.dispose();
    buildingController.dispose();
    apartmentController.dispose();
    super.onClose();
  }
}
