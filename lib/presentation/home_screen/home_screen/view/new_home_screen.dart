import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/presentation/home_screen/home_screen/supabase/supabase_service.dart';
import 'package:task2/presentation/questions_screens/view/group_size_screen.dart';
import '../../../bookmark_screen/cubit/bookmark_cubit.dart';
import 'event_list_screen.dart';
import '../../../profile/user_profile.dart';
import '../../home_detail_screen/view/new_home_detail_screen.dart';
import '../../pick_location/pick_location_screen.dart';
import '../model/event_model.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen>
    with TickerProviderStateMixin {
  final SupabaseService _supabaseService = SupabaseService();
  List<EventModel> popularEvents = [];
  List<EventModel> nearbyEvents = [];
  late AnimationController controller;
  late Animation<Offset> slideAnimation;
  final String _locationText = "Tap to set location";
  String? _yourLocation;

  @override
  void initState() {
    super.initState();
    loadEvents();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    controller.forward();
  }

  Future<void> loadEvents() async {
    final fetchedEvents = await _supabaseService.fetchEvents();
    if (!mounted) return;
    setState(() {
      popularEvents =
          fetchedEvents
              .where(
                (event) =>
                    event.imageUrl.isNotEmpty &&
                    event.imageUrl.split('/').contains('popular'),
              )
              .toList();

      nearbyEvents =
          fetchedEvents
              .where(
                (event) =>
                    event.imageUrl.isNotEmpty &&
                    event.imageUrl.split('/').contains('nearby'),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                child: SlideTransition(
                  position: slideAnimation,
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
                            CupertinoPageRoute(
                              builder: (context) => UserProfile(),
                            ),
                          );
                        },
                        child: SvgPicture.asset('assets/home_assets/user.svg'),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                child: GestureDetector(
                  onTap: () async {
                    final selectedLocation = await Navigator.push(
                      context,
                      CupertinoPageRoute(
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
                  child: SlideTransition(
                    position: slideAnimation,
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
              ),
              SizedBox(height: size.height * 0.01),
              EventWidget(events: popularEvents),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding * 1.8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const GroupSizeScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(color: Color(0xff3579DD), width: 1),
                        left: BorderSide(color: Color(0xff3579DD), width: 1),
                        right: BorderSide(color: Color(0xff3579DD), width: 3),
                        bottom: BorderSide(color: Color(0xff3579DD), width: 3),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Do you want to book an exclusive group event?",
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: fontSize * 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "(Elevate your experience with a tailored event – choose your vibe!)",
                          style: GoogleFonts.urbanist(
                            color: Colors.white70,
                            fontSize: fontSize * 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              NearEventsWidget(events: nearbyEvents),
            ],
          ),
        ),
      ),
    );
  }
}

class EventWidget extends StatefulWidget {
  final List<EventModel> events;
  const EventWidget({super.key, required this.events});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController listController;
  late List<Animation<Offset>> itemAnimations = [];
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    itemAnimations = List.generate(
      widget.events.length,
      (index) => Tween(begin: Offset(-1, 0), end: Offset.zero).animate(
        CurvedAnimation(
          parent: listController,
          curve: Interval(
            index * (1 / widget.events.length),
            1,
            curve: Curves.easeIn,
          ),
        ),
      ),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: slideController, curve: Curves.easeIn));
    if (widget.events.isNotEmpty) {
      listController.forward();
      slideController.forward();
    }
  }

  @override
  void dispose() {
    listController.dispose();
    slideController.dispose();
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
                    CupertinoPageRoute(
                      builder:
                          (context) => EventListScreen(
                            events: widget.events,
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
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                if (widget.events.isEmpty) {
                  return const SizedBox();
                }
                double parallaxOffset = 0;
                if (_scrollController.hasClients) {
                  final itemWidth = size.width * 0.7 + padding;
                  final itemPosition = itemWidth * index;
                  final distanceFromCenter =
                      itemPosition - _scrollController.offset;
                  parallaxOffset = distanceFromCenter * 0.1;
                }
                final event = widget.events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => NewHomeDetailScreen(event: event),
                      ),
                    );
                  },
                  child: SlideTransition(
                    position:
                        itemAnimations.isNotEmpty
                            ? itemAnimations[index]
                            : AlwaysStoppedAnimation(Offset.zero),
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
                                      child: HeroMode(
                                        enabled: true,
                                        child: Hero(
                                          tag: 'image${event.title}',
                                          child: Image.network(
                                            event.imageUrl.isNotEmpty
                                                ? event.imageUrl
                                                : "https://tinyurl.com/2mwx6exe",
                                            fit: BoxFit.cover,
                                            width: size.width * 0.9,
                                            height: size.height * 0.24,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value:
                                                      loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              (loadingProgress
                                                                      .expectedTotalBytes ??
                                                                  1)
                                                          : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: BlocBuilder<
                                  BookmarkCubit,
                                  List<EventModel>
                                >(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
  final List<EventModel> events;
  const NearEventsWidget({super.key, required this.events});

  @override
  State<NearEventsWidget> createState() => _NearEventsWidgetState();
}

class _NearEventsWidgetState extends State<NearEventsWidget>
    with TickerProviderStateMixin {
  late AnimationController listController;
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;
  late List<Animation<Offset>> itemAnimations = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    itemAnimations = List.generate(
      widget.events.length,
      (index) => Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: listController,
          curve: Interval(
            index * (1 / (widget.events.isNotEmpty ? widget.events.length : 1)),
            1,
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: slideController, curve: Curves.easeIn));

    if (widget.events.isNotEmpty) {
      listController.forward();
      slideController.forward();
    }
  }

  @override
  void dispose() {
    listController.dispose();
    slideController.dispose();
    super.dispose();
  }

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
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder:
                          (context) => EventListScreen(
                            events: widget.events,
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
        SizedBox(height: size.height * 0.01),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.events.length,
          itemBuilder: (context, index) {
            if (widget.events.isEmpty) return const SizedBox();

            final event = widget.events[index];

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 0.4,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => NewHomeDetailScreen(event: event),
                    ),
                  );
                },
                child: SlideTransition(
                  position:
                      itemAnimations.isNotEmpty
                          ? itemAnimations[index]
                          : AlwaysStoppedAnimation(Offset.zero),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: padding * 0.4,
                      horizontal: padding * 0.4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff042455),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: HeroMode(
                            enabled: true,
                            child: Hero(
                              tag: 'image${event.title}',
                              child: Image.network(
                                event.imageUrl.isNotEmpty
                                    ? event.imageUrl
                                    : "https://tinyurl.com/2mwx6exe",
                                fit: BoxFit.cover,
                                width: size.width * 0.2,
                                height: size.height * 0.10,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(padding),
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white70,
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Flexible(
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
                                  Flexible(
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
              ),
            );
          },
        ),
      ],
    );
  }
}
