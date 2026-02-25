class ProviderDetailModel {
  final String id;
  final String name;
  final String avatar;
  final String coverImage;
  final String category;
  final String experience;
  final double rating;
  final int reviewCount;
  final String about;
  final String responseTime;
  final int missionsCount;
  final bool certified;
  final List<ServiceModel> services;
  final List<ReviewModel> reviews;

  ProviderDetailModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.coverImage,
    required this.category,
    required this.experience,
    required this.rating,
    required this.reviewCount,
    required this.about,
    required this.responseTime,
    required this.missionsCount,
    required this.certified,
    required this.services,
    required this.reviews,
  });
}

class ServiceModel {
  final String id;
  final String title;
  final String price;
  final String duration;

  ServiceModel({
    required this.id,
    required this.title,
    required this.price,
    required this.duration,
  });
}

class ReviewModel {
  final String id;
  final String userName;
  final String date;
  final double rating;
  final String comment;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.date,
    required this.rating,
    required this.comment,
  });
}
