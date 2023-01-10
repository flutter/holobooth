import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({Uint8List? thumbnail, required String videoPath})
      : super(
          ShareState(
            thumbnail: thumbnail,
            videoPath: videoPath,
          ),
        ) {
    on<ShareTapped>(_onShareTapped);
  }

  Future<void> _onShareTapped(
    ShareTapped event,
    Emitter<ShareState> emit,
  ) async {
    emit(
      state.copyWith(
        shareUrl: event.shareUrl,
      ),
    );

    if (state.shareStatus.isLoading) return;
    if (state.shareStatus.isSuccess) return;

    emit(state.copyWith(shareStatus: ShareStatus.loading));

    // TODO(laura177): change to sharePhoto methods when we have final asset.

    emit(
      state.copyWith(
        shareStatus: ShareStatus.success,
        explicitShareUrl: 'https://google.com',
        facebookShareUrl: 'https://facebook.com',
        twitterShareUrl: 'https://twitter.com',
      ),
    );
  }
}
