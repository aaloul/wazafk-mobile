import 'package:wazafak_app/model/FavoritesResponse.dart';

import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FavoriteJobsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<FavoritesResponse> getFavoriteJobs() async {
    final response = await _helper.get("${Endpoints.favoriteJobs}?type=J");
    return FavoritesResponse.fromJson(response);
  }
}
