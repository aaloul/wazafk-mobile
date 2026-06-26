import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/SupportCategoriesResponse.dart';
import 'package:wazafak_app/repository/support/start_support_chat_repository.dart';
import 'package:wazafak_app/repository/support/support_categories_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../model/SupportConversationsResponse.dart';

class GetSupportController extends GetxController {
  final _supportCategoriesRepository = SupportCategoriesRepository();
  final _startSupportChatRepository = StartSupportChatRepository();

  var isLoadingCategories = true.obs;
  var isStartingChat = false.obs;
  var supportCategories = <SupportCategory>[].obs;

  /// hashcode of the category whose chat is currently being started (for a
  /// per-row spinner); empty when none.
  var startingCategoryHashcode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSupportCategories();
  }

  Future<void> fetchSupportCategories() async {
    try {
      isLoadingCategories.value = true;
      final response = await _supportCategoriesRepository.getSupportCategories();
      if (response.success == true && response.data?.list != null) {
        supportCategories.value = response.data!.list!;
      } else {
        constants.showSnackBar(
          response.message ??
              Resources.of(Get.context!).strings.failedToLoadCategories,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorFetchingCategories,
        SnackBarStatus.ERROR,
      );
      print('Error loading support categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// Starts a support conversation for [category] and opens the chat.
  Future<void> startChat(SupportCategory category) async {
    if (category.hashcode == null) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.failedToLoad,
        SnackBarStatus.ERROR,
      );
      return;
    }
    if (isStartingChat.value) return;

    try {
      isStartingChat.value = true;
      startingCategoryHashcode.value = category.hashcode!;

      final response = await _startSupportChatRepository.createChat(
        category: category.hashcode!,
        subject: category.name ?? '',
      );

      if (response.success != true || response.data == null) {
        constants.showSnackBar(
          response.message ?? Resources.of(Get.context!).strings.failedToSubmit,
          SnackBarStatus.ERROR,
        );
        return;
      }

      final SupportConversation conversation = response.data!;
      // status == 0 means active → live chat; otherwise the read-only thread.
      Get.toNamed(
        conversation.status == 0
            ? RouteConstant.supportChatScreen
            : RouteConstant.conversationMessagesScreen,
        arguments: conversation,
      );
    } catch (e) {
      print('Error starting support chat: $e');
      constants.showSnackBar(
        Resources.of(Get.context!).strings.failedToLoad,
        SnackBarStatus.ERROR,
      );
    } finally {
      isStartingChat.value = false;
      startingCategoryHashcode.value = '';
    }
  }
}
