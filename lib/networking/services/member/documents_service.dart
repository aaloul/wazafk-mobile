import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class DocumentsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> saveDocument(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.saveDocument, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getDocuments() async {
    final response = await _helper.get(Endpoints.documents);
    return ApiResponse.fromJson(response);
  }
}
