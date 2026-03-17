import '../domain/notification_repository.dart';
import '../model/notification_model.dart';

class MockNotificationRepository implements NotificationRepository {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Réservation confirmée',
      message: 'Votre réservation avec Yassine El Amrani est confirmée.',
      type: NotificationType.bookingConfirmed,
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'Nouveau message',
      message: 'Yassine El Amrani : "Bonjour, je suis en route vers votre domicile..."',
      type: NotificationType.message,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    AppNotification(
      id: '3',
      title: 'Promotion',
      message: 'Profitez de nos tarifs d\'été sur la plomberie et le jardinage.',
      type: NotificationType.promotion,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: 'Réservation annulée',
      message: 'L\'intervention prévue à 14h a été annulée par le prestataire.',
      type: NotificationType.cancelled,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    AppNotification(
      id: '5',
      title: 'Offre spéciale -20%',
      message: 'C\'est votre jour de chance ! -20% sur votre prochaine commande avec le...',
      type: NotificationType.promotion,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: '6',
      title: 'Mise à jour du profil',
      message: 'Votre adresse a été mise à jour avec succès dans votre espace client.',
      type: NotificationType.system,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AppNotification(
      id: '7',
      title: 'Parrainage réussi',
      message: 'Félicitations ! Votre ami a rejoint RilyBricoule. Vous avez gagné 10€ de...',
      type: NotificationType.referral,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ),
    AppNotification(
      id: '8',
      title: 'Rappel d\'intervention',
      message: 'N\'oubliez pas votre rendez-vous de demain à 09h00 pour la pose de...',
      type: NotificationType.reminder,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ),
  ];

  @override
  Future<List<AppNotification>> getNotifications([String? langCode]) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final lang = langCode ?? 'fr';
    
    // Create a new list with translated content
    return _notifications.map((n) {
      String title = n.title;
      String message = n.message;
      
      switch (n.id) {
        case '1':
          title = lang == 'en' ? 'Booking Confirmed' : lang == 'ar' ? 'تأكيد الحجز' : 'Réservation confirmée';
          message = lang == 'en' ? 'Your booking with Yassine El Amrani is confirmed.' 
                  : lang == 'ar' ? 'تم تأكيد حجزك مع ياسين العمراني.' 
                  : 'Votre réservation avec Yassine El Amrani est confirmée.';
          break;
        case '2':
          title = lang == 'en' ? 'New Message' : lang == 'ar' ? 'رسالة جديدة' : 'Nouveau message';
          message = lang == 'en' ? 'Yassine El Amrani: "Hello, I am on my way to your home..."' 
                  : lang == 'ar' ? 'ياسين العمراني: "مرحباً، أنا في طريقي إلى منزلك..."' 
                  : 'Yassine El Amrani : "Bonjour, je suis en route vers votre domicile..."';
          break;
        case '3':
          title = lang == 'en' ? 'Promotion' : lang == 'ar' ? 'عرض ترويجي' : 'Promotion';
          message = lang == 'en' ? 'Enjoy our summer rates on plumbing and gardening.' 
                  : lang == 'ar' ? 'استفد من أسعار الصيف للسباكة والبستنة.' 
                  : 'Profitez de nos tarifs d\'été sur la plomberie et le jardinage.';
          break;
        case '4':
          title = lang == 'en' ? 'Booking Cancelled' : lang == 'ar' ? 'إلغاء الحجز' : 'Réservation annulée';
          message = lang == 'en' ? 'The scheduled service at 14:00 was cancelled by the provider.' 
                  : lang == 'ar' ? 'تم إلغاء الخدمة المجدولة الساعة 14:00 من قبل مقدم الخدمة.' 
                  : 'L\'intervention prévue à 14h a été annulée par le prestataire.';
          break;
        case '5':
          title = lang == 'en' ? 'Special Offer -20%' : lang == 'ar' ? 'عرض خاص -20٪' : 'Offre spéciale -20%';
          message = lang == 'en' ? 'It\'s your lucky day! -20% on your next order with...' 
                  : lang == 'ar' ? 'إنه يوم حظك! 20٪ خصم على طلبك القادم مع...' 
                  : 'C\'est votre jour de chance ! -20% sur votre prochaine commande avec le...';
          break;
        case '6':
          title = lang == 'en' ? 'Profile Update' : lang == 'ar' ? 'تحديث الملف الشخصي' : 'Mise à jour du profil';
          message = lang == 'en' ? 'Your address has been successfully updated in your client space.' 
                  : lang == 'ar' ? 'تم تحديث عنوانك بنجاح في مساحتك الخاصة.' 
                  : 'Votre adresse a été mise à jour avec succès dans votre espace client.';
          break;
        case '7':
          title = lang == 'en' ? 'Successful Referral' : lang == 'ar' ? 'إحالة ناجحة' : 'Parrainage réussi';
          message = lang == 'en' ? 'Congratulations! Your friend joined RilyBricoule. You earned 10€...' 
                  : lang == 'ar' ? 'تهانينا! انضم صديقك إلى ريلي بريكول. لقد ربحت 10€...' 
                  : 'Félicitations ! Votre ami a rejoint RilyBricoule. Vous avez gagné 10€ de...';
          break;
        case '8':
          title = lang == 'en' ? 'Intervention Reminder' : lang == 'ar' ? 'تذكير بالخدمة' : 'Rappel d\'intervention';
          message = lang == 'en' ? 'Don\'t forget your appointment tomorrow at 09:00 for the installation...' 
                  : lang == 'ar' ? 'لا تنس موعدك غداً الساعة 09:00 لتركيب...' 
                  : 'N\'oubliez pas votre rendez-vous de demain à 09h00 pour la pose de...';
          break;
      }
      
      return AppNotification(
        id: n.id,
        title: title,
        message: message,
        type: n.type,
        createdAt: n.createdAt,
        isRead: n.isRead,
      );
    }).toList();
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var notification in _notifications) {
      notification.isRead = true;
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final notification = _notifications.firstWhere((n) => n.id == id);
    notification.isRead = true;
  }

  @override
  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _notifications.clear();
  }
}