import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SubmitEngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> submitEngagement(Map<String, dynamic> data, {
    File? cvFile,
  }) async {
    // If there's a CV file, use multipart upload
    if (cvFile != null) {
      // Convert all data fields to String
      Map<String, String> fields = {};
      data.forEach((key, value) {
        if (key != 'freelancer_cv') {
          if (value is List) {
            fields[key] = value.join(',');
          } else {
            fields[key] = value.toString();
          }
        }
      });

      // Create multipart file
      List<http.MultipartFile> files = [
        await http.MultipartFile.fromPath(
          'freelancer_cv',
          cvFile.path,
        ),
      ];

      final response = await _helper.postMultipart(
        Endpoints.submitEngagement,
        fields,
        files,
      );
      return ApiResponse.fromJson(response);
    } else {
      // No CV file, use regular POST
      final response = await _helper.post(Endpoints.submitEngagement, data);
      return ApiResponse.fromJson(response);
    }
  }
}
