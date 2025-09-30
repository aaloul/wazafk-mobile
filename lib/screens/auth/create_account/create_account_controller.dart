import 'package:get/get.dart';
import 'package:wazafak_app/model/InterestOptionsResponse.dart';
import 'package:wazafak_app/repository/app/interest_options_repository.dart';

import '../../../utils/utils.dart';

class CreateAccountController extends GetxController {
  final InterestOptionsRepository _interestOptionsRepository =
      InterestOptionsRepository();

  var index = 0.obs;
  List<String> genders = ["Male", "Female"];

  var selectedGender = "".obs;
  var selectedTab = "personal_id".obs;

  var isInterestOptionsLoading = false.obs;
  final selectedDate = Rxn<DateTime?>();

  RxList<InterestOption> interests = <InterestOption>[].obs;

  Future<void> getInterestOptions() async {
    isInterestOptionsLoading(true);
    try {
      final response = await _interestOptionsRepository.getInterestOptions();
      if (response.success ?? false) {
        interests.value = response.data ?? [];
      }
      isInterestOptionsLoading(false);
    } catch (e) {
      isInterestOptionsLoading(false);

      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    getInterestOptions();
    selectedGender.value = genders.first;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  void verifyStep1() {
    index.value = 1;
  }

  void verifyStep2() {
    index.value = 2;
  }
}
