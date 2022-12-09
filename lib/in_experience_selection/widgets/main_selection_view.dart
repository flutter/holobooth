import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MainSelectionView extends StatefulWidget {
  const MainSelectionView({
    super.key,
    required this.onTabChanged,
    this.initialIndex = 0,
  });

  final ValueSetter<int> onTabChanged;
  final int initialIndex;

  @override
  State<MainSelectionView> createState() => _MainSelectionViewState();
}

class _MainSelectionViewState extends State<MainSelectionView>
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
            MainSelectionTab(
              iconData: Icons.face,
            ),
            MainSelectionTab(
              iconData: Icons.wallpaper,
            ),
            MainSelectionTab(
              iconData: Icons.color_lens,
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              SelectionTabBarView(),
              SelectionTabBarView(),
              SelectionTabBarView(),
            ],
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
class MainSelectionTab extends StatefulWidget {
  const MainSelectionTab({
    super.key,
    required this.iconData,
  });

  final IconData iconData;

  @override
  State<MainSelectionTab> createState() => _MainSelectionTabState();
}

class _MainSelectionTabState extends State<MainSelectionTab>
    with AutomaticKeepAliveClientMixin<MainSelectionTab> {
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

@visibleForTesting
class SelectionTabBarView extends StatelessWidget {
  const SelectionTabBarView({
    super.key,
  });

  static const _defaultGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 150,
    mainAxisSpacing: 64,
    crossAxisSpacing: 42,
  );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey<String>('$key'),
      gridDelegate: _defaultGridDelegate,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      itemCount: 2,
      itemBuilder: (context, index) {
        return StickerChoice(
          asset: Assets.props.prop1.path,
          onPressed: () {},
        );
      },
    );
  }
}

@visibleForTesting
class StickerChoice extends StatelessWidget {
  const StickerChoice({
    super.key,
    required this.asset,
    required this.onPressed,
  });

  final String asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        return AppAnimatedCrossFade(
          firstChild: SizedBox.fromSize(
            size: const Size(20, 20),
            child: const AppCircularProgressIndicator(strokeWidth: 2),
          ),
          secondChild: InkWell(
            onTap: onPressed,
            child: child,
          ),
          crossFadeState: frame == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        );
      },
    );
  }
}
