import 'package:wazafak_app/model/InterestOptionsResponse.dart';

import '../../networking/services/app/interest_options_service.dart';

class InterestOptionsRepository {
  final _provider = InterestOptionsService();

  Future<InterestOptionsResponse> getInterestOptions() async {
    return _provider.getInterestOptions();
  }
}
