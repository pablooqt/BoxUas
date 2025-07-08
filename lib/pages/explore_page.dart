import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/genre_service.dart';
import 'detail_page.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int? selectedGenreId;
  double minRating = 7.0;
  List<Map<String, dynamic>> movies = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    GenreService.fetchGenres(); 
  }

  Future<void> fetchFilteredMovies() async {
    if (selectedGenreId == null) return;

    setState(() => isLoading = true);

    final url = Uri.parse(
      'https://api.themoviedb.org/3/discover/movie?language=id-ID'
      '&sort_by=popularity.desc'
      '&with_genres=$selectedGenreId'
      '&vote_average.gte=${minRating.toStringAsFixed(1)}',
    );

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjQyOTgyOTNhODE0MWY3ZGU5OGIxZWY1OGJjNGZjYyIsIm5iZiI6MTc1MTQyMzM3MS4wNTQwMDAxLCJzdWIiOiI2ODY0OTk4YmMzZDljNzI0MTE0MTQ5N2YiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.GhpZXDCcWzzXdCaVnpt7Qs354gY9kCWaFBPUD3F8YWQ',
      'accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      setState(() {
        movies = results.map((movie) {
          return {
            "id": movie["id"],
            "title": movie["title"],
            "image": "https://image.tmdb.org/t/p/w500${movie["poster_path"]}",
            "genre": GenreService.getGenreName(movie["genre_ids"] ?? []),
            "rating": movie["vote_average"].toString(),
            "synopsis": movie["overview"] ?? "Tidak ada sinopsis"
          };
        }).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final genreMap = GenreService.genreMap;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: const Color(0xFF2F5249),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Color(0xFFE3DE61),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'BROWSE BY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF437057),
              ),
            ),
            const SizedBox(height: 16),

            // Genre Dropdown
            const Text('Genre'),
            DropdownButton<int>(
              value: selectedGenreId,
              isExpanded: true,
              hint: const Text("Pilih Genre"),
              items: genreMap.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedGenreId = val),
            ),

            const SizedBox(height: 16),

            // Rating Slider
            Text('Minimal Rating: ${minRating.toStringAsFixed(1)}'),
            Slider(
              min: 1.0,
              max: 10.0,
              divisions: 18,
              label: minRating.toStringAsFixed(1),
              value: minRating,
              activeColor: const Color(0xFFE3DE61),
              onChanged: (val) => setState(() => minRating = val),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: fetchFilteredMovies,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF437057),
                foregroundColor: Colors.white,
              ),
              child: const Text("Tampilkan Hasil"),
            ),

            const SizedBox(height: 24),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : movies.isEmpty
                    ? const Text("Belum ada hasil.")
                    : Column(
                        children: movies.map((movie) {
                          return ListTile(
                            leading: Image.network(movie["image"], width: 50),
                            title: Text(movie["title"]),
                            subtitle: Text("⭐ ${movie["rating"]} • ${movie["genre"]}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(movie: movie),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      )
          ],
        ),
      ),
    );
  }
}
