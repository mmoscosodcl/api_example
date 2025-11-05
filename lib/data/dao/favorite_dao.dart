import '../database_helper.dart';

class FavoriteDao {
  final dbHelper = DatabaseHelper();

  Future<void> addFavorite(int id) async {
    await dbHelper.addFavorite(id);
  }

  Future<void> removeFavorite(int id) async {
    await dbHelper.removeFavorite(id);
  }

  Future<List<int>> getFavorites() async {
    return await dbHelper.getFavorites();
  }

  Future<bool> isFavorite(int id) async {
    return await dbHelper.isFavorite(id);
  }
}
