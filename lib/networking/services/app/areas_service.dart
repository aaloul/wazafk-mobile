import 'package:wazafak_app/model/AreasResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AreasService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<AreasResponse> getAreas() async {
    final response = await _helper.get(Endpoints.areas);
    return AreasResponse.fromJson(response);
  }
}
