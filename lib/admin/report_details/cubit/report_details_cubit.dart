import 'package:flutter_bloc/flutter_bloc.dart';

class ReportDetailsState {
  final String title;
  final String subtitle;
  final String date;
  final String time;

  ReportDetailsState({
    this.title = '',
    this.subtitle = '',
    this.date = '',
    this.time = '',
  });

  ReportDetailsState copyWith({
    String? title,
    String? subtitle,
    String? date,
    String? time,
  }) {
    return ReportDetailsState(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}

class ReportDetailsCubit extends Cubit<ReportDetailsState> {
  ReportDetailsCubit() : super(ReportDetailsState());

  void updateTitle(String value) => emit(state.copyWith(title: value));
  void updateSubtitle(String value) => emit(state.copyWith(subtitle: value));
  void updateDate(String value) => emit(state.copyWith(date: value));
  void updateTime(String value) => emit(state.copyWith(time: value));

  void clear() => emit(ReportDetailsState());
}
