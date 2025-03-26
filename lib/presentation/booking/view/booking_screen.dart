import 'package:flutter/material.dart';
import 'package:task2/presentation/booking/widgets/toggle_switch.dart';
import '../widgets/group_booking.dart';
import '../widgets/your_booking.dart';

class BookingScreen extends StatefulWidget {
  final bool fromSubmitButton;
  const BookingScreen({super.key, this.fromSubmitButton = false});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.fromSubmitButton ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: SafeArea(
        child: Column(
          children: [
            ToggleSwitch(
              selectedIndex: _selectedIndex,
              onToggle: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _selectedIndex == 0
                      ? const YourBookingsList()
                      : GroupBookingsList(),
            ),
          ],
        ),
      ),
    );
  }
}
