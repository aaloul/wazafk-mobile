import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/add_favorite_job_service.dart';

class AddFavoriteJobRepository {
  final _provider = AddFavoriteJobService();

  Future<ApiResponse> addFavoriteJob(String jobHashcode) async {
    return _provider.addFavoriteJob(jobHashcode);
  }
}
