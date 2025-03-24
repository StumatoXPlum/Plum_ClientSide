class TicketModel {
  final String id;
  final String eventId;
  final String title;
  final String date;
  final String time;
  final String location;
  final int quantity;
  final String userId;
  final double totalPrice;

  TicketModel({
    required this.id,
    required this.eventId,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.quantity,
    required this.userId,
    required this.totalPrice,
  });

  factory TicketModel.fromSupabase(Map<String, dynamic> data) {
    return TicketModel(
      id: data['id'] ?? '',
      eventId: data['event_id'] ?? '',
      title: data['title'] ?? 'Unknown',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      userId: data['user_id'] ?? '',
      totalPrice: (data['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "event_id": eventId,
      "title": title,
      "date": date,
      "time": time,
      "location": location,
      "quantity": quantity,
      "user_id": userId,
      "total_price": totalPrice,
    };
  }

  TicketModel copyWith({
    String? id,
    String? eventId,
    String? title,
    String? date,
    String? time,
    String? location,
    int? quantity,
    String? userId,
    double? totalPrice,
  }) {
    return TicketModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
