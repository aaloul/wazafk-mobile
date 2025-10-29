import '../../../model/FavoritesResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FavoritesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<FavoritesResponse> getFavorites({required String type}) async {
    final response = await _helper.get('${Endpoints.favorites}?type=$type');
    return FavoritesResponse.fromJson(response);
  }
}
