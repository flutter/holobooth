import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PrimarySelectionView extends StatefulWidget {
  const PrimarySelectionView({
    super.key,
    this.initialIndex = 0,
    this.collapsed = false,
  });

  final int initialIndex;
  final bool collapsed;

  @visibleForTesting
  static const primaryTabBarViewKey = Key('primaryTabBarView');

  @override
  State<PrimarySelectionView> createState() => _PrimarySelectionViewState();
}

class _PrimarySelectionViewState extends State<PrimarySelectionView>
    with TickerProviderStateMixin, AudioPlayerMixin {
  late final TabController _tabController;
  late int _indexSelected;

  @override
  String get audioAssetPath => Assets.audio.tabClick;

  @override
  void initState() {
    super.initState();
    _indexSelected = widget.initialIndex;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _indexSelected,
    );
    // This instance of [TabController] does not get updated
    // so we need to explicitly add a listener to get the reference
    // to the selected index
    _tabController.addListener(() {
      setState(() {
        _indexSelected = _tabController.index;
      });
    });
    loadAudio();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(12).copyWith(bottom: isSmall ? 12 : 24),
          child: TabBar(
            onTap: (_) {
              playAudio();
            },
            controller: _tabController,
            tabs: const [
              PrimarySelectionTab(
                iconData: Icons.face,
              ),
              PrimarySelectionTab(
                iconData: Icons.wallpaper,
              ),
              PrimarySelectionTab(
                iconData: Icons.color_lens,
              ),
            ],
          ),
        ),
        if (!widget.collapsed)
          Expanded(
            child: TabBarView(
              key: PrimarySelectionView.primaryTabBarViewKey,
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                CharacterSelectionTabBarView(),
                BackgroundSelectionTabBarView(),
                PropsSelectionTabBarView(),
              ],
            ),
          ),
        if (_indexSelected == 0)
          Padding(
            padding: const EdgeInsets.all(15),
            child: NextButton(
              key: const Key('primarySelection_nextButton_character'),
              onNextPressed: () {
                _tabController.animateTo(1);
              },
            ),
          ),
        if (_indexSelected == 1)
          Padding(
            padding: const EdgeInsets.all(15),
            child: NextButton(
              key: const Key('primarySelection_nextButton_background'),
              onNextPressed: () {
                _tabController.animateTo(2);
              },
            ),
          ),
        if (_indexSelected == 2)
          Padding(
            padding: const EdgeInsets.all(15),
            child: RecordingButton(
              onRecordingPressed: () {
                context
                    .read<PhotoBoothBloc>()
                    .add(const PhotoBoothGetReadyStarted());
              },
            ),
          ),
      ],
    );
  }
}

@visibleForTesting
class PrimarySelectionTab extends StatefulWidget {
  const PrimarySelectionTab({
    super.key,
    required this.iconData,
  });

  final IconData iconData;

  @override
  State<PrimarySelectionTab> createState() => _PrimarySelectionTabState();
}

class _PrimarySelectionTabState extends State<PrimarySelectionTab>
    with AutomaticKeepAliveClientMixin<PrimarySelectionTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Tab(height: 40, icon: Icon(widget.iconData));
  }

  @override
  bool get wantKeepAlive => true;
}
