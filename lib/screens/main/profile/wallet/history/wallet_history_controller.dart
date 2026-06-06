import 'package:get/get.dart';
import 'package:wazafak_app/model/WalletTransactionsResponse.dart';
import 'package:wazafak_app/repository/wallet/wallet_transactions_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';

class WalletHistoryController extends GetxController {
  final _repo = WalletTransactionsRepository();

  final transactions = <Transaction>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      isLoading.value = true;
      final wallet = Prefs.getWalletHashcode;
      final response = await _repo.getWalletTransactions(
        filters: wallet.isNotEmpty ? {'wallet': wallet} : null,
      );
      if (response.success == true) {
        transactions.value = response.data?.list ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }
}
