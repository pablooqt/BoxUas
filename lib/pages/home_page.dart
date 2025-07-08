import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/movie_search_delegate.dart';
import 'detail_page.dart';
import '../services/genre_service.dart';


class HomePage extends StatelessWidget {
  // Fetch data popular dari TMDb
  Future<List<Map<String, dynamic>>> fetchMovies() async {
  await GenreService.fetchGenres();

  final response = await http.get(
    Uri.parse('https://api.themoviedb.org/3/movie/popular?language=id-ID&page=1'),
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
    throw Exception("Gagal memuat data");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Popular',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color:  Color(0xFFE3DE61)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFFE3DE61)),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
             },
            ),
        ],
        backgroundColor: const Color(0xFF2F5249)
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat film"));
          } else {
            final movies = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('TOP This Week'),
                  buildHorizontalList(context, movies),
                  buildSectionTitle('Rating 9.0 ke atas'),
                  buildGridViewHighRating(context, movies),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, ),
      ),
    );
  }

  Widget buildHorizontalList(BuildContext context, List<Map<String, dynamic>> dataList) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          var movie = dataList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetailPage(movie: movie),
              ));
            },
            child: Container(
              width: 130,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(movie["image"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    movie["title"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildGridViewHighRating(BuildContext context, List<Map<String, dynamic>> allMovies) {
    final filtered = allMovies.where((movie) {
      final rating = double.tryParse(movie['rating']) ?? 0;
      return rating >= 9.0;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
        children: filtered.map((movie) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetailPage(movie: movie),
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      movie["image"],
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie["title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "⭐ ${movie["rating"]} • ${movie["genre"]}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
