import '../../model/ApiResponse.dart';
import '../../networking/services/member/documents_service.dart';

class DocumentsRepository {
  final _provider = DocumentsService();

  Future<ApiResponse> saveDocument(Map<String, dynamic> data) async {
    return _provider.saveDocument(data);
  }

  Future<ApiResponse> getDocuments() async {
    return _provider.getDocuments();
  }
}
