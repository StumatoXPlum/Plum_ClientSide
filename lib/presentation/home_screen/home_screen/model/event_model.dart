class EventModel {
  final String title;
  final String imageUrl;
  final String date;
  final String location;

  const EventModel({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.location,
  });
}

final List<EventModel> events = [
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event1.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
  ),
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event2.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
  ),
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event3.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
  ),
  EventModel(
    title: 'Desi Night with Buddha & Harry',
    imageUrl: 'assets/home_assets/events_assets/event4.png',
    date: 'December, 1 2024',
    location: 'Zero Gravity Dubai',
  ),
];
