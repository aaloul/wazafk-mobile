import 'package:wazafak_app/model/MemberReviewsResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class MemberReviewsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<MemberReviewsResponse> getMemberReviews({
    Map<String, String>? filters,
  }) async {
    String url = Endpoints.memberRatings;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }

    final response = await _helper.get(url);
    return MemberReviewsResponse.fromJson(response);
  }
}
