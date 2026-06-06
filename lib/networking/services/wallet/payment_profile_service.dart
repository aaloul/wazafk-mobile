import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

/// Endpoints in `wallet/paymentProfiles*` deal with the freelancer's
/// **payout** profile — bank account, routing number, ID document, etc.
/// They are NOT credit-card payment methods. The Figma Add Card screen uses
/// a different data shape that the backend currently doesn't accept.
class PaymentProfileService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getPaymentProfiles() async {
    final response = await _helper.get(Endpoints.paymentProfiles);
    return ApiResponse.fromJson(response);
  }

  /// Postman fields: provider, bank_account, bank_routing_number,
  /// id_document_number, country, city, state, postal_code, address.
  Future<ApiResponse> savePaymentProfile({
    required String provider,
    required String bankAccount,
    required String bankRoutingNumber,
    required String idDocumentNumber,
    required String country,
    required String city,
    required String state,
    required String postalCode,
    required String address,
  }) async {
    final response = await _helper.post(
      Endpoints.savePaymentProfile,
      {
        'provider': provider,
        'bank_account': bankAccount,
        'bank_routing_number': bankRoutingNumber,
        'id_document_number': idDocumentNumber,
        'country': country,
        'city': city,
        'state': state,
        'postal_code': postalCode,
        'address': address,
      },
    );
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> paymentProfileStatus({
    required String hashcode,
    required int status,
  }) async {
    final response = await _helper.post(
      Endpoints.paymentProfileStatus,
      {'hashcode': hashcode, 'status': status.toString()},
    );
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> paymentProfileVerifyStatus({
    required String hashcode,
  }) async {
    final response = await _helper.post(
      Endpoints.paymentProfileVerifyStatus,
      {'hashcode': hashcode},
    );
    return ApiResponse.fromJson(response);
  }
}
