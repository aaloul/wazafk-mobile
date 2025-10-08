import 'package:get/get.dart';
import 'package:wazafak_app/model/WalletTransactionsResponse.dart';
import 'package:wazafak_app/networking/services/wallet/wallet_transactions_service.dart';
import 'package:wazafak_app/utils/Prefs.dart';

class PaymentsEarningsController extends GetxController {
  var selectedTab = 'Payment Overview'.obs;
  var isLoading = false.obs;
  var transactions = <Transaction>[].obs;
  var totalTransactions = 0.obs;
  var totalPayout = '0 USD'.obs;
  var selectedSortBy = 'date_desc'.obs;
  String? sortBy;

  final WalletTransactionsService _walletTransactionsService =
      WalletTransactionsService();

  @override
  void onInit() {
    super.onInit();
    fetchWalletTransactions();
  }

  Future<void> fetchWalletTransactions() async {
    try {
      isLoading.value = true;

      Map<String, String>? filters;

      filters = {
        'sort_by': selectedSortBy.value,
        'wallet': Prefs.getWalletHashcode,
        'type': selectedTab.value == 'Payment Overview' ? 'O' : "I",
      };

      final response = await _walletTransactionsService.getWalletTransactions(
        filters: filters,
      );

      if (response.success == true && response.data != null) {
        transactions.value = response.data!.list ?? [];
        totalTransactions.value = response.data!.meta?.total ?? 0;

        // Calculate total payout
        double total = 0;
        for (var transaction in transactions) {
          if (transaction.amount != null) {
            total += double.tryParse(transaction.amount!) ?? 0;
          }
        }
        totalPayout.value = '${total.toStringAsFixed(2)} USD';
      }
    } catch (e) {
      print('Error fetching wallet transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSortBy(String sortBy) {
    fetchWalletTransactions();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
