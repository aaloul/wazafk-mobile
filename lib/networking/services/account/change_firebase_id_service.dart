import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ChangeFirebaseIdService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> changeFirebaseId(String firebaseId) async {
    final Map<String, dynamic> body = {'firebase_id': firebaseId};
    final response = await _helper.post(Endpoints.changeFirebaseId, body);
    return ApiResponse.fromJson(response);
  }
}
