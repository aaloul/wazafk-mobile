import 'package:get/get.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';

class PackageDetailsController extends GetxController {
  var package = Rxn<Package>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get package from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Package) {
      package.value = arguments;
    }
  }
}
