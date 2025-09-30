import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/submit_dispute_service.dart';

class SubmitDisputeRepository {
  final _provider = SubmitDisputeService();

  Future<ApiResponse> submitDispute(
    String hashcode,
    Map<String, dynamic> disputeData,
  ) async {
    return _provider.submitDispute(hashcode, disputeData);
  }
}
