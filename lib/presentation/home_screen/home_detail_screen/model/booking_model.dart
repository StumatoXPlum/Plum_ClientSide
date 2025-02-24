import 'package:equatable/equatable.dart';

enum BookingView { dateTime, package, drink }

class BookingState extends Equatable {
  final BookingView currentView;
  final DateTime selectedDate;
  final String? selectedTime;
  final DateTime displayedMonth;

  const BookingState({
    required this.currentView,
    required this.selectedDate,
    this.selectedTime,
    required this.displayedMonth,
  });

  BookingState copyWith({
    BookingView? currentView,
    DateTime? selectedDate,
    String? selectedTime,
    DateTime? displayedMonth,
  }) {
    return BookingState(
      currentView: currentView ?? this.currentView,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      displayedMonth: displayedMonth ?? this.displayedMonth,
    );
  }

  @override
  List<Object?> get props => [
    currentView,
    selectedDate,
    selectedTime,
    displayedMonth,
  ];
}
