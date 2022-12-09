import 'package:flutter/material.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

class PrimarySelectionView extends StatefulWidget {
  const PrimarySelectionView({
    super.key,
    required this.onTabChanged,
    this.initialIndex = 0,
  });

  final ValueSetter<int> onTabChanged;
  final int initialIndex;

  @override
  State<PrimarySelectionView> createState() => _PrimarySelectionViewState();
}

class _PrimarySelectionViewState extends State<PrimarySelectionView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      // False when swipe
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index);
      }
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
      children: [
        TabBar(
          onTap: widget.onTabChanged,
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
        const Divider(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              CharacterSelectionTabBarView(),
              SizedBox(),
              SizedBox(),
            ],
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
    return Tab(
      iconMargin: const EdgeInsets.only(bottom: 24),
      icon: Icon(widget.iconData),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
