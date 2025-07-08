import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../model/review_model.dart';
import '../session/session_manager.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> movie;
  DetailPage({required this.movie});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<ReviewModel> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviews = await DBHelper().getReviewsByMovie(widget.movie['id']);
    setState(() {
      _reviews = reviews;
    });
  }

  Future<void> _showReviewDialog() async {
    final TextEditingController _reviewController = TextEditingController();
    double _currentRating = 7.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Tulis Review'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _reviewController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Tulis pendapat kamu tentang film ini...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("Rating: ${_currentRating.toStringAsFixed(1)}"),
                  Slider(
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    value: _currentRating,
                    label: _currentRating.toStringAsFixed(1),
                    activeColor: const Color(0xFFE3DE61),
                    onChanged: (val) {
                      setDialogState(() => _currentRating = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final userId = await SessionManager.getUserId();
                  if (userId == null) return;

                  if (_reviewController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review tidak boleh kosong')),
                    );
                    return;
                  }

                  final newReview = ReviewModel(
                    userId: userId,
                    movieId: widget.movie['id'],
                    title: widget.movie['title'],
                    posterUrl: widget.movie['image'],
                    review: _reviewController.text.trim(),
                    rating: _currentRating,
                  );

                  await DBHelper().insertReview(newReview);
                  Navigator.pop(context);
                  _loadReviews();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF437057),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Kirim'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(movie["title"], style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2F5249),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(movie["image"]),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Judul + Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      movie["title"],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F5249),
                      ),
                    ),
                  ),
                  const Icon(Icons.movie, color: Color(0xFF97B067)),
                ],
              ),
              const SizedBox(height: 8),

              // Genre
              Text(
                "Genre: ${movie["genre"]}",
                style: const TextStyle(color: Color(0xFF437057)),
              ),
              const SizedBox(height: 4),

              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFE3DE61)),
                  const SizedBox(width: 4),
                  Text(
                    movie["rating"].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F5249),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sinopsis
              const Text(
                "Synopsis",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF437057),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie["synopsis"] ?? "No synopsis available.",
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 24),

              // Tombol tulis review
              Center(
                child: ElevatedButton.icon(
                  onPressed: _showReviewDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text("Tulis Review"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF97B067),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Daftar review
              const Text(
                "Ulasan Pengguna",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F5249),
                ),
              ),
              const SizedBox(height: 12),

              _reviews.isEmpty
                  ? const Text("Belum ada review untuk film ini.")
                  : Column(
                      children: _reviews.map((r) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(r.review),
                            subtitle: Text("⭐ ${r.rating.toStringAsFixed(1)}"),
                            leading: const Icon(Icons.person, color: Color(0xFF97B067)),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
