class EventModel {
  final String title;
  final String artist;
  final String imageUrl;
  final String date;
  final String location;
  final String? price;
  final String? description;
  final String? time;
  final String? address;

  const EventModel({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.date,
    required this.location,
    this.price,
    this.description,
    this.time,
    this.address,
  });

  factory EventModel.empty() {
    return EventModel(
      title: "",
      date: "",
      time: "",
      location: "",
      address: null,
      price: null,
      imageUrl: "",
      artist: "",
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      price: json['price'],
      description: json['description'],
      time: json['time'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

final List<EventModel> popularEvents = [
  EventModel(
    title: 'Bollywood Beats Night',
    artist: 'DJ Raj & MC Sid',
    imageUrl: 'assets/home_assets/events_assets/event1.png',
    date: 'December 10, 2024',
    location: 'White Dubai',
    price: "AED 150",
    description:
        "Experience an electrifying night with DJ Raj and MC Sid as they bring Bollywood beats to life at White Dubai. Get ready for an unforgettable night of music and dance!",
    time: "10:00 PM - 4:00 AM",
    address: "Meydan Racecourse Grandstand - Dubai - UAE",
  ),
  EventModel(
    title: 'EDM Madness',
    artist: 'DJ Tiesto & Armin Van Buuren',
    imageUrl: 'assets/home_assets/events_assets/event2.png',
    date: 'December 15, 2024',
    location: 'Coca-Cola Arena',
    price: "AED 300",
    description:
        "Join two of the world's biggest EDM artists, DJ Tiesto and Armin Van Buuren, for an explosive night of non-stop electronic dance music.",
    time: "8:00 PM - 2:00 AM",
    address: "City Walk - Al Wasl - Dubai - UAE",
  ),
  EventModel(
    title: 'Retro Bollywood Night',
    artist: 'Udit Narayan & Alka Yagnik',
    imageUrl: 'assets/home_assets/events_assets/event3.png',
    date: 'December 20, 2024',
    location: 'Dubai Opera',
    price: "AED 260",
    description:
        "Relive the golden era of Bollywood music with legendary singers Udit Narayan and Alka Yagnik performing their timeless hits live.",
    time: "7:00 PM - 11:00 PM",
    address: "Sheikh Mohammed bin Rashid Blvd - Downtown Dubai - UAE",
  ),
  EventModel(
    title: 'Hip-Hop Takeover',
    artist: 'Travis Scott & Lil Uzi Vert',
    imageUrl: 'assets/home_assets/events_assets/event4.png',
    date: 'December 25, 2024',
    location: 'Atlantis The Palm',
    price: "AED 450",
    description:
        "The biggest hip-hop event of the year featuring global superstars Travis Scott and Lil Uzi Vert performing live at Atlantis.",
    time: "9:00 PM - 3:00 AM",
    address: "Atlantis, Crescent Rd - The Palm Jumeirah - Dubai - UAE",
  ),
];

final List<EventModel> nearEvents = [
  EventModel(
    title: 'Desi Sundowner',
    artist: 'DJ Shadow & Akcent',
    imageUrl: 'assets/home_assets/near_events/near1.png',
    date: 'December 5, 2024',
    location: 'Beach by FIVE',
    price: "AED 220",
    description:
        "Enjoy a breathtaking sunset with an incredible mix of Bollywood and international beats by DJ Shadow and Akcent at Beach by FIVE.",
    time: "4:00 PM - 11:00 PM",
    address: "FIVE Palm Jumeirah - Dubai - UAE",
  ),
  EventModel(
    title: 'Neon Night Party',
    artist: 'DJ Snake',
    imageUrl: 'assets/home_assets/near_events/near2.png',
    date: 'December 12, 2024',
    location: 'SOHO Garden',
    price: "AED 250",
    description:
        "Glow under the neon lights and dance to the electrifying beats of DJ Snake at SOHO Garden. Get your glow sticks ready!",
    time: "9:00 PM - 3:00 AM",
    address: "Meydan Grandstand - Nad Al Sheba - Dubai - UAE",
  ),
  EventModel(
    title: 'Sufi Night',
    artist: 'Kailash Kher',
    imageUrl: 'assets/home_assets/near_events/near3.png',
    date: 'December 18, 2024',
    location: 'Jumeirah Beach Hotel',
    price: "AED 180",
    description:
        "An enchanting night of soulful Sufi music with the mesmerizing voice of Kailash Kher at the Jumeirah Beach Hotel.",
    time: "7:30 PM - 11:30 PM",
    address: "Jumeirah Beach Hotel - Umm Suqeim - Dubai - UAE",
  ),
  EventModel(
    title: 'NYE Countdown Bash',
    artist: 'Calvin Harris & Martin Garrix',
    imageUrl: 'assets/home_assets/near_events/near4.png',
    date: 'December 31, 2024',
    location: 'Burj Park Downtown',
    price: "AED 500",
    description:
        "Ring in the new year with a spectacular musical night featuring Calvin Harris and Martin Garrix at the iconic Burj Park!",
    time: "9:00 PM - 2:00 AM",
    address: "Burj Park - Downtown Dubai - UAE",
  ),
];
