import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/bloc/share_bloc.dart';

void main() {
  group('ShareBloc', () {
    test('initial state is ShareState', () {
      expect(ShareBloc().state, ShareState());
    });

    blocTest<ShareBloc, ShareState>(
      'tapping Twitter updates the shareStatus and shareUrl',
      build: ShareBloc.new,
      seed: () => ShareState(shareStatus: ShareStatus.loading),
      act: (bloc) => bloc.add(ShareTapped(shareUrl: ShareUrl.twitter)),
      expect: () => [
        ShareState(
          shareUrl: ShareUrl.twitter,
          shareStatus: ShareStatus.loading,
        )
      ],
    );

    blocTest<ShareBloc, ShareState>(
      'tapping Facebook updates the shareStatus and shareUrl',
      build: ShareBloc.new,
      seed: () => ShareState(shareStatus: ShareStatus.loading),
      act: (bloc) => bloc.add(ShareTapped(shareUrl: ShareUrl.facebook)),
      expect: () => [
        ShareState(
          shareUrl: ShareUrl.facebook,
          shareStatus: ShareStatus.loading,
        )
      ],
    );
  });
}
