import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await _supabase
        .from('questions')
        .select('*')
        .order('order', ascending: true);
    if (response.isNotEmpty) {
      return response;
    } else {
      throw Exception('No questions found');
    }
  }

  Future<List<Map<String, dynamic>>> fetchOptions(String questionId) async {
    final response = await _supabase
        .from('options')
        .select('*')
        .eq('question_id', questionId);
    return response.isNotEmpty ? response : [];
  }

  Future<List<Map<String, dynamic>>> fetchQuestionsWithOptions() async {
    final response = await _supabase
        .from('questions')
        .select('*, options(*)')
        .order('order', ascending: true);
    if (response.isNotEmpty) {
      return response;
    } else {
      throw Exception('No questions found');
    }
  }
}
