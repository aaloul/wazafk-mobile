import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/payment_profile_service.dart';

class PaymentProfileRepository {
  final _provider = PaymentProfileService();

  Future<ApiResponse> getPaymentProfiles() =>
      _provider.getPaymentProfiles();

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
  }) =>
      _provider.savePaymentProfile(
        provider: provider,
        bankAccount: bankAccount,
        bankRoutingNumber: bankRoutingNumber,
        idDocumentNumber: idDocumentNumber,
        country: country,
        city: city,
        state: state,
        postalCode: postalCode,
        address: address,
      );

  Future<ApiResponse> paymentProfileStatus({
    required String hashcode,
    required int status,
  }) =>
      _provider.paymentProfileStatus(hashcode: hashcode, status: status);

  Future<ApiResponse> paymentProfileVerifyStatus({
    required String hashcode,
  }) =>
      _provider.paymentProfileVerifyStatus(hashcode: hashcode);
}
