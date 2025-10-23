import 'package:get/get.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';

class ServiceDetailsController extends GetxController {
  var service = Rxn<Service>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get service from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Service) {
      service.value = arguments;
    }
  }
}
