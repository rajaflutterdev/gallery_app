import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gallery_image.dart';

class FavoritesRepository {
  static const _storageKey = 'favoriteImages';

  Future<List<GalleryImage>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(GalleryImage.fromStoredJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> toggle(GalleryImage image) async {
    final current = await getFavorites();
    final exists = current.any((item) => item.id == image.id);
    if (exists) {
      current.removeWhere((item) => item.id == image.id);
    } else {
      current.insert(0, image);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(current.map((item) => item.toJson()).toList()),
    );
  }

  Future<bool> contains(int id) async =>
      (await getFavorites()).any((image) => image.id == id);
}
