part of 'download_bloc.dart';

class DownloadEvent extends Equatable {
  const DownloadEvent(this.extension);

  final String extension;

  @override
  List<Object?> get props => [extension];
}
