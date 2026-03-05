class ProviderFilter {
  final String? categoryId;
  final String? subCategoryId;
  final double? minRating;
  final double? maxDistanceKm;
  final bool? availableNow;
  final double? minPrice;
  final double? maxPrice;

  const ProviderFilter({
    this.categoryId,
    this.subCategoryId,
    this.minRating,
    this.maxDistanceKm,
    this.availableNow,
    this.minPrice,
    this.maxPrice,
  });
}
