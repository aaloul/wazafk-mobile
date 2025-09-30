import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/favorite_jobs_service.dart';

class FavoriteJobsRepository {
  final _provider = FavoriteJobsService();

  Future<ApiResponse> getFavoriteJobs() async {
    return _provider.getFavoriteJobs();
  }
}
