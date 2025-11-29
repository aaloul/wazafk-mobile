import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FinishEngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> finishEngagement(String hashcode, {
    File? deliverableFile,
  }) async {
    // If there's a deliverable file, use multipart upload
    if (deliverableFile != null) {
      Map<String, String> fields = {
        'hashcode': hashcode,
      };

      List<http.MultipartFile> files = [
        await http.MultipartFile.fromPath(
          'deliverables',
          deliverableFile.path,
        ),
      ];

      final response = await _helper.postMultipart(
        Endpoints.finishEngagement,
        fields,
        files,
      );
      return ApiResponse.fromJson(response);
    } else {
      // No file, use regular POST
      final Map<String, dynamic> body = {'hashcode': hashcode};
      final response = await _helper.post(Endpoints.finishEngagement, body);
      return ApiResponse.fromJson(response);
    }
  }
}
