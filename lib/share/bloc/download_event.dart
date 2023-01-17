part of 'download_bloc.dart';

class DownloadEvent extends Equatable {
  const DownloadEvent(this.extension);

  const DownloadEvent.video() : this('mp4');

  const DownloadEvent.gif() : this('gif');

  final String extension;

  @override
  List<Object?> get props => [extension];
}
