import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/bloc/share_bloc.dart';

void main() {
  group('ShareBloc', () {
    test('initial state is ShareState', () {
      expect(ShareBloc(videoPath: '').state, ShareState());
    });

    blocTest<ShareBloc, ShareState>(
      'if status is already loaded successfully it will not reload',
      build: () => ShareBloc(videoPath: ''),
      seed: () => ShareState(shareStatus: ShareStatus.success),
      act: (bloc) => bloc.add(ShareTapped(shareUrl: ShareUrl.facebook)),
      expect: () => [
        ShareState(
          shareUrl: ShareUrl.facebook,
          shareStatus: ShareStatus.success,
        ),
      ],
    );

    group('on sharing to Twitter', () {
      blocTest<ShareBloc, ShareState>(
        'tapping Twitter updates the shareStatus and shareUrl',
        build: () => ShareBloc(videoPath: ''),
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
        'shareStatus emits success after sharing to Twitter',
        build: () => ShareBloc(videoPath: ''),
        act: (bloc) => bloc.add(ShareTapped(shareUrl: ShareUrl.twitter)),
        expect: () => [
          ShareState(shareUrl: ShareUrl.twitter),
          ShareState(
            shareStatus: ShareStatus.loading,
            shareUrl: ShareUrl.twitter,
          ),
          ShareState(
            shareStatus: ShareStatus.success,
            shareUrl: ShareUrl.twitter,
            explicitShareUrl: 'https://google.com',
            facebookShareUrl: 'https://facebook.com',
            twitterShareUrl: 'https://twitter.com',
          )
        ],
      );
    });

    group('on sharing to Facebook', () {
      blocTest<ShareBloc, ShareState>(
        'tapping Facebook updates the shareStatus and shareUrl',
        build: () => ShareBloc(videoPath: ''),
        seed: () => ShareState(shareStatus: ShareStatus.loading),
        act: (bloc) => bloc.add(ShareTapped(shareUrl: ShareUrl.facebook)),
        expect: () => [
          ShareState(
            shareUrl: ShareUrl.facebook,
            shareStatus: ShareStatus.loading,
          )
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'shareStatus emits success after sharing to Facebook',
        build: () => ShareBloc(videoPath: ''),
        act: (bloc) => bloc.add(ShareTapped(shareUrl: ShareUrl.facebook)),
        expect: () => [
          ShareState(shareUrl: ShareUrl.facebook),
          ShareState(
            shareStatus: ShareStatus.loading,
            shareUrl: ShareUrl.facebook,
          ),
          ShareState(
            shareStatus: ShareStatus.success,
            shareUrl: ShareUrl.facebook,
            explicitShareUrl: 'https://google.com',
            facebookShareUrl: 'https://facebook.com',
            twitterShareUrl: 'https://twitter.com',
          )
        ],
      );
    });
  });
}
