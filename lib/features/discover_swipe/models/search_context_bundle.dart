class SearchContextBundle {
  final String? query;
  final String? categoryId;
  final String? subCategoryId;
  final double? minRating;
  final double? maxDistanceKm;
  final bool? availableNow;
  final double? minPrice;
  final double? maxPrice;
  final double? userLatitude;
  final double? userLongitude;

  const SearchContextBundle({
    this.query,
    this.categoryId,
    this.subCategoryId,
    this.minRating,
    this.maxDistanceKm,
    this.availableNow,
    this.minPrice,
    this.maxPrice,
    this.userLatitude,
    this.userLongitude,
  });
}
