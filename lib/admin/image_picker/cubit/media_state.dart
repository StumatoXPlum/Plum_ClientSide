part of 'media_cubit.dart';

class MediaState extends Equatable {
  final List<File> mediaFiles;

  const MediaState({this.mediaFiles = const []});

  MediaState copyWith({List<File>? mediaFiles}) {
    return MediaState(mediaFiles: mediaFiles ?? this.mediaFiles);
  }

  @override
  List<Object> get props => [mediaFiles];
}
