import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FavoriteService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addFavoriteMember(String memberHashcode) async {
    final Map<String, dynamic> body = {'member_hashcode': memberHashcode};
    final response = await _helper.post(Endpoints.addFavoriteMember, body);
    return response;
  }

  Future<ApiResponse> removeFavoriteMember(String memberHashcode) async {
    final Map<String, dynamic> body = {'member_hashcode': memberHashcode};
    final response = await _helper.post(Endpoints.removeFavoriteMember, body);
    return response;
  }

  Future<ApiResponse> addFavoriteJob(String jobHashcode) async {
    final Map<String, dynamic> body = {'job_hashcode': jobHashcode};
    final response = await _helper.post(Endpoints.addFavoriteJob, body);
    return response;
  }

  Future<ApiResponse> removeFavoriteJob(String jobHashcode) async {
    final Map<String, dynamic> body = {'job_hashcode': jobHashcode};
    final response = await _helper.post(Endpoints.removeFavoriteJob, body);
    return response;
  }

  Future<ApiResponse> getFavoriteMembers() async {
    final response = await _helper.get(Endpoints.favoriteMembers);
    return response;
  }

  Future<ApiResponse> getFavoriteJobs() async {
    final response = await _helper.get(Endpoints.favoriteJobs);
    return response;
  }
}
