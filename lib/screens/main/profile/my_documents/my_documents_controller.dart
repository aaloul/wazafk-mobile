import 'package:get/get.dart';
import 'package:wazafak_app/model/DocumentsResponse.dart';
import 'package:wazafak_app/repository/member/documents_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class MyDocumentsController extends GetxController {
  final _repository = DocumentsRepository();

  var isLoading = true.obs;
  var documents = <Document>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      isLoading.value = true;
      final response = await _repository.getDocuments();

      if (response.success == true && response.data != null) {
        documents.value = response.data!;
      } else {
        constants.showSnackBar(
            response.message.toString(), SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(
          'Error fetching documents: $e', SnackBarStatus.ERROR);
      print('Error fetching documents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
