import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PropsSelectionTabBarView extends StatefulWidget {
  const PropsSelectionTabBarView({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

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
        TabBar(
          controller: _tabController,
          tabs: [
            PropSelectionTab(
              assetGenImage: Assets.props.hatsIcon,
            ),
            PropSelectionTab(
              assetGenImage: Assets.props.glassesIcon,
            ),
            PropSelectionTab(
              assetGenImage: Assets.props.clothes,
            ),
            PropSelectionTab(
              assetGenImage: Assets.props.othersIcon,
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              HatsSelectionTabBarView(),
              SizedBox(),
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
class PropSelectionTab extends StatefulWidget {
  const PropSelectionTab({super.key, required this.assetGenImage});

  final AssetGenImage assetGenImage;

  @override
  State<PropSelectionTab> createState() => _PropSelectionTabState();
}

class _PropSelectionTabState extends State<PropSelectionTab>
    with AutomaticKeepAliveClientMixin<PropSelectionTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Tab(
      iconMargin: const EdgeInsets.only(bottom: 24),
      icon: widget.assetGenImage.image(
        color: IconTheme.of(context).color,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HatsSelectionTabBarView extends StatelessWidget {
  const HatsSelectionTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final hatSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.selectedHat);
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: Hats.values.length,
      itemBuilder: (context, index) {
        final hat = Hats.values[index];
        return _PropSelectionElement(
          onTap: () {
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionHatSelected(hat));
          },
          name: hat.name,
          isSelected: hat == hatSelected,
        );
      },
    );
  }
}

class _PropSelectionElement extends StatelessWidget {
  const _PropSelectionElement({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 75,
        width: 100,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? PhotoboothColors.white
                : PhotoboothColors.transparent,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2C2C2C).withOpacity(0.3),
              const Color(0xFF868686).withOpacity(0.4),
            ],
          ),
        ),
        child: Text(
          name,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: PhotoboothColors.white),
        ),
      ),
    );
  }
}
