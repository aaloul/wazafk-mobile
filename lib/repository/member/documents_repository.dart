import '../../model/ApiResponse.dart';
import '../../model/DocumentsResponse.dart';
import '../../networking/services/member/documents_service.dart';

class DocumentsRepository {
  final _provider = DocumentsService();

  Future<ApiResponse> saveDocument(Map<String, dynamic> data) async {
    return _provider.saveDocument(data);
  }

  Future<DocumentsResponse> getDocuments() async {
    return _provider.getDocuments();
  }
}
