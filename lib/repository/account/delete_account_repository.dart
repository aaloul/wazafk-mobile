import '../../model/ApiResponse.dart';
import '../../networking/services/account/delete_account_service.dart';

class DeleteAccountRepository {
  final _provider = DeleteAccountService();

  Future<ApiResponse> deleteAccount() async {
    return _provider.deleteAccount();
  }
}
