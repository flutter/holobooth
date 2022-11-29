import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:photos_repository/photos_repository.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({AsyncValueGetter<ShareUrls>? shareImage})
      : _shareImage = shareImage ?? _defaultShareImage,
        super(const ShareState()) {
    on<ShareTapped>(_onShareTapped);
  }

  final AsyncValueGetter<ShareUrls> _shareImage;

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

    try {
      emit(state.copyWith(shareStatus: ShareStatus.loading));

      final shareUrls = await _shareImage();

      emit(
        state.copyWith(
          shareStatus: ShareStatus.success,
          explicitShareUrl: shareUrls.explicitShareUrl,
          facebookShareUrl: shareUrls.facebookShareUrl,
          twitterShareUrl: shareUrls.twitterShareUrl,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          shareStatus: ShareStatus.failure,
        ),
      );
    }
  }

  // TODO(laura177): change to sharePhoto methods when we have final asset.
  static Future<ShareUrls> _defaultShareImage() async {
    return const ShareUrls(
      explicitShareUrl: 'https://google.com',
      facebookShareUrl: 'https://facebook.com',
      twitterShareUrl: 'https://twitter.com',
    );
  }
}
