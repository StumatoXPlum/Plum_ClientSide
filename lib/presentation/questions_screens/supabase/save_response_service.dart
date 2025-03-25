import 'package:supabase_flutter/supabase_flutter.dart';

class SaveResponseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> saveResponses({
    String? userId,
    required String fullName,
    required String contactNumber,
    required String email,
    required String occasion,
    required String numberOfGuests,
    required String? preferredDate,
    required String? alternateDate,
    required String startTime,
    required String endTime,
    required bool exclusiveVenue,
    required String preferredVenueType,
    required String desiredLocationOrArea,
    required String vibeOfEvent,
    required String eventDescription,
    required double budgetAmount,
    required String additionalRequirements,
  }) async {
    try {
      String? currentUserId = userId;

      if (currentUserId == null || currentUserId.isEmpty) {
        final user = _supabase.auth.currentUser;
        if (user == null) {
          throw Exception('No authenticated user found. Please log in.');
        }
        currentUserId = user.id;
      }
      await _supabase.from('responses').insert({
        'user_id': currentUserId,
        'full_name': fullName,
        'contact_number': contactNumber,
        'email': email,
        'occasion': occasion,
        'number_of_guests': numberOfGuests,
        'preferred_date': preferredDate,
        'alternate_date': alternateDate,
        'start_time': startTime,
        'end_time': endTime,
        'exclusive_venue': exclusiveVenue,
        'preferred_venue_type': preferredVenueType,
        'desired_location_or_area': desiredLocationOrArea,
        'vibe_of_event': vibeOfEvent,
        'event_description': eventDescription,
        'budget_amount': budgetAmount,
        'additional_requirements': additionalRequirements,
      });
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
