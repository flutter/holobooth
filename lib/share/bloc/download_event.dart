part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class DownloadRequested extends DownloadEvent with AnalyticsEventMixin {
  const DownloadRequested(this.extension);

  const DownloadRequested.video() : this('mp4');

  const DownloadRequested.gif() : this('gif');

  final String extension;

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-download-$extension',
        label: 'download-$extension',
      );

  @override
  List<Object> get props => [extension];
}
