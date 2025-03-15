import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bookmark_screen/cubit/bookmark_cubit.dart';
import 'event_list_screen.dart';
import '../../../profile/user_profile.dart';
import '../../home_detail_screen/view/new_home_detail_screen.dart';
import '../../pick_location/pick_location_screen.dart';
import '../model/event_model.dart';

class NewHomeScreen extends StatefulWidget {
  // final bool showSnackbar;
  // final DateTime? selectedDate;
  // final String? selectedStartTime;
  // final String? selectedEndTime;
  const NewHomeScreen({
    super.key,
    // this.showSnackbar = false,
    // this.selectedDate,
    // this.selectedStartTime,
    // this.selectedEndTime,
  });

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final String _locationText = "Tap to set location";
  String? _yourLocation;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                child: Row(
                  children: [
                    Text(
                      'Find \nTrending Events',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: fontSize * 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset('assets/home_assets/bell.svg'),
                    SizedBox(width: padding),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(),
                          ),
                        );
                      },
                      child: SvgPicture.asset('assets/home_assets/user.svg'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                child: GestureDetector(
                  onTap: () async {
                    final selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickLocationScreen(),
                      ),
                    );

                    if (selectedLocation != null &&
                        selectedLocation is String) {
                      setState(() {
                        _yourLocation = selectedLocation;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: Color(0xff161C25),
                      borderRadius: BorderRadius.circular(42),
                      border: Border.all(color: Color(0xff202938)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(padding),
                          decoration: BoxDecoration(
                            color: Color(0xff2D3748),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xff202938),
                              width: 2,
                            ),
                          ),
                          child: SvgPicture.asset(
                            "assets/home_assets/pin.svg",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Location",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize * 0.9,
                                ),
                              ),
                              SizedBox(height: size.height * 0.001),
                              Text(
                                _yourLocation ?? _locationText,
                                style: GoogleFonts.urbanist(
                                  color: Colors.white60,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff3579DD),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              EventWidget(),
              NearEventsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class EventWidget extends StatefulWidget {
  const EventWidget({super.key});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: [
              Text(
                "Popular Events",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: fontSize * 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EventListScreen(
                            events: popularEvents,
                            title: "Popular Events",
                          ),
                    ),
                  );
                },
                child: Text(
                  "See All",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xff3579DD),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.02),
        SizedBox(
          height: size.height * 0.24,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              setState(() {});
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: padding),
              scrollDirection: Axis.horizontal,
              itemCount: popularEvents.length,
              itemBuilder: (context, index) {
                double parallaxOffset = 0;
                if (_scrollController.hasClients) {
                  final itemWidth = size.width * 0.7 + padding;
                  final itemPosition = itemWidth * index;
                  final distanceFromCenter =
                      itemPosition - _scrollController.offset;
                  parallaxOffset = distanceFromCenter * 0.1;
                }
                final event = popularEvents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewHomeDetailScreen(event: event),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: padding),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: size.height * 0.2,
                                width: size.width * 0.7,
                                child: OverflowBox(
                                  maxWidth: size.width * 0.9,
                                  maxHeight: size.height * 0.24,
                                  alignment: Alignment.center,
                                  child: Transform.translate(
                                    offset: Offset(parallaxOffset, 0),
                                    child: Hero(
                                      tag: 'image${event.title}',
                                      child: Image.asset(
                                        event.imageUrl,
                                        fit: BoxFit.cover,
                                        width: size.width * 0.9,
                                        height: size.height * 0.24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child:
                                  BlocBuilder<BookmarkCubit, List<EventModel>>(
                                    builder: (context, bookmarkedEvents) {
                                      final isBookmarked = bookmarkedEvents.any(
                                        (e) => e.title == event.title,
                                      );
                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<BookmarkCubit>()
                                              .toggleBookmark(event);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color: Colors.white,
                                            size: fontSize,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 5,
                              right: 5,
                              child: Container(
                                padding: EdgeInsets.all(padding * 0.5),
                                decoration: BoxDecoration(
                                  color: Color(0xff0A0A0A),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${event.title} with ${event.artist}',
                                      style: GoogleFonts.urbanist(
                                        color: Colors.white,
                                        fontSize: fontSize * 0.7,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.003),
                                    Row(
                                      children: [
                                        Text(
                                          event.date,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white70,
                                            fontSize: fontSize * 0.6,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          event.location,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white70,
                                            fontSize: fontSize * 0.6,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class NearEventsWidget extends StatefulWidget {
  const NearEventsWidget({super.key});

  @override
  State<NearEventsWidget> createState() => _NearEventsWidgetState();
}

class _NearEventsWidgetState extends State<NearEventsWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
          child: Row(
            children: [
              Text(
                "Events Near You",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: fontSize * 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EventListScreen(
                            events: nearEvents,
                            title: "Near Events",
                          ),
                    ),
                  );
                },
                child: Text(
                  "See All",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xff3579DD),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.02),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: nearEvents.length,
          itemBuilder: (context, index) {
            final event = nearEvents[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 0.4,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewHomeDetailScreen(event: event),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: padding * 0.4,
                    horizontal: padding * 0.4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff042455),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          event.imageUrl,
                          width: size.width * 0.2,
                          height: size.height * 0.09,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${event.title}: ',
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontSize: fontSize * 0.9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    event.artist,
                                    style: GoogleFonts.urbanist(
                                      color: Colors.white,
                                      fontSize: fontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              event.date,
                              style: GoogleFonts.urbanist(
                                color: Colors.white70,
                                fontSize: fontSize * 0.7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.height * 0.003),
                            Text(
                              event.location,
                              style: GoogleFonts.urbanist(
                                color: Colors.white70,
                                fontSize: fontSize * 0.7,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
