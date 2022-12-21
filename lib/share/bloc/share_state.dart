part of 'share_bloc.dart';

enum ShareStatus { initial, loading, success }

enum ShareUrl { none, twitter, facebook }

extension ShareStatusX on ShareStatus {
  bool get isLoading => this == ShareStatus.loading;
  bool get isSuccess => this == ShareStatus.success;
}

class ShareState extends Equatable {
  const ShareState({
    this.facebookShareUrl = '',
    this.twitterShareUrl = '',
    this.explicitShareUrl = '',
    this.shareUrl = ShareUrl.none,
    this.shareStatus = ShareStatus.initial,
    this.firstFrame,
  });

  final String facebookShareUrl;
  final String twitterShareUrl;
  final String explicitShareUrl;
  final ShareUrl shareUrl;
  final ShareStatus shareStatus;
  final ByteData? firstFrame;

  @override
  List<Object?> get props => [
        facebookShareUrl,
        twitterShareUrl,
        explicitShareUrl,
        shareUrl,
        shareStatus,
        firstFrame,
      ];

  ShareState copyWith({
    String? facebookShareUrl,
    String? twitterShareUrl,
    String? explicitShareUrl,
    ShareUrl? shareUrl,
    ShareStatus? shareStatus,
    ByteData? firstFrame,
  }) {
    return ShareState(
      facebookShareUrl: facebookShareUrl ?? this.facebookShareUrl,
      twitterShareUrl: twitterShareUrl ?? this.twitterShareUrl,
      explicitShareUrl: explicitShareUrl ?? this.explicitShareUrl,
      shareUrl: shareUrl ?? this.shareUrl,
      shareStatus: shareStatus ?? this.shareStatus,
      firstFrame: firstFrame ?? this.firstFrame,
    );
  }
}
