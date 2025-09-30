import '../../networking/services/favorite/remove_favorite_job_service.dart';
import '../../model/ApiResponse.dart';

class RemoveFavoriteJobRepository {
  final _provider = RemoveFavoriteJobService();

  Future<ApiResponse> removeFavoriteJob(String jobHashcode) async {
    return _provider.removeFavoriteJob(jobHashcode);
  }
}
