class ReviewModel {
  final int? id;
  final int userId;
  final int movieId;
  final String title;
  final String posterUrl;
  final String review;
  final double rating;

  ReviewModel({
    this.id,
    required this.userId,
    required this.movieId,
    required this.title,
    required this.posterUrl,
    required this.review,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'movie_id': movieId,
      'title': title,
      'poster_url': posterUrl,
      'review': review,
      'rating': rating,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      userId: map['user_id'],
      movieId: map['movie_id'],
      title: map['title'],
      posterUrl: map['poster_url'],
      review: map['review'],
      rating: map['rating'],
    );
  }
}
