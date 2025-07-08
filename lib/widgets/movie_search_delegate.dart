import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/detail_page.dart';
import '../services/genre_service.dart';

class MovieSearchDelegate extends SearchDelegate {
  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    await GenreService.fetchGenres();

    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/search/movie?query=$query&language=id-ID&page=1'),
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjQyOTgyOTNhODE0MWY3ZGU5OGIxZWY1OGJjNGZjYyIsIm5iZiI6MTc1MTQyMzM3MS4wNTQwMDAxLCJzdWIiOiI2ODY0OTk4YmMzZDljNzI0MTE0MTQ5N2YiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.GhpZXDCcWzzXdCaVnpt7Qs354gY9kCWaFBPUD3F8YWQ',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List results = jsonData['results'];

      return results.map((movie) {
        return {
          "id": movie["id"],
          "title": movie["title"],
          "image": "https://image.tmdb.org/t/p/w500${movie["poster_path"]}",
          "genre": GenreService.getGenreName(movie["genre_ids"] ?? []),
          "rating": movie["vote_average"].toString(),
          "synopsis": movie["overview"] ?? "Tidak ada sinopsis"
        };
      }).toList();
    } else {
      throw Exception("Gagal mencari film");
    }
  }

  @override
  String? get searchFieldLabel => 'Cari film...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text("Ketik judul film..."),
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ditemukan"));
        }

        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              leading: Image.network(
                movie["image"],
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(movie["title"]),
              subtitle: Text("⭐ ${movie["rating"]} • ${movie["genre"]}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(movie: movie)),
                );
              },
            );
          },
        );
      },
    );
  }
}
