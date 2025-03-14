import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home_screen/home_screen/model/event_model.dart';

class BookmarkCubit extends Cubit<List<EventModel>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BookmarkCubit() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()!.containsKey('bookmarks')) {
      List<dynamic> bookmarkList = doc['bookmarks'];
      List<EventModel> loadedBookmarks =
          bookmarkList.map((e) => EventModel.fromJson(e)).toList();
      emit(loadedBookmarks); 
    }
  }

  Future<void> toggleBookmark(EventModel event) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final currentBookmarks = List<EventModel>.from(state);

    if (currentBookmarks.any((e) => e.title == event.title)) {
      currentBookmarks.removeWhere((e) => e.title == event.title);
    } else {
      currentBookmarks.add(event);
    }

    emit(currentBookmarks);

    await _firestore.collection('users').doc(user.uid).update({
      'bookmarks': currentBookmarks.map((e) => e.toJson()).toList(),
    });
  }
}
