import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/ticket_model.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final List<TicketModel> tickets;

  const TicketLoaded(this.tickets);

  @override
  List<Object> get props => [tickets];
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object> get props => [message];
}

class TicketCubit extends Cubit<TicketState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  TicketCubit() : super(TicketInitial()) {
    _listenToBookings();
  }

  Future<void> setTicket(TicketModel ticket) async {
    final userId = _getUserId();
    if (userId == null) {
      emit(TicketError("User not available"));
      return;
    }

    try {
      await _supabase.from('bookings').insert(ticket.toJson());
      print("Booking saved to Supabase");
    } catch (e) {
      emit(TicketError("Failed to save booking: \$e"));
    }
  }

  void _listenToBookings() {
    final userId = _getUserId();
    if (userId == null) {
      emit(TicketError("User not available"));
      return;
    }

    _supabase.from('bookings').stream(primaryKey: ['id']).listen((data) {
      final List<TicketModel> tickets =
          data.map((json) => TicketModel.fromSupabase(json)).toList();
      emit(TicketLoaded(tickets));
    });
  }

  String? _getUserId() {
    return _supabase.auth.currentUser?.id;
  }
}
