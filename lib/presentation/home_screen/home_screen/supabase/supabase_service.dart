import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/presentation/home_screen/home_screen/model/event_model.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await _supabase.from('events').select();

      if (response.isEmpty) {
        print("No events found");
        return [];
      } else {
        print("Got events: ${response.length}");
      }

      List<EventModel> events =
          response.map((event) {
            String imagePath = event['imageUrl'];

            String fullImageUrl = _supabase.storage
                .from('images')
                .getPublicUrl(imagePath);

            return EventModel.fromJson({...event, 'imageUrl': fullImageUrl});
          }).toList();

      return events;
    } catch (e) {
      print("Fetch error: $e");
      return [];
    }
  }
}
