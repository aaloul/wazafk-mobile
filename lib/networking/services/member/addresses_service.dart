import 'package:wazafak_app/model/AddressesResponse.dart';

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

  Future<AddressesResponse> getAddresses() async {
    final response = await _helper.get(Endpoints.addresses);
    return AddressesResponse.fromJson(response);
  }

  Future<ApiResponse> deleteAddress(String hashcode) async {
    final data = {'hashcode': hashcode};
    final response = await _helper.post(Endpoints.deleteAddress, data);
    return ApiResponse.fromJson(response);
  }
}
