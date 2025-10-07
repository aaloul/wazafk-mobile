import 'package:get/get.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/service/services_list_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class ServicesController extends GetxController {
  final _repository = ServicesListRepository();

  var isLoading = false.obs;
  var services = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
  }

  Future<void> fetchServices() async {
    try {

      Map<String, String>? filters = {};
      // filters['member'] = Prefs.getId;

      final response = await _repository.getServices(filters: filters);

      if (response.success == true && response.data?.list != null) {
        services.value = response.data!.list!;
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load services',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading services: $e',
        SnackBarStatus.ERROR,
      );
      print('Error loading services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
