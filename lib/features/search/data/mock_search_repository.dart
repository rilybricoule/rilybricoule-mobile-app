import '../../home/models/provider_model.dart';
import '../domain/search_repository.dart';

class MockSearchRepository implements SearchRepository {
  // Mock data
  List<ProviderModel> _getAllProviders(String lang) {
    return [
    ProviderModel(
      id: '1',
      name: lang == 'ar' ? 'أحمد المنصوري' : 'Ahmed El Mansouri',
      service: lang == 'en' ? 'Master Plumber • 8 years exp.' : lang == 'ar' ? 'سباك محترف • خبرة 8 سنوات' : 'Master Plomberie • 8 years exp.',
      imageUrl: 'assets/images/provider.png',
      rating: 4.9,
      reviewCount: 156,
      distance: 1.2,
      priceLabel: '',
      price: '150 MAD/hr',
      priceValue: 150.0,
      isVerified: true,
      isAvailable: true,
      categoryId: '1',
      activeJobsCount: 2,
    ),
    ProviderModel(
      id: '2',
      name: lang == 'ar' ? 'ياسين العمراني' : 'Yassine Amrani',
      service: lang == 'en' ? 'Plumbing' : lang == 'ar' ? 'سباكة' : 'Plomberie',
      imageUrl: 'assets/images/provider.png',
      rating: 4.7,
      reviewCount: 98,
      distance: 2.5,
      priceLabel: '',
      price: '120 MAD/hr',
      priceValue: 120.0,
      isVerified: true,
      isAvailable: true,
      categoryId: '1',
      activeJobsCount: 1,
    ),
    ProviderModel(
      id: '3',
      name: lang == 'ar' ? 'كريم بولحروز' : 'Karim Boulahrouz',
      service: lang == 'en' ? 'DIY Expert' : lang == 'ar' ? 'خبير أعمال يدوية' : 'Bricolage Expert',
      imageUrl: 'assets/images/provider.png',
      rating: 4.5,
      reviewCount: 203,
      distance: 0.8,
      priceLabel: '',
      price: '200 MAD/hr',
      priceValue: 200.0,
      isVerified: false,
      isAvailable: false,
      categoryId: '5',
      activeJobsCount: 7,
    ),
    ProviderModel(
      id: '4',
      name: lang == 'ar' ? 'عمر حسن' : 'Omar Hassan',
      service: lang == 'en' ? 'Leak Detection' : lang == 'ar' ? 'كشف التسربات' : 'Spécialiste Détection Fuites',
      imageUrl: 'assets/images/provider.png',
      rating: 4.8,
      reviewCount: 142,
      distance: 4.1,
      priceLabel: '',
      price: '180 MAD/hr',
      priceValue: 180.0,
      isVerified: true,
      isAvailable: true,
      categoryId: '1',
      activeJobsCount: 0,
    ),
    ProviderModel(
      id: '5',
      name: lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
      service: lang == 'en' ? 'Professional Cleaning' : lang == 'ar' ? 'تنظيف احترافي' : 'Ménage Professionnel',
      imageUrl: 'assets/images/provider.png',
      rating: 4.9,
      reviewCount: 85,
      distance: 1.1,
      priceLabel: '',
      price: '100 MAD/hr',
      priceValue: 100.0,
      isVerified: true,
      isAvailable: true,
      categoryId: '3',
      activeJobsCount: 3,
    ),
    ProviderModel(
      id: '6',
      name: lang == 'ar' ? 'فاطمة الزهراء' : 'Fatima Zahra',
      service: lang == 'en' ? 'Electrical Expert' : lang == 'ar' ? 'خبير كهرباء' : 'Expert Électricité',
      imageUrl: 'assets/images/provider.png',
      rating: 4.6,
      reviewCount: 67,
      distance: 3.2,
      priceLabel: '',
      price: '160 MAD/hr',
      priceValue: 160.0,
      isVerified: true,
      isAvailable: true,
      categoryId: '2',
      activeJobsCount: 4,
    ),
  ];
  }

  @override
  Future<List<ProviderModel>> searchProviders({
    required String query,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? maxDistance,
    bool? availableNow,
    String? categoryId,
    String? langCode,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final lang = langCode ?? 'fr';
    List<ProviderModel> results = List.from(_getAllProviders(lang));

    // Filter by category ID
    if (categoryId != null && categoryId.isNotEmpty) {
      results = results.where((p) => p.categoryId == categoryId).toList();
    }

    // Filter by query
    if (query.isNotEmpty) {
      results = results.where((provider) {
        return provider.name.toLowerCase().contains(query.toLowerCase()) ||
            provider.service.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    // Filter by rating
    if (minRating != null) {
      results = results.where((p) => p.rating >= minRating).toList();
    }

    // Filter by distance
    if (maxDistance != null) {
      results = results.where((p) => p.distance <= maxDistance).toList();
    }

    // Filter by price (extract number from price string)
    if (minPrice != null || maxPrice != null) {
      results = results.where((p) {
        final priceStr = p.price.replaceAll(RegExp(r'[^0-9]'), '');
        if (priceStr.isEmpty) return true;
        final price = double.tryParse(priceStr) ?? 0;
        if (minPrice != null && price < minPrice) return false;
        if (maxPrice != null && price > maxPrice) return false;
        return true;
      }).toList();
    }

    // Filter by availability (mock: exclude id '3')
    if (availableNow == true) {
      results = results.where((p) => p.id != '3').toList();
    }

    return results;
  }
}
