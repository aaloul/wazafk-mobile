import 'dart:io';

import 'package:wazafak_app/model/ApiResponse.dart';
import 'package:wazafak_app/networking/services/member/save_document_service.dart';

class SaveDocumentRepository {
  final _provider = SaveDocumentService();

  Future<ApiResponse> saveDocument({
    required String documentType,
    File? frontId,
    File? backId,
    File? passport,
  }) async {
    return _provider.saveDocument(
      documentType: documentType,
      frontId: frontId,
      backId: backId,
      passport: passport,
    );
  }
}
