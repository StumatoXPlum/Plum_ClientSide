import 'package:aloha_funds/presentation/home_screen/view/home_screen.dart';
import 'package:aloha_funds/presentation/profile_screen/profile_screen.dart';
import 'package:aloha_funds/presentation/saved_screen/view/saved_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialIndex;

  const BottomNavScreen({super.key, this.initialIndex = 0});

  @override
  BottomNavScreenState createState() => BottomNavScreenState();
}

class BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late List<Widget> _screens;
  late AnimationController controller;
  late Animation<Offset> slideAnimation;

  final List<String> _iconPaths = [
    "assets/home_assets/home.svg",
    "assets/home_assets/saved.svg",
    "assets/home_assets/profile.svg",
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _screens = [HomeScreen(), SavedScreen(), ProfileScreen()];

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(controller);
    controller.forward();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F265E),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SlideTransition(
          position: slideAnimation,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xff1F265E),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xff8E97FD),
            unselectedItemColor: Colors.white,
            showUnselectedLabels: true,
            items: List.generate(3, (index) {
              return BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _iconPaths[index],
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == index ? Color(0xff8E97FD) : Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                label: ['Home', 'Saved', 'Profile'][index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
