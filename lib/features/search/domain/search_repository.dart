import '../../home/models/provider_model.dart';

abstract class SearchRepository {
  Future<List<ProviderModel>> searchProviders({
    required String query,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? maxDistance,
    bool? availableNow,
    String? categoryId,
    String? langCode,
  });
}
