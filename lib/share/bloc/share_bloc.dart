import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:photos_repository/photos_repository.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(const ShareState()) {
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

    try {
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

  // TODO(laura177): once final shareable asset is defined, call sharePhoto url methods.
  Future<ShareUrls> _shareImage() async {
    return const ShareUrls(
      explicitShareUrl: 'https://google.com',
      facebookShareUrl: 'https://facebook.com',
      twitterShareUrl: 'https://twitter.com',
    );
  }
}
