class BookingDraft {
  final String providerId;
  final String serviceId;
  final DateTime? date;
  final String? time;
  final String? note;
  final String? address;

  BookingDraft({
    required this.providerId,
    required this.serviceId,
    this.date,
    this.time,
    this.note,
    this.address,
  });

  BookingDraft copyWith({
    String? providerId,
    String? serviceId,
    DateTime? date,
    String? time,
    String? note,
    String? address,
  }) {
    return BookingDraft(
      providerId: providerId ?? this.providerId,
      serviceId: serviceId ?? this.serviceId,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note ?? this.note,
      address: address ?? this.address,
    );
  }
}
