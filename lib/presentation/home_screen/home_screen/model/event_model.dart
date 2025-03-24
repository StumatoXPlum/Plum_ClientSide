class EventModel {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String date;
  final String location;
  final String price;
  final String description;
  final String time;
  final String address;

  const EventModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.price,
    required this.description,
    required this.time,
    required this.address,
  });

  factory EventModel.empty() {
    return EventModel(
      id: "",
      title: "",
      artist: "",
      imageUrl: "",
      date: "",
      location: "",
      price: "",
      description: "",
      time: "",
      address: "",
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      price: (json['price'] ?? '').toString(),
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'price': price,
      'description': description,
      'time': time,
      'address': address,
    };
  }
}
