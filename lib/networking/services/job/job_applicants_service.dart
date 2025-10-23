import 'package:wazafak_app/model/JobApplicantsResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class JobApplicantsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<JobApplicantsResponse> getJobApplicants({
    Map<String, String>? filters,
  }) async {
    String url = Endpoints.jobApplicants;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return JobApplicantsResponse.fromJson(response);
  }
}
