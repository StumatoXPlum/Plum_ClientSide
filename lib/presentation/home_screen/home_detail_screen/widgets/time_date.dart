import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task2/presentation/home_screen/home_detail_screen/cubit/booking_cubit.dart';
import 'package:task2/presentation/home_screen/home_detail_screen/model/booking_model.dart';

Widget buildDateTimeView(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return BlocBuilder<BookingCubit, BookingState>(
    builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthNavigator(context, state),
          SizedBox(height: size.height * 0.02),
          _buildDateScroller(context, state),
          Expanded(child: _buildTimeList(context, state)),
        ],
      );
    },
  );
}

Widget _buildMonthNavigator(BuildContext context, BookingState state) {
  final Size size = MediaQuery.of(context).size;
  double padding = size.width * 0.03;
  double fontSize = size.width * 0.05;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding * 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => context.read<BookingCubit>().changeMonth(false),
        ),
        Text(
          DateFormat('MMMM yyyy').format(state.displayedMonth),
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: () => context.read<BookingCubit>().changeMonth(true),
        ),
      ],
    ),
  );
}

Widget _buildDateScroller(BuildContext context, BookingState state) {
  final dates = _generateDatesForMonth(state.displayedMonth);
  final Size size = MediaQuery.of(context).size;
  double padding = size.width * 0.03;
  double fontSize = size.width * 0.05;
  return SizedBox(
    height: size.height * 0.1,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final isSelected = _isSameDay(date, state.selectedDate);

        return Padding(
          padding: EdgeInsets.only(right: padding),
          child: GestureDetector(
            onTap: () => context.read<BookingCubit>().selectDate(date),
            child: Container(
              width: size.width * 0.20,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xff3579DD) : const Color(0xFF2A2B2E),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: GoogleFonts.urbanist(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: fontSize,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd').format(date),
                    style: GoogleFonts.urbanist(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildTimeList(BuildContext context, BookingState state) {
  final times = [
    '08:00',
    '10:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00',
    '20:00',
    '22:00',
  ];
  final Size size = MediaQuery.of(context).size;
  double padding = size.width * 0.03;
  double fontSize = size.width * 0.05;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: times.length,
      itemBuilder: (context, index) {
        final time = times[index];
        final isSelected = time == state.selectedTime;
        return GestureDetector(
          onTap: () => context.read<BookingCubit>().selectTime(time),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Color(0xff3579DD) : const Color(0xFF2A2B2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                time,
                style: GoogleFonts.urbanist(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

List<DateTime> _generateDatesForMonth(DateTime month) {
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  return List.generate(
    daysInMonth,
    (index) => DateTime(month.year, month.month, index + 1),
  );
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
