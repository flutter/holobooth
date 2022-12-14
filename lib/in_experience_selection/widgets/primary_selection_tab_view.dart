import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';

class PrimarySelectionView extends StatefulWidget {
  const PrimarySelectionView({
    super.key,
    this.initialIndex = 0,
    this.collapsed = false,
  });

  final int initialIndex;
  final bool collapsed;

  @override
  State<PrimarySelectionView> createState() => _PrimarySelectionViewState();
}

class _PrimarySelectionViewState extends State<PrimarySelectionView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late int _indexSelected;

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
    // at least we add a listener
    _tabController.addListener(() {
      setState(() {
        _indexSelected = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: TabBar(
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
              controller: _tabController,
              children: const [
                CharacterSelectionTabBarView(),
                BackgroundSelectionTabBarView(),
                PropsSelectionTabBarView(),
              ],
            ),
          ),
        if (widget.collapsed) const Spacer(),
        if (_indexSelected == 0)
          Padding(
            padding: const EdgeInsets.all(15),
            child: NextButton(
              onNextPressed: () {
                _tabController.animateTo(1);
              },
            ),
          ),
        if (_indexSelected == 1)
          Padding(
            padding: const EdgeInsets.all(15),
            child: NextButton(
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
                    .add(const PhotoBoothRecordingStarted());
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
