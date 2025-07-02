import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  DetailPage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie["title"],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[300], // MODUL 1: AppBar
      ),
      body: SingleChildScrollView( // MODUL 2: SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0), // MODUL 1: Padding
          child: Column( // MODUL 2: Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container( // Container gambar
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(movie["image"]),
                    fit: BoxFit.contain,  // ganti dari cover ke contain
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(height: 16), // MODUL 2: SizedBox
              Row( // MODUL 2: Row
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    movie["title"],
                    style: TextStyle( // MODUL 1: Text styling
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.movie, color: Colors.deepOrange), // MODUL 1: Icon
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Genre: ${movie["genre"]}",
                style: TextStyle(color: Colors.grey[700]),
              ),

              SizedBox(height: 4), // spasi kecil sebelum rating

              // Tambahan widget rating dengan icon bintang
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(
                    movie["rating"].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Text(
                "Synopsis",
                style: TextStyle( // MODUL 1: Text Styling
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[300],
                ),
              ),
              SizedBox(height: 8),
              Text(
                movie["synopsis"] ?? "No synopsis available.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify, // MODUL 1: Text alignment
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton( // MODUL 1: ElevatedButton
                  onPressed: () => Navigator.pop(context),
                  child: Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
