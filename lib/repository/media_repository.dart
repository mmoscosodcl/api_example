import '../api/api_service.dart';
import '../models/media.dart';
import '../data/dao/favorite_dao.dart';

class MediaRepository {
  final ApiService apiService;
  final FavoriteDao favoriteDao;

  MediaRepository({ApiService? apiService, FavoriteDao? favoriteDao})
      : apiService = apiService ?? ApiService(),
        favoriteDao = favoriteDao ?? FavoriteDao();

  Future<List<Media>> searchShows(String query) async {
    return await apiService.searchShows(query);
  }

  Future<Media> lookupShowByTvdb(int tvdbId) async {
    return await apiService.lookupShowByTvdb(tvdbId);
  }

  Future<Media> getShowById(int id) async {
    return await apiService.getShowById(id);
  }

  Future<List<MediaImage>> getShowImages(int id) async {
    return await apiService.getShowImages(id);
  }

  // Favorite operations
  Future<void> addFavorite(int id) async {
    await favoriteDao.addFavorite(id);
  }

  Future<void> removeFavorite(int id) async {
    await favoriteDao.removeFavorite(id);
  }

  Future<List<int>> getFavorites() async {
    return await favoriteDao.getFavorites();
  }

  Future<bool> isFavorite(int id) async {
    return await favoriteDao.isFavorite(id);
  }
}
