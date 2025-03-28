import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInfoState {
  final String fullName;
  final String contactNumber;
  final String email;

  PersonalInfoState({
    this.fullName = '',
    this.contactNumber = '',
    this.email = '',
  });

  PersonalInfoState copyWith({
    String? fullName,
    String? contactNumber,
    String? email,
  }) {
    return PersonalInfoState(
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
    );
  }
}

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(PersonalInfoState());

  void updatePersonalInfo({
    required String fullName,
    required String contactNumber,
    required String email,
  }) {
    emit(
      state.copyWith(
        fullName: fullName,
        contactNumber: contactNumber,
        email: email,
      ),
    );
  }
}
