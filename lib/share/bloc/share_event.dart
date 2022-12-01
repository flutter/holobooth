part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class ShareViewLoaded extends ShareEvent {
  const ShareViewLoaded();
}

class ShareTapped extends ShareEvent {
  const ShareTapped({required this.shareUrl});

  final ShareUrl shareUrl;

  @override
  List<Object> get props => [shareUrl];
}
