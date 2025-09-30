import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ServiceService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addService(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addService, data);
    return response;
  }

  Future<ApiResponse> saveService(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveService, data);
    return response;
  }

  Future<ApiResponse> updateServiceStatus(String hashcode, int status) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'status': status};
    final response = await _helper.post(Endpoints.serviceStatus, body);
    return response;
  }

  Future<ApiResponse> getServices({Map<String, String>? filters}) async {
    String url = Endpoints.services;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return response;
  }

  Future<ApiResponse> getService(String hashcode) async {
    final response = await _helper.get('service/service/$hashcode');
    return response;
  }
}
