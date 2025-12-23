import 'package:get/get.dart';
import 'package:wazafak_app/model/FAQSResponse.dart';
import 'package:wazafak_app/repository/app/faqs_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class HelpCenterController extends GetxController {
  final _repository = FaqsRepository();

  var isLoading = true.obs;
  var faqs = <Faq>[].obs;
  var expandedIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;

      final response = await _repository.getFaqs();

      if (response.success == true && response.data != null) {
        faqs.value = response.data!;
      } else {
        constants.showSnackBar(
            response.message ?? 'Failed to load FAQs', SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorLoadingFaqs(e.toString()), SnackBarStatus.ERROR);
      print('Error loading FAQs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
