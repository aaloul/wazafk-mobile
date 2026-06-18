import '../../model/ApiResponse.dart';
import '../../networking/services/account/change_firebase_id_service.dart';

class ChangeFirebaseIdRepository {
  final _provider = ChangeFirebaseIdService();

  Future<ApiResponse> changeFirebaseId(String firebaseId) async {
    return _provider.changeFirebaseId(firebaseId);
  }
}
