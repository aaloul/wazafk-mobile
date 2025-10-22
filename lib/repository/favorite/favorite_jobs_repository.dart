import '../../model/ApiResponse.dart';
import '../../model/FavoritesResponse.dart';
import '../../networking/services/favorite/favorite_jobs_service.dart';

class FavoriteJobsRepository {
  final _provider = FavoriteJobsService();

  Future<FavoritesResponse> getFavoriteJobs() async {
    return _provider.getFavoriteJobs();
  }
}
