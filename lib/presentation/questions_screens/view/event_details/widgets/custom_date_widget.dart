import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DatePickerService {
  static Future<void> selectDate({
    required BuildContext context,
    required TextEditingController controller,
    required ValueChanged<String> onDateChanged,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: const Color(0xFF1E2330),
      builder: (context) {
        return _CustomDatePicker(
          onDateSelected: (selectedDate) {
            String formattedDate =
                "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
            controller.text = formattedDate;
            onDateChanged(formattedDate);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _CustomDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const _CustomDatePicker({required this.onDateSelected});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<_CustomDatePicker> {
  late DateTime _selectedDate;
  late List<String> _months;
  late List<int> _years;
  late int _selectedMonthIndex;
  late int _selectedYear;
  late int _selectedDay;

  final _monthController = FixedExtentScrollController();
  final _dayController = FixedExtentScrollController();
  final _yearController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedMonthIndex = _selectedDate.month - 1;
    _selectedYear = _selectedDate.year;
    _selectedDay = _selectedDate.day;

    _months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    _years = List.generate(11, (index) => _selectedDate.year + index);
    _monthController.jumpToItem(_selectedMonthIndex);
    _yearController.jumpToItem(0);
    _dayController.jumpToItem(_selectedDay - 1);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = _getDaysInMonth(_selectedYear, _selectedMonthIndex + 1);
    List<int> days = List.generate(daysInMonth, (index) => index + 1);
    final Size size = MediaQuery.of(context).size;
    double fontSize = size.width * 0.05;
    double padding = size.width * 0.03;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: size.width * 0.03,
        right: size.width * 0.03,
        top: size.height * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Date',
            style: GoogleFonts.urbanist(
              fontSize: fontSize * 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWheelPicker(
                controller: _monthController,
                items: _months,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedMonthIndex = index;
                    int daysInNewMonth = _getDaysInMonth(
                      _selectedYear,
                      index + 1,
                    );
                    _selectedDay =
                        _selectedDay > daysInNewMonth
                            ? daysInNewMonth
                            : _selectedDay;
                  });
                },
                initialItem: _selectedMonthIndex,
              ),
              SizedBox(width: size.width * 0.03),
              _buildWheelPicker(
                controller: _dayController,
                items: days.map((day) => day.toString()).toList(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedDay = days[index];
                  });
                },
                initialItem: _selectedDay - 1,
              ),
              SizedBox(width: size.width * 0.03),
              _buildWheelPicker(
                controller: _yearController,
                items: _years.map((year) => year.toString()).toList(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedYear = _years[index];
                    int daysInNewMonth = _getDaysInMonth(
                      _selectedYear,
                      _selectedMonthIndex + 1,
                    );
                    _selectedDay =
                        _selectedDay > daysInNewMonth
                            ? daysInNewMonth
                            : _selectedDay;
                  });
                },
                initialItem: _years.indexOf(_selectedYear),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.urbanist(
                    color: Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              ElevatedButton(
                onPressed: () {
                  widget.onDateSelected(
                    DateTime(
                      _selectedYear,
                      _selectedMonthIndex + 1,
                      _selectedDay,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3579DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: padding * 2,
                    vertical: padding,
                  ),
                ),
                child: Text(
                  'Select',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildWheelPicker({
    required FixedExtentScrollController controller,
    required List<String> items,
    required ValueChanged<int> onSelectedItemChanged,
    required int initialItem,
  }) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.25,
      height: size.height * 0.3,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3340),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListWheelScrollView(
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.5,
        offAxisFraction: 0,
        useMagnifier: true,
        magnification: 1.3,
        itemExtent: 50,
        onSelectedItemChanged: onSelectedItemChanged,
        children: List.generate(
          items.length,
          (index) => Center(
            child: Text(
              items[index],
              style: GoogleFonts.urbanist(
                fontSize: index == initialItem ? 24 : 18,
                color: index == initialItem ? Colors.white : Colors.white54,
                fontWeight:
                    index == initialItem ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onDateChanged;

  const CustomDateField({
    super.key,
    required this.label,
    required this.controller,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double fontSize = size.width * 0.05;
    return TextField(
      controller: controller,
      readOnly: true,
      onTap:
          () => DatePickerService.selectDate(
            context: context,
            controller: controller,
            onDateChanged: onDateChanged,
          ),
      style: GoogleFonts.urbanist(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(
          color: Colors.white70,
          fontSize: fontSize * 0.9,
        ),
        filled: true,
        fillColor: const Color(0xff161C25),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff202938)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF3579DD)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
