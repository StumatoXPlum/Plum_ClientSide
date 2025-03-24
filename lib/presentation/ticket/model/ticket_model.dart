class TicketModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final int quantity;

  TicketModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.quantity,
  });

  factory TicketModel.fromSupabase(Map<String, dynamic> data) {
    return TicketModel(
      id: data['id'] ?? '',
      title: data['title'] ?? 'Unknown',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "date": date,
      "time": time,
      "location": location,
      "quantity": quantity,
    };
  }
}
