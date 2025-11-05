import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media.dart';

class ApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  // Search shows by query
  Future<List<Media>> searchShows(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/shows?q=$query'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map<Media>((item) => Media.fromJson(item['show'])).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  // Lookup show by thetvdb id
  Future<Media> lookupShowByTvdb(int tvdbId) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup/shows?thetvdb=$tvdbId'));
    if (response.statusCode == 200) {
      return Media.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to lookup show');
    }
  }

  // Get show by id
  Future<Media> getShowById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/shows/$id'));
    if (response.statusCode == 200) {
      return Media.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get show');
    }
  }

  // Get images for a show by id
  Future<List<MediaImage>> getShowImages(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/shows/$id/images'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map<MediaImage>((item) => MediaImage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get show images');
    }
  }
}
