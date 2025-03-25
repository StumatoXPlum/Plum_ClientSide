import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final String? email;
  final String? userId;

  AuthState({this.email, this.userId});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(email: null, userId: null));

  void setUserEmail(String? email) {
    emit(AuthState(email: email, userId: state.userId));
  }

  void setUserId(String? userId) {
    emit(AuthState(email: state.email, userId: userId));
  }
}
