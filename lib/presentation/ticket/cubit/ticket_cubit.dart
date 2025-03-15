import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  TicketCubit() : super(TicketInitial()) {
    _listenToBookings();
  }

  Future<void> setTicket(TicketModel ticket) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .add(ticket.toFirestore());

      print("Booking saved");
    } catch (e) {
      emit(TicketError("failed to save:$e"));
    }
  }

  void _listenToBookings() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(TicketError("User not availabe"));
      return;
    }

    final bookingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookings');

    bookingRef.snapshots().listen((snapshot) {
      final List<TicketModel> tickets =
          snapshot.docs.map((doc) => TicketModel.fromFirestore(doc)).toList();

      emit(TicketLoaded(tickets));
    });
  }
}
