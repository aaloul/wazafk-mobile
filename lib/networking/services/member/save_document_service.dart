import 'dart:io';

import 'package:http/http.dart';
import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SaveDocumentService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> saveDocument({
    required String documentType,
    File? frontId,
    File? backId,
    File? passport,
  }) async {
    List<MultipartFile> files = [];

    // Add files based on document type
    if (documentType == 'ID') {
      if (frontId != null) {
        files.add(await MultipartFile.fromPath('document_1', frontId.path));
      }
      if (backId != null) {
        files.add(await MultipartFile.fromPath('document_2', backId.path));
      }
    } else if (documentType == 'PP') {
      if (passport != null) {
        files.add(
          await MultipartFile.fromPath('document_passport', passport.path),
        );
      }
    }

    // Fields
    Map<String, String> fields = {'document_type': documentType};

    final response = await _helper.postMultipart(
      Endpoints.saveDocument,
      fields,
      files,
    );

    return ApiResponse.fromJson(response);
  }
}
