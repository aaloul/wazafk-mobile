import 'package:wazafak_app/model/AreasResponse.dart';

import '../../networking/services/app/areas_service.dart';

class AreasRepository {
  final _provider = AreasService();

  Future<AreasResponse> getAreas() async {
    return _provider.getAreas();
  }
}
