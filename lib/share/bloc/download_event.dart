part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class DownloadRequested extends DownloadEvent {
  const DownloadRequested(this.extension, this.path);

  const DownloadRequested.video(String path) : this('mp4', path);

  const DownloadRequested.gif(String path) : this('gif', path);

  final String extension;

  final String path;

  @override
  List<Object?> get props => [extension];
}
