import 'package:get/get.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class MyAddressesController extends GetxController {
  final _repository = AddressesRepository();

  var isLoading = true.obs;
  var addresses = <Address>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final response = await _repository.getAddresses();

      if (response.success == true && response.data != null) {
        addresses.value = response.data!;
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

  Future<void> deleteAddress(String hashcode) async {
    try {
      final response = await _repository.deleteAddress(hashcode);

      if (response.success == true) {
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
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
