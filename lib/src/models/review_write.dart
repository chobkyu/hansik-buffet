class ReviewCreate {
  late int id;
  late String detailReview;
  late double userRating;

  ReviewCreate({
    required this.id,
    required this.detailReview,
    required this.userRating,
  });

  ReviewCreate.fromMap(Map<String, dynamic>? map) {
    id = map?['id'];
    detailReview = map?['detailReview'];
    userRating = map?['userRating'];
  }
}
