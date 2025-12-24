import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/FAQSResponse.dart';
import 'package:wazafak_app/model/SupportCategoriesResponse.dart';
import 'package:wazafak_app/model/SupportStartConversationResponse.dart';
import 'package:wazafak_app/repository/app/faqs_repository.dart';
import 'package:wazafak_app/repository/support/last_support_conversation_repository.dart';
import 'package:wazafak_app/repository/support/start_support_chat_repository.dart';
import 'package:wazafak_app/repository/support/support_categories_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../utils/res/Resources.dart';

class HelpCenterController extends GetxController {
  final _faqsRepository = FaqsRepository();
  final _supportCategoriesRepository = SupportCategoriesRepository();
  final _lastSupportConversationRepository = LastSupportConversationRepository();
  final _startSupportChatRepository = StartSupportChatRepository();

  var isLoading = true.obs;
  var isLoadingCategories = true.obs;
  var isContactingSupportLoading = false.obs;
  var faqs = <Faq>[].obs;
  var supportCategories = <SupportCategory>[].obs;
  var selectedCategory = ''.obs;
  var expandedIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    fetchSupportCategories();
    fetchFaqs();
  }

  Future<void> fetchSupportCategories() async {
    try {
      isLoadingCategories.value = true;

      final response = await _supportCategoriesRepository.getSupportCategories();

      if (response.success == true && response.data?.list != null) {
        supportCategories.value = response.data!.list!;
      } else {
        constants.showSnackBar(
            response.message ?? Resources.of(Get.context!).strings.failedToLoadCategories,
            SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(
          Resources.of(Get.context!).strings.errorFetchingCategories,
          SnackBarStatus.ERROR);
      print('Error loading support categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;

      final response = await _faqsRepository.getFaqs();

      if (response.success == true && response.data != null) {
        faqs.value = response.data!;
      } else {
        constants.showSnackBar(
            response.message ?? Resources.of(Get.context!).strings.failedToLoadFaqs, SnackBarStatus.ERROR);
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

  Future<void> contactSupport() async {
    if (selectedCategory.value.isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectCategory,
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isContactingSupportLoading.value = true;

      // Step 1: Get last support conversation
      final lastConversationResponse = await _lastSupportConversationRepository.getLastSupportConversation();

      SupportConversation? conversation;

      // Step 2: Check if data is null or status == 1 (closed)
      if (lastConversationResponse.data == null ||
          lastConversationResponse.data!.status == 1) {
        // Get the selected category hashcode
        final selectedCategoryObj = supportCategories.firstWhere(
          (category) => category.name == selectedCategory.value,
          orElse: () => SupportCategory(),
        );

        if (selectedCategoryObj.hashcode == null) {
          constants.showSnackBar(
            Resources.of(Get.context!).strings.failedToLoad,
            SnackBarStatus.ERROR,
          );
          return;
        }

        // Start a new support chat
        final startChatResponse = await _startSupportChatRepository.createChat(
          category: selectedCategoryObj.hashcode!,
          subject: selectedCategory.value,
        );

        if (startChatResponse.success != true) {
          constants.showSnackBar(
            startChatResponse.message ?? Resources.of(Get.context!).strings.failedToSubmit,
            SnackBarStatus.ERROR,
          );
          return;
        }

        // Fetch the last conversation again to get the newly created conversation
        final newConversationResponse = await _lastSupportConversationRepository.getLastSupportConversation();
        conversation = newConversationResponse.data;
      } else {
        // Use existing conversation
        conversation = lastConversationResponse.data;
      }

      // Navigate to support chat screen based on conversation status
      if (conversation != null) {
        // If status == 0 (active), navigate to support chat screen
        // Otherwise navigate to conversation messages screen (for closed conversations)
        if (conversation.status == 0) {
          Get.toNamed(
            RouteConstant.supportChatScreen,
            arguments: conversation,
          );
        } else {
          // For closed or other status conversations, use regular messages screen
          Get.toNamed(
            RouteConstant.conversationMessagesScreen,
            arguments: conversation,
          );
        }
      } else {
        constants.showSnackBar(
          Resources.of(Get.context!).strings.failedToLoad,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error contacting support: $e');
      constants.showSnackBar(
        Resources.of(Get.context!).strings.failedToLoad,
        SnackBarStatus.ERROR,
      );
    } finally {
      isContactingSupportLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
