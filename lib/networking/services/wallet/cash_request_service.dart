import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

/// Wallet cash-in / cash-out flow.
/// type='OUT' for withdrawals, 'IN' for top-ups via cash channels (OMT, etc).
class CashRequestService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  /// Compute provider fee for a given amount before submitting.
  Future<ApiResponse> cashFees({
    required String provider,
    required String type,
    required String amount,
  }) async {
    final response = await _helper.post(
      Endpoints.cashFees,
      {'provider': provider, 'type': type, 'amount': amount},
    );
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> submitCashRequest({
    required String provider,
    required String type,
    required String amount,
    String? reference,
    File? attachment,
  }) async {
    if (attachment != null) {
      final file = await http.MultipartFile.fromPath(
        'attachment',
        attachment.path,
      );
      final response = await _helper.postMultipart(
        Endpoints.submitCashRequest,
        {
          'provider': provider,
          'type': type,
          'amount': amount,
          if (reference != null) 'reference': reference,
        },
        [file],
      );
      return ApiResponse.fromJson(response);
    }
    final response = await _helper.post(
      Endpoints.submitCashRequest,
      {
        'provider': provider,
        'type': type,
        'amount': amount,
        if (reference != null) 'reference': reference,
      },
    );
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> cancelCashRequest({required String hashcode}) async {
    final response = await _helper.post(
      Endpoints.cancelCashRequest,
      {'hashcode': hashcode},
    );
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getCashRequests() async {
    final response = await _helper.get(Endpoints.cashRequests);
    return ApiResponse.fromJson(response);
  }
}
