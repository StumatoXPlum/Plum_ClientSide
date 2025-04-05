import 'package:flutter_bloc/flutter_bloc.dart';

class DescriptionCubit extends Cubit<String> {
  DescriptionCubit() : super("");

  void updateDescription(String value) => emit(value);
}
