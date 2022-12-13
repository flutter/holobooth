import 'package:flutter/material.dart' hide UnderlineTabIndicator;
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

class PropsSelectionTabBarView extends StatefulWidget {
  const PropsSelectionTabBarView({
    super.key,
    this.initialIndex = 0,
    required this.onRecordingPressed,
  });

  @visibleForTesting
  static const glassesTabKey = ValueKey('glasses_tab');

  @visibleForTesting
  static const clothesTabKey = ValueKey('clothes_tab');

  @visibleForTesting
  static const othersTabKey = ValueKey('others_tab');

  final int initialIndex;
  final VoidCallback onRecordingPressed;

  @override
  State<PropsSelectionTabBarView> createState() =>
      _PropsSelectionTabBarViewState();
}

class _PropsSelectionTabBarViewState extends State<PropsSelectionTabBarView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
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
        Theme(
          data: ThemeData(
            tabBarTheme: const TabBarTheme(),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: const UnderlineTabIndicator(
              gradients: [
                Color(0xffF9F8C4),
                Color(0xff27F5DD),
              ],
            ),
            tabs: [
              _PropSelectionTab(
                assetGenImage: Assets.props.hatsIcon,
                isSelected: _tabController.index == 0,
              ),
              _PropSelectionTab(
                key: PropsSelectionTabBarView.glassesTabKey,
                assetGenImage: Assets.props.glassesIcon,
                isSelected: _tabController.index == 1,
              ),
              _PropSelectionTab(
                key: PropsSelectionTabBarView.clothesTabKey,
                assetGenImage: Assets.props.clothes,
                isSelected: _tabController.index == 2,
              ),
              _PropSelectionTab(
                key: PropsSelectionTabBarView.othersTabKey,
                assetGenImage: Assets.props.othersIcon,
                isSelected: _tabController.index == 3,
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              HatsSelectionTabBarView(),
              GlassesSelectionTabBarView(),
              ClothesSelectionTabBarView(),
              MiscellaneousSelectionTabBarView(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: RecordingButton(onRecordingPressed: widget.onRecordingPressed),
        ),
      ],
    );
  }
}

class _PropSelectionTab extends StatefulWidget {
  const _PropSelectionTab({
    super.key,
    required this.assetGenImage,
    required this.isSelected,
  });

  final AssetGenImage assetGenImage;
  final bool isSelected;

  @override
  State<_PropSelectionTab> createState() => _PropSelectionTabState();
}

class _PropSelectionTabState extends State<_PropSelectionTab>
    with AutomaticKeepAliveClientMixin<_PropSelectionTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Setting default icon size to avoid tap issues on testing.
    // As the child will be an image, if there is no default size, on tap will
    // throw a warning because the child will have no size
    final iconSize = IconTheme.of(context).size;
    final icon = widget.assetGenImage.image(
      color: IconTheme.of(context).color,
      height: iconSize,
      width: iconSize,
    );
    return Tab(
        child: widget.isSelected
            ? ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(colors: [
                    Color(0xffF9F8C4),
                    Color(0xff27F5DD),
                  ]).createShader(bounds);
                },
                child: icon,
              )
            : icon);
  }

  @override
  bool get wantKeepAlive => true;
}
