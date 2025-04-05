import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aloha_funds/presentation/home_screen/model/report_model.dart';

class SaveCubit extends Cubit<List<ReportModel>> {
  final SupabaseClient _supabase = Supabase.instance.client;

  SaveCubit() : super([]) {
    _loadSavedReports();
  }

  Future<void> _loadSavedReports() async {
    final userId = _getUserId();
    if (userId == null) return;

    final response =
        await _supabase
            .from('users')
            .select('saved_reports')
            .eq('id', userId)
            .maybeSingle();

    if (response == null || response['saved_reports'] == null) {
      emit([]);
      return;
    }

    final List<dynamic> savedReportsJson = response['saved_reports'];
    final savedReports = ReportModel.fromJsonList(savedReportsJson);
    emit(savedReports);
  }

  Future<void> toggleSaveReport(ReportModel report) async {
    final userId = _getUserId();
    if (userId == null) return;

    final isAlreadySaved = state.any((r) => r.id == report.id);

    List<ReportModel> updatedReports;

    if (isAlreadySaved) {
      updatedReports = state.where((r) => r.id != report.id).toList();
    } else {
      updatedReports = [...state, report];
    }

    await _supabase
        .from('users')
        .update({
          'saved_reports': updatedReports.map((r) => r.toJson()).toList(),
        })
        .eq('id', userId);

    emit(updatedReports);
  }

  Future<void> removeReport(String reportId) async {
    final userId = _getUserId();
    if (userId == null) return;

    final updatedReports = state.where((r) => r.id != reportId).toList();

    await _supabase
        .from('users')
        .update({
          'saved_reports': updatedReports.map((r) => r.toJson()).toList(),
        })
        .eq('id', userId);

    emit(updatedReports);
  }

  String? _getUserId() {
    return _supabase.auth.currentUser?.id;
  }
}
