import 'package:equatable/equatable.dart';
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
  final TicketModel ticket;

  const TicketLoaded(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object> get props => [message];
}

class TicketCubit extends Cubit<TicketState> {
  TicketCubit() : super(TicketInitial());

  void setTicket(TicketModel ticket) {
    emit(TicketLoaded(ticket));
  }
}
