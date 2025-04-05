import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
part 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaState());

  void addMediaFiles(List<File> mediaFiles) {
    emit(state.copyWith(mediaFiles: [...state.mediaFiles, ...mediaFiles]));
  }

  void removeMediaFile(File file) {
    emit(
      state.copyWith(
        mediaFiles: state.mediaFiles.where((f) => f != file).toList(),
      ),
    );
  }

  void clearMedia() {
    emit(MediaState());
  }
}
