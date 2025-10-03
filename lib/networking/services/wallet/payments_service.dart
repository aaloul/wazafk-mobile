import 'package:wazafak_app/model/PaymentsResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class PaymentsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<PaymentsResponse> getPayments({Map<String, String>? filters}) async {
    String url = Endpoints.payments;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return PaymentsResponse.fromJson(response);
  }
}
