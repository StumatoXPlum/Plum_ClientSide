class NearEventsModel {
  final String title;
  final String artist;
  final String date;
  final String location;
  final String image;

  NearEventsModel({
    required this.title,
    required this.artist,
    required this.date,
    required this.location,
    required this.image,
  });
}

final List<NearEventsModel> nearEvents = [
  NearEventsModel(
    title: "Rhythm and Beats",
    artist: "Drake",
    date: "April 30, 2025",
    location: "Barclays Center, Brooklyn, NY",
    image: 'assets/home_assets/near_events/near1.png',
  ),
  NearEventsModel(
    title: "Electric Dreams",
    artist: "Dua Lipa",
    date: "December 25, 2025",
    location: "Staples Center, Los Angeles, CA",
    image: 'assets/home_assets/near_events/near2.png',
  ),
  NearEventsModel(
    title: "Dance and Groove",
    artist: "Harry Styles",
    date: "June 20, 2025",
    location: "United Center, Chicago, IL",
    image: 'assets/home_assets/near_events/near3.png',
  ),
  NearEventsModel(
    title: "Melody and Harmony",
    artist: "Lana Del Rey",
    date: "May 12, 2025",
    location: "Red Rocks Amphitheatre, Morrison, CO",
    image: 'assets/home_assets/near_events/near4.png',
  ),
  NearEventsModel(
    title: "Twist and Shout",
    artist: "The Beatles",
    date: "October 5, 2025",
    location: "Wembley Stadium, London, UK",
    image: 'assets/home_assets/near_events/near5.png',
  ),
];
