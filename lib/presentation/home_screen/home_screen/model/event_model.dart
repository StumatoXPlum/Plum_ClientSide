class EventModel {
  final String title;
  final String imageUrl;
  final String date;
  final String location;
  final String? price;
  final String? description;
  final String? time;
  final String? address;

  const EventModel({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.location,
    this.price,
    this.description,
    this.time,
    this.address,
  });
}

final List<EventModel> events = [
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event1.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
    price: "AED 100-200",
    description: "Desi Night with Buddha & Harry",
    time: "9:00 PM - 3:00 AM",
    address: "Skydive Dubai Drop Zone - Dubai - United Arab Emirates",
  ),
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event2.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
    price: "AED 100-200",
    description: "Desi Night with Buddha & Harry",
    time: "9:00 PM - 3:00 AM",
    address: "Skydive Dubai Drop Zone - Dubai - United Arab Emirates",
  ),
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event3.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
    price: "AED 100-200",
    description: "Desi Night with Buddha & Harry",
    time: "9:00 PM - 3:00 AM",
    address: "Skydive Dubai Drop Zone - Dubai - United Arab Emirates",
  ),
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event4.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
    price: "AED 100-200",
    description: "Desi Night with Buddha & Harry",
    time: "9:00 PM - 3:00 AM",
    address: "Skydive Dubai Drop Zone - Dubai - United Arab Emirates",
  ),
];
