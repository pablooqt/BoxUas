import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../model/review_model.dart';
import '../session/session_manager.dart';

class MyReviewsPage extends StatefulWidget {
  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  List<ReviewModel> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadMyReviews();
  }

  Future<void> _loadMyReviews() async {
    final userId = await SessionManager.getUserId();
    if (userId == null) return;

    final reviews = await DBHelper().getReviewsByUser(userId);
    setState(() => _reviews = reviews);
  }

  void _showEditDialog(ReviewModel review) {
    final TextEditingController reviewController =
        TextEditingController(text: review.review);
    double updatedRating = review.rating.clamp(0.0, 10.0);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Review'),
          content: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Review',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Rating: '),
                        Expanded(
                          child: Slider(
                            value: updatedRating,
                            onChanged: (val) {
                              setStateDialog(() {
                                updatedRating = val;
                              });
                            },
                            divisions: 10,
                            min: 0,
                            max: 10,
                            label: updatedRating.toStringAsFixed(1),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updated = ReviewModel(
                  id: review.id,
                  userId: review.userId,
                  movieId: review.movieId,
                  title: review.title,
                  posterUrl: review.posterUrl,
                  review: reviewController.text,
                  rating: updatedRating,
                );

                await DBHelper().updateReview(updated);
                Navigator.pop(context);
                _loadMyReviews();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deleteReview(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Review'),
        content: const Text('Yakin ingin menghapus review ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper().deleteReview(id);
      _loadMyReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('My Reviews'),
        backgroundColor: const Color(0xFF2F5249),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Color(0xFFE3DE61),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _reviews.isEmpty
          ? const Center(child: Text("Kamu belum menulis review."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review.posterUrl,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      review.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F5249),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          review.review,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFE3DE61), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              review.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Color(0xFF437057),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () => _showEditDialog(review),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteReview(review.id!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
