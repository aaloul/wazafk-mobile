import 'package:get/get.dart';
import 'package:wazafak_app/components/dialog/dialog_helper.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

class MyAddressesController extends GetxController {
  final _repository = AddressesRepository();

  var isLoading = true.obs;
  var addresses = <Address>[].obs;
  var isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;

    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      final response = await _repository.getAddresses();

      if (response.success == true && response.data != null) {
        addresses.value = response.data!;
        Prefs.setAddresses(addresses.value);
      } else {
        constants.showSnackBar(
            response.message.toString(), SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(
          'Error fetching addresses: $e', SnackBarStatus.ERROR);
      print('Error fetching addresses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void confirmDeleteAddress(String hashcode) {
    DialogHelper.showAgreementPopup(
      Get.context!,
      'Are you sure you want to delete this address?',
      'Delete',
      'Cancel',
          () => deleteAddress(hashcode),
      isDeleting,
    );
  }

  Future<void> deleteAddress(String hashcode) async {
    try {
      isDeleting.value = true;
      final response = await _repository.deleteAddress(hashcode);

      if (response.success == true) {
        Get.back(); // Close dialog
        constants.showSnackBar(
            response.message ?? 'Address deleted successfully',
            SnackBarStatus.SUCCESS);
        fetchAddresses();
      } else {
        constants.showSnackBar(
            response.message ?? 'Failed to delete address',
            SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(
          'Error deleting address: $e', SnackBarStatus.ERROR);
      print('Error deleting address: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
