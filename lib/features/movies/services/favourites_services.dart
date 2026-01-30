import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String favoritesKey = 'favorite_movies';

  // Save movie id as favorite
  static Future<void> addFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(favoritesKey) ?? [];
    if (!favs.contains(movieId.toString())) {
      favs.add(movieId.toString());
      await prefs.setStringList(favoritesKey, favs);
    }
  }

  // Remove movie id from favorites
  static Future<void> removeFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(favoritesKey) ?? [];
    favs.remove(movieId.toString());
    await prefs.setStringList(favoritesKey, favs);
  }

  // Check if movie id is favorite
  static Future<bool> isFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(favoritesKey) ?? [];
    return favs.contains(movieId.toString());
  }

  // Get all favorite ids
  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(favoritesKey) ?? [];
    return favs.map((e) => int.parse(e)).toList();
  }
}
