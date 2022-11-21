part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class ShareViewLoaded extends ShareEvent {
  const ShareViewLoaded();
}

class ShareOnTwitterTapped extends ShareEvent {
  const ShareOnTwitterTapped();
}

class ShareOnFacebookTapped extends ShareEvent {
  const ShareOnFacebookTapped();
}
