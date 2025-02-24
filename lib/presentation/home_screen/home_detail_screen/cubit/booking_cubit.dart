import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/presentation/home_screen/home_detail_screen/model/booking_model.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit()
    : super(
        BookingState(
          currentView: BookingView.dateTime,
          selectedDate: DateTime.now(),
          displayedMonth: DateTime.now(),
        ),
      );

  void changeView(BookingView view) {
    emit(state.copyWith(currentView: view));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: time));
  }

  void changeMonth(bool next) {
    final newMonth = DateTime(
      state.displayedMonth.year,
      state.displayedMonth.month + (next ? 1 : -1),
      1,
    );
    emit(state.copyWith(displayedMonth: newMonth));
  }
}
