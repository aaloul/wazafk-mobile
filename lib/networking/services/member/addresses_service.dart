import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddressesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addAddress(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addAddress, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> saveAddress(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveAddress, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getAddresses() async {
    final response = await _helper.get(Endpoints.addresses);
    return ApiResponse.fromJson(response);
  }
}
