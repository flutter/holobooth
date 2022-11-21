part of 'share_bloc.dart';

enum ShareStatus { initial, loading, success, failure }

enum ShareUrl { none, twitter, facebook }

extension ShareStatusX on ShareStatus {
  bool get isLoading => this == ShareStatus.loading;
  bool get isSuccess => this == ShareStatus.success;
  bool get isFailure => this == ShareStatus.failure;
}

class ShareState extends Equatable {
  const ShareState({
    this.facebookShareUrl = '',
    this.twitterShareUrl = '',
    this.shareUrl = ShareUrl.none,
    this.uploadStatus = ShareStatus.initial,
  });

  final String facebookShareUrl;
  final String twitterShareUrl;
  final ShareUrl shareUrl;
  final ShareStatus uploadStatus;

  @override
  List<Object?> get props => [
        facebookShareUrl,
        twitterShareUrl,
        shareUrl,
        uploadStatus,
      ];

  ShareState copyWith({
    String? facebookShareUrl,
    String? twitterShareUrl,
    ShareUrl? shareUrl,
    ShareStatus? uploadStatus,
  }) {
    return ShareState(
      facebookShareUrl: facebookShareUrl ?? this.facebookShareUrl,
      twitterShareUrl: twitterShareUrl ?? this.twitterShareUrl,
      shareUrl: shareUrl ?? this.shareUrl,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }
}
