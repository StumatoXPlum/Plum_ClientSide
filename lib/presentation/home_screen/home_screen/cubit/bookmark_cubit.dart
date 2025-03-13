import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/event_model.dart';

class BookmarkCubit extends Cubit<List<EventModel>> {
  BookmarkCubit() : super([]);

  void toggleBookmark(EventModel event) {
    if (state.contains(event)) {
      emit(state.where((e) => e != event).toList());
    } else {
      emit([...state, event]);
    }
  }

  bool isBookmarked(EventModel event) {
    return state.contains(event);
  }
}
