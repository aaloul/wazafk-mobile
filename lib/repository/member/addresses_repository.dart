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

  Future<ApiResponse> getAddresses() async {
    return _provider.getAddresses();
  }
}
