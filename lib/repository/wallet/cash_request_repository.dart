import 'dart:io';

import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/cash_request_service.dart';

class CashRequestRepository {
  final _provider = CashRequestService();

  Future<ApiResponse> cashFees({
    required String provider,
    required String type,
    required String amount,
  }) =>
      _provider.cashFees(provider: provider, type: type, amount: amount);

  Future<ApiResponse> submitCashRequest({
    required String provider,
    required String type,
    required String amount,
    String? reference,
    File? attachment,
  }) =>
      _provider.submitCashRequest(
        provider: provider,
        type: type,
        amount: amount,
        reference: reference,
        attachment: attachment,
      );

  Future<ApiResponse> cancelCashRequest({required String hashcode}) =>
      _provider.cancelCashRequest(hashcode: hashcode);

  Future<ApiResponse> getCashRequests() => _provider.getCashRequests();
}
