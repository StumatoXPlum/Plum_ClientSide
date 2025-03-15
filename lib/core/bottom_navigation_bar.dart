import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task2/presentation/bookmark_screen/view/bookmark_screen.dart';
import '../presentation/booking/booking_screen.dart';
import '../presentation/home_screen/home_screen/view/new_home_screen.dart';
import '../presentation/music_screen/view/music_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialIndex;
  final bool showSnackbar;
  final DateTime? selectedDate;
  final String? selectedStartTime;
  final String? selectedEndTime;

  const BottomNavScreen({
    super.key,
    this.initialIndex = 0,
    this.showSnackbar = false,
    this.selectedDate,
    this.selectedStartTime,
    this.selectedEndTime,
  });

  @override
  BottomNavScreenState createState() => BottomNavScreenState();
}

class BottomNavScreenState extends State<BottomNavScreen> {
  late int _selectedIndex;
  late List<Widget> _screens;

  final List<String> _iconPaths = [
    "assets/home_assets/home.svg",
    "assets/home_assets/saved.svg",
    "assets/home_assets/booking.svg",
    "assets/home_assets/music.svg",
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _screens = [
      // HomeScreen(
      // showSnackbar: widget.showSnackbar,
      // selectedDate: widget.selectedDate,
      // selectedStartTime: widget.selectedStartTime,
      // selectedEndTime: widget.selectedEndTime,
      // ),
      NewHomeScreen(),
      BookmarkScreen(),
      BookingScreen(),
      MusicScreen(),
    ];

  //   Future.delayed(Duration.zero, () {
  //     if (widget.showSnackbar &&
  //         _selectedIndex == 0 &&
  //         widget.selectedDate != null &&
  //         widget.selectedStartTime != null &&
  //         widget.selectedEndTime != null) {
  //       _showSnackbar();
  //     }
  //   });
  // }

  // void _showSnackbar() {
  //   final String message = getFormattedDateTime(widget.selectedDate!);
  //   final Size size = MediaQuery.of(context).size;
  //   double fontSize = size.width * 0.04;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       backgroundColor: const Color(0xff3579DD),
  //       content: Row(
  //         children: [
  //           SvgPicture.asset(
  //             "assets/home_assets/barcode.svg",
  //             height: size.height * 0.03,
  //           ),
  //           SizedBox(width: size.width * 0.01),
  //           Text(
  //             message,
  //             style: GoogleFonts.urbanist(
  //               fontSize: fontSize * 0.8,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

  // String getFormattedDateTime(DateTime dateTime) {
  //   String formattedTime = DateFormat("h:mm a").format(dateTime);
  //   String dayWithSuffix = "${dateTime.day}${getDaySuffix(dateTime.day)}";
  //   String formattedDate = DateFormat("MMM").format(dateTime);
  //   return "You have a booking at $formattedTime $dayWithSuffix $formattedDate";
  // }

  // String getDaySuffix(int day) {
  //   if (day >= 11 && day <= 13) return "th";
  //   switch (day % 10) {
  //     case 1:
  //       return "st";
  //     case 2:
  //       return "nd";
  //     case 3:
  //       return "rd";
  //     default:
  //       return "th";
  //   }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff090D14),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xff3579DD),
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          items: List.generate(4, (index) {
            return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _iconPaths[index],
                colorFilter: ColorFilter.mode(
                  _selectedIndex == index ? Color(0xff3579DD) : Colors.white,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              label: ['Home', 'Saved', 'Booking', 'Music'][index],
            );
          }),
        ),
      ),
    );
  }
}
