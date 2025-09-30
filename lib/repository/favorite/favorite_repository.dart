import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/favorite_service.dart';

class FavoriteRepository {
  final _provider = FavoriteService();

  Future<ApiResponse> addFavoriteMember(String memberHashcode) async {
    return _provider.addFavoriteMember(memberHashcode);
  }

  Future<ApiResponse> removeFavoriteMember(String memberHashcode) async {
    return _provider.removeFavoriteMember(memberHashcode);
  }

  Future<ApiResponse> addFavoriteJob(String jobHashcode) async {
    return _provider.addFavoriteJob(jobHashcode);
  }

  Future<ApiResponse> removeFavoriteJob(String jobHashcode) async {
    return _provider.removeFavoriteJob(jobHashcode);
  }

  Future<ApiResponse> getFavoriteMembers() async {
    return _provider.getFavoriteMembers();
  }

  Future<ApiResponse> getFavoriteJobs() async {
    return _provider.getFavoriteJobs();
  }
}
