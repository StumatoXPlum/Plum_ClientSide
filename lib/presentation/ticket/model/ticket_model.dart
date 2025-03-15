import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory TicketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return TicketModel(
      id: doc.id,
      title: data?['title'] ?? 'Unknown',
      date: data?['date'] ?? '',
      time: data?['time'] ?? '',
      location: data?['location'] ?? '',
      quantity: data?['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "date": date,
      "time": time,
      "location": location,
      "quantity": quantity,
    };
  }
}
