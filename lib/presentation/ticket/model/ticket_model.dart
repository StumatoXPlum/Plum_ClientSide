class TicketModel {
  final String title;
  final String date;
  final String time;
  final String location;
  final int quantity;
  final String id;

  TicketModel({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.quantity,
    required this.id,
  });

  factory TicketModel.empty() {
    return TicketModel(
      title: "",
      date: "",
      time: "",
      location: "",
      quantity: 0,
      id: "",
    );
  }
}
