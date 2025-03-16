import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .add(ticket.toFirestore());

      print("Booking saved");
    } catch (e) {
      emit(TicketError("Failed to save booking: $e"));
    }
  }

  void _listenToBookings() {
    final userId = _getUserId();
    if (userId == null) {
      emit(TicketError("User not available"));
      return;
    }

    final bookingRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('bookings');

    bookingRef.snapshots().listen((snapshot) {
      final List<TicketModel> tickets =
          snapshot.docs.map((doc) => TicketModel.fromFirestore(doc)).toList();

      emit(TicketLoaded(tickets));
    });
  }

  String? _getUserId() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser?.uid;
    }
    return _supabase.auth.currentUser?.id;
  }
}
