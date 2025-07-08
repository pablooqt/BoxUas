import 'dart:convert';
import 'package:http/http.dart' as http;

class GenreService {
  static Map<int, String> _genreMap = {};

  /// Ambil data genre dari TMDb dan simpan dalam _genreMap
  static Future<void> fetchGenres() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/genre/movie/list?language=id-ID'),
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjQyOTgyOTNhODE0MWY3ZGU5OGIxZWY1OGJjNGZjYyIsIm5iZiI6MTc1MTQyMzM3MS4wNTQwMDAxLCJzdWIiOiI2ODY0OTk4YmMzZDljNzI0MTE0MTQ5N2YiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.GhpZXDCcWzzXdCaVnpt7Qs354gY9kCWaFBPUD3F8YWQ',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var genre in data['genres']) {
        _genreMap[genre['id']] = genre['name'];
      }
    }
  }

  static String getGenreName(List genreIds) {
    if (_genreMap.isEmpty) return 'N/A';
    return genreIds.isNotEmpty ? _genreMap[genreIds[0]] ?? 'N/A' : 'N/A';
  }

  static Map<int, String> get genreMap => _genreMap;
}
