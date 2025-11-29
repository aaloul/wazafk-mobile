import 'dart:io';

import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/finish_engagement_service.dart';

class FinishEngagementRepository {
  final _provider = FinishEngagementService();

  Future<ApiResponse> finishEngagement(
    String hashcode, {
    File? deliverableFile,
  }) async {
    return _provider.finishEngagement(
      hashcode,
      deliverableFile: deliverableFile,
    );
  }
}
