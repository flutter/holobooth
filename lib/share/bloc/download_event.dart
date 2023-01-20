part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class DownloadRequested extends DownloadEvent with AnalyticsEventMixin {
  const DownloadRequested(this.extension, this.path);

  const DownloadRequested.video(String path) : this('mp4', path);

  const DownloadRequested.gif(String path) : this('gif', path);

  final String extension;

  final String path;

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-download-$extension',
        label: 'download-$extension',
      );

  @override
  List<Object> get props => [extension];
}
