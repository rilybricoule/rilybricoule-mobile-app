enum PaymentMethodType { card, cash }

class PaymentMethod {
  final PaymentMethodType type;
  final String title;
  final String? subtitle;
  final String icon;

  const PaymentMethod({
    required this.type,
    required this.title,
    this.subtitle,
    required this.icon,
  });

  static const card = PaymentMethod(
    type: PaymentMethodType.card,
    title: 'Carte bancaire (CMI)',
    subtitle: 'Visa, Mastercard',
    icon: 'card',
  );

  static const cash = PaymentMethod(
    type: PaymentMethodType.cash,
    title: 'Paiement en espèces',
    subtitle: 'Payez directement le bricoleur',
    icon: 'cash',
  );

  static const List<PaymentMethod> all = [card, cash];
}
