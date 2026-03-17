import 'package:flutter/widgets.dart';
import '../models/provider_detail_model.dart';

class MockProviderData {
  static Map<String, ProviderDetailModel> _getProviders(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final expUnit = lang == 'en' ? 'yrs exp.' : lang == 'ar' ? 'سنوات خبرة' : 'ans d\'exp.';
    final responseUnit = lang == 'en' ? 'min' : lang == 'ar' ? 'دقيقة' : 'min';

    return {
    '1': ProviderDetailModel(
      id: '1',
      name: lang == 'ar' ? 'أحمد المنصوري' : 'Ahmed El Mansouri',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: lang == 'en' ? 'Plumber Expert' : lang == 'ar' ? 'سباك خبير' : 'Plombier Expert',
      experience: '8 $expUnit',
      rating: 4.9,
      reviewCount: 150,
      about: lang == 'en' ? 'Passionate artisan specialized in emergency repairs and bathroom renovation. Quick intervention in Casablanca and surroundings. Neat work with a 10-year warranty.' 
           : lang == 'ar' ? 'حرفي شغوف متخصص في الإصلاحات الطارئة وتجديد الحمامات. تدخل سريع في الدار البيضاء وضواحيها. عمل متقن مع ضمان لمدة 10 سنوات.' 
           : 'Artisan passionné spécialisé dans le dépannage d\'urgence et la rénovation de salles de bain. Intervention rapide à Casablanca et environs. Travail soigné avec garantie décennale.',
      responseTime: '~15 $responseUnit',
      missionsCount: 840,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: lang == 'en' ? 'Leak Repair' : lang == 'ar' ? 'إصلاح تسرب المياه' : 'Réparation de fuite',
          price: '250 MAD/hr',
          duration: lang == 'en' ? '45-60 min' : lang == 'ar' ? '45-60 دقيقة' : '45-60 min',
        ),
        ServiceModel(
          id: 's2',
          title: lang == 'en' ? 'Faucet Installation' : lang == 'ar' ? 'تركيب صنبور' : 'Installation Robinetterie',
          price: '350 MAD/hr',
          duration: lang == 'en' ? '1h 30m' : lang == 'ar' ? 'ساعة ونصف' : '1h 30m',
        ),
        ServiceModel(
          id: 's3',
          title: lang == 'en' ? 'Drain Unblocking' : lang == 'ar' ? 'تسليك مجاري' : 'Débouchage Canalisation',
          price: '200 MAD/hr',
          duration: lang == 'en' ? '30 min' : lang == 'ar' ? '30 دقيقة' : '30 min',
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
      name: lang == 'ar' ? 'ياسين العمراني' : 'Yassine Amrani',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: lang == 'en' ? 'Plumber' : lang == 'ar' ? 'سباك' : 'Plombier',
      experience: '5 $expUnit',
      rating: 4.7,
      reviewCount: 98,
      about: lang == 'en' ? 'Qualified plumber for all your plumbing needs. Repairs, installations, and maintenance.' 
           : lang == 'ar' ? 'سباك مؤهل لجميع احتياجات السباكة الخاصة بك. إصلاحات وتركيبات وصيانة.' 
           : 'Plombier qualifié pour tous vos besoins en plomberie. Réparations, installations et entretien.',
      responseTime: '~25 $responseUnit',
      missionsCount: 450,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: lang == 'en' ? 'Faucet Repair' : lang == 'ar' ? 'إصلاح صنبور' : 'Réparation robinet',
          price: '120 MAD/hr',
          duration: lang == 'en' ? '30 min' : lang == 'ar' ? '30 دقيقة' : '30 min',
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
      name: lang == 'ar' ? 'عمر المنصوري' : 'Omar Mansouri',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: lang == 'en' ? 'Electrical Expert' : lang == 'ar' ? 'خبير كهرباء' : 'Expert Électricité',
      experience: '10 $expUnit',
      rating: 4.7,
      reviewCount: 210,
      about: lang == 'en' ? 'Certified electrician with 10 years of experience. Installation, troubleshooting, and electrical code compliance.' 
           : lang == 'ar' ? 'كهربائي معتمد بخبرة 10 سنوات. تركيب وإصلاح وامتثال للمعايير الكهربائية.' 
           : 'Électricien certifié avec 10 ans d\'expérience. Installation, dépannage et mise aux normes électriques.',
      responseTime: '~10 $responseUnit',
      missionsCount: 1200,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: lang == 'en' ? 'Electrical Troubleshooting' : lang == 'ar' ? 'إصلاح كهربائي' : 'Dépannage Électrique',
          price: '200 MAD/hr',
          duration: lang == 'en' ? '1h' : lang == 'ar' ? 'ساعة' : '1h',
        ),
        ServiceModel(
          id: 's2',
          title: lang == 'en' ? 'Panel Installation' : lang == 'ar' ? 'تركيب لوحة كهربائية' : 'Installation Tableau',
          price: '500 MAD/hr',
          duration: lang == 'en' ? '2-3h' : lang == 'ar' ? '2-3 ساعات' : '2-3h',
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
      name: lang == 'ar' ? 'عمر حسن' : 'Omar Hassan',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: lang == 'en' ? 'Leak Detection Specialist' : lang == 'ar' ? 'أخصائي كشف التسربات' : 'Spécialiste Détection Fuites',
      experience: '7 $expUnit',
      rating: 4.8,
      reviewCount: 142,
      about: lang == 'en' ? 'Expert in leak detection and repair. Modern equipment to locate hidden leaks.' 
           : lang == 'ar' ? 'خبير في كشف تسرب المياه وإصلاحه. معدات حديثة لتحديد التسربات المخفية.' 
           : 'Expert en détection et réparation de fuites. Équipement moderne pour localiser les fuites cachées.',
      responseTime: '~20 $responseUnit',
      missionsCount: 680,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: lang == 'en' ? 'Leak Detection' : lang == 'ar' ? 'كشف تسرب المياه' : 'Détection de fuite',
          price: '300 MAD/hr',
          duration: lang == 'en' ? '1-2h' : lang == 'ar' ? '1-2 ساعات' : '1-2h',
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
      name: lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: lang == 'en' ? 'Professional Cleaning' : lang == 'ar' ? 'تنظيف احترافي' : 'Ménage Professionnel',
      experience: '5 $expUnit',
      rating: 4.9,
      reviewCount: 85,
      about: lang == 'en' ? 'Professional cleaning service with eco-friendly products. Specialized in residential and office cleaning.' 
           : lang == 'ar' ? 'خدمة تنظيف احترافية بمنتجات صديقة للبيئة. متخصصون في تنظيف المنازل والمكاتب.' 
           : 'Service de ménage professionnel avec produits écologiques. Spécialisée dans le nettoyage résidentiel et bureaux.',
      responseTime: '~20 $responseUnit',
      missionsCount: 520,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: lang == 'en' ? 'Deep Cleaning' : lang == 'ar' ? 'تنظيف شامل' : 'Ménage Complet',
          price: '100 MAD/hr',
          duration: lang == 'en' ? '2-3h' : lang == 'ar' ? '2-3 ساعات' : '2-3h',
        ),
        ServiceModel(
          id: 's2',
          title: lang == 'en' ? 'Window Cleaning' : lang == 'ar' ? 'تنظيف النوافذ' : 'Nettoyage Vitres',
          price: '80 MAD/hr',
          duration: lang == 'en' ? '1h' : lang == 'ar' ? 'ساعة' : '1h',
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
      name: lang == 'ar' ? 'فاطمة الزهراء' : 'Fatima Zahra',
      avatar: 'assets/images/provider.png',
      coverImage: 'assets/images/provider.png',
      category: lang == 'en' ? 'Electrical Expert' : lang == 'ar' ? 'خبير كهرباء' : 'Expert Électricité',
      experience: '6 $expUnit',
      rating: 4.6,
      reviewCount: 67,
      about: lang == 'en' ? 'Experienced electrician. Electrical installation and repair for homes and apartments.' 
           : lang == 'ar' ? 'كهربائية ذات خبرة. تركيب وإصلاح كهربائي للمنازل والشقق.' 
           : 'Électricienne expérimentée. Installation et réparation électrique pour maisons et appartements.',
      responseTime: '~30 $responseUnit',
      missionsCount: 380,
      certified: true,
      services: [
        ServiceModel(
          id: 's1',
          title: lang == 'en' ? 'Electrical Installation' : lang == 'ar' ? 'تركيب كهربائي' : 'Installation électrique',
          price: '160 MAD/hr',
          duration: lang == 'en' ? '1-2h' : lang == 'ar' ? '1-2 ساعات' : '1-2h',
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
}

  static ProviderDetailModel? getProviderById(String id, BuildContext context) {
    return _getProviders(context)[id];
  }
}
