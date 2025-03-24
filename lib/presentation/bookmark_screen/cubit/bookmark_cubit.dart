import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../home_screen/home_screen/model/event_model.dart';

class BookmarkCubit extends Cubit<List<EventModel>> {
  final SupabaseClient _supabase = Supabase.instance.client;

  BookmarkCubit() : super([]) {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final userId = _getUserId();
    if (userId == null) return;

    final response =
        await _supabase
            .from('users')
            .select('bookmark_ids')
            .eq('id', userId)
            .single();

    if (response['bookmark_ids'] is List) {
      List<String> bookmarkIds = List<String>.from(response['bookmark_ids']);

      if (bookmarkIds.isEmpty) {
        emit([]);
        return;
      }

      final eventsResponse = await _supabase
          .from('events')
          .select('*')
          .filter('id', 'in', '(${bookmarkIds.join(',')})');

      List<EventModel> loadedBookmarks =
          eventsResponse.map<EventModel>((e) {
            String imageUrl =
                e['imageurl'] ?? '';

            if (!imageUrl.startsWith('http')) {
              final bucketUrl = _supabase.storage
                  .from('images')
                  .getPublicUrl(imageUrl);
              imageUrl = bucketUrl;
            }

            return EventModel.fromJson({...e, 'imageurl': imageUrl});
          }).toList();

      emit(loadedBookmarks);
    }
  }

  Future<void> toggleBookmark(EventModel event) async {
    final userId = _getUserId();
    if (userId == null) return;

    final response =
        await _supabase
            .from('users')
            .select('bookmark_ids')
            .eq('id', userId)
            .single();

    List<String> bookmarkIds =
        response['bookmark_ids'] != null
            ? List<String>.from(response['bookmark_ids'])
            : [];

    if (bookmarkIds.contains(event.id)) {
      bookmarkIds.remove(event.id);
    } else {
      bookmarkIds.add(event.id);
    }

    emit([...state.where((e) => e.id != event.id)]);

    await _supabase
        .from('users')
        .update({'bookmark_ids': bookmarkIds})
        .eq('id', userId);

    _loadBookmarks();
  }

  String? _getUserId() {
    return _supabase.auth.currentUser?.id;
  }
}
