import '../models/provider_detail_model.dart';

class MockProviderData {
  static final Map<String, ProviderDetailModel> _providers = {
    '1': ProviderDetailModel(
      id: '1',
      name: 'Ahmed El Mansouri',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: 'Plombier Expert',
      experience: '8 ans d\'exp.',
      rating: 4.9,
      reviewCount: 150,
      about: 'Artisan passionné spécialisé dans le dépannage d\'urgence et la rénovation de salles de bain. Intervention rapide à Casablanca et environs. Travail soigné avec garantie décennale.',
      responseTime: '~15 min',
      missionsCount: 840,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: 'Réparation de fuite',
          price: '250 MAD',
          duration: '45-60 min',
        ),
        ServiceModel(
          id: 's2',
          title: 'Installation Robinetterie',
          price: '350 MAD',
          duration: '1h 30m',
        ),
        ServiceModel(
          id: 's3',
          title: 'Débouchage Canalisation',
          price: '150 MAD',
          duration: '30 min',
        ),
      ],
      reviews: [
        ReviewModel(
          id: 'r1',
          userName: 'Yassine A.',
          date: 'Il y a 2 jours',
          rating: 5.0,
          comment: 'Excellent travail ! Ahmed est intervenu en moins de 20 minutes pour une fuite importante dans ma cuisine. Très professionnel et honnête sur les prix.',
        ),
        ReviewModel(
          id: 'r2',
          userName: 'Meryem B.',
          date: 'Il y a 1 semaine',
          rating: 5.0,
          comment: 'Installation de robinetterie parfaite. Il a même pris le temps de nettoyer après son passage. Je recommande vivement ses services.',
        ),
      ],
    ),
    '2': ProviderDetailModel(
      id: '2',
      name: 'Yassine Amrani',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: 'Plombier',
      experience: '5 ans d\'exp.',
      rating: 4.7,
      reviewCount: 98,
      about: 'Plombier qualifié pour tous vos besoins en plomberie. Réparations, installations et entretien.',
      responseTime: '~25 min',
      missionsCount: 450,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: 'Réparation robinet',
          price: '120 MAD',
          duration: '30 min',
        ),
      ],
      reviews: [
        ReviewModel(
          id: 'r1',
          userName: 'Hassan K.',
          date: 'Il y a 5 jours',
          rating: 5.0,
          comment: 'Très bon service.',
        ),
      ],
    ),
    '3': ProviderDetailModel(
      id: '3',
      name: 'Omar Mansouri',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: 'Expert Électricité',
      experience: '10 ans d\'exp.',
      rating: 4.7,
      reviewCount: 210,
      about: 'Électricien certifié avec 10 ans d\'expérience. Installation, dépannage et mise aux normes électriques.',
      responseTime: '~10 min',
      missionsCount: 1200,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: 'Dépannage Électrique',
          price: '200 MAD',
          duration: '1h',
        ),
        ServiceModel(
          id: 's2',
          title: 'Installation Tableau',
          price: '500 MAD',
          duration: '2-3h',
        ),
      ],
      reviews: [
        ReviewModel(
          id: 'r1',
          userName: 'Fatima Z.',
          date: 'Il y a 1 jour',
          rating: 5.0,
          comment: 'Très compétent et rapide.',
        ),
      ],
    ),
    '4': ProviderDetailModel(
      id: '4',
      name: 'Omar Hassan',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: 'Spécialiste Détection Fuites',
      experience: '7 ans d\'exp.',
      rating: 4.8,
      reviewCount: 142,
      about: 'Expert en détection et réparation de fuites. Équipement moderne pour localiser les fuites cachées.',
      responseTime: '~20 min',
      missionsCount: 680,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: 'Détection de fuite',
          price: '300 MAD',
          duration: '1-2h',
        ),
      ],
      reviews: [
        ReviewModel(
          id: 'r1',
          userName: 'Amina L.',
          date: 'Il y a 3 jours',
          rating: 5.0,
          comment: 'A trouvé la fuite rapidement.',
        ),
      ],
    ),
    '5': ProviderDetailModel(
      id: '5',
      name: 'Sarah Benjelloun',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: 'Ménage Professionnel',
      experience: '5 ans d\'exp.',
      rating: 4.9,
      reviewCount: 85,
      about: 'Service de ménage professionnel avec produits écologiques. Spécialisée dans le nettoyage résidentiel et bureaux.',
      responseTime: '~20 min',
      missionsCount: 520,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: 'Ménage Complet',
          price: '100 MAD/h',
          duration: '2-3h',
        ),
        ServiceModel(
          id: 's2',
          title: 'Nettoyage Vitres',
          price: '80 MAD',
          duration: '1h',
        ),
      ],
      reviews: [
        ReviewModel(
          id: 'r1',
          userName: 'Karim M.',
          date: 'Il y a 3 jours',
          rating: 5.0,
          comment: 'Service impeccable, très professionnelle.',
        ),
      ],
    ),
    '6': ProviderDetailModel(
      id: '6',
      name: 'Fatima Zahra',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: 'Expert Électricité',
      experience: '6 ans d\'exp.',
      rating: 4.6,
      reviewCount: 67,
      about: 'Électricienne expérimentée. Installation et réparation électrique pour maisons et appartements.',
      responseTime: '~30 min',
      missionsCount: 380,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: 'Installation électrique',
          price: '160 MAD',
          duration: '1-2h',
        ),
      ],
      reviews: [
        ReviewModel(
          id: 'r1',
          userName: 'Said B.',
          date: 'Il y a 1 semaine',
          rating: 4.0,
          comment: 'Bon travail.',
        ),
      ],
    ),
  };

  static ProviderDetailModel? getProviderById(String id) {
    return _providers[id];
  }
}
