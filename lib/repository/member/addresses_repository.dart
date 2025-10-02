import '../../model/AddressesResponse.dart';
import '../../model/ApiResponse.dart';
import '../../networking/services/member/addresses_service.dart';

class AddressesRepository {
  final _provider = AddressesService();

  Future<ApiResponse> addAddress(Map<String, dynamic> data) async {
    return _provider.addAddress(data);
  }

  Future<ApiResponse> saveAddress(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveAddress(hashcode, data);
  }

  Future<AddressesResponse> getAddresses() async {
    return _provider.getAddresses();
  }

  Future<ApiResponse> deleteAddress(String hashcode) async {
    return _provider.deleteAddress(hashcode);
  }
}
