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
  @visibleForTesting
  static const glassesTabKey = ValueKey('glasses_tab');

  @visibleForTesting
  static const clothesTabKey = ValueKey('clothes_tab');

  @visibleForTesting
  static const othersTabKey = ValueKey('others_tab');

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
              key: PropsSelectionTabBarView.glassesTabKey,
              assetGenImage: Assets.props.glassesIcon,
            ),
            PropSelectionTab(
              key: PropsSelectionTabBarView.clothesTabKey,
              assetGenImage: Assets.props.clothes,
            ),
            PropSelectionTab(
              key: PropsSelectionTabBarView.othersTabKey,
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
              GlassesSelectionTabBarView(),
              ClothesSelectionTabBarView(),
              OthersSelectionTabBarView(),
            ],
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
class PropSelectionTab extends StatefulWidget {
  const PropSelectionTab({
    super.key,
    required this.assetGenImage,
  });

  final AssetGenImage assetGenImage;

  @override
  State<PropSelectionTab> createState() => _PropSelectionTabState();
}

class _PropSelectionTabState extends State<PropSelectionTab>
    with AutomaticKeepAliveClientMixin<PropSelectionTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Setting default icon size to avoid tap issues on testing.
    //As the child will be an image, if there is no default size, on tap will
    //throw a warning because the child will have no size
    final iconSize = IconTheme.of(context).size;
    return Tab(
      child: widget.assetGenImage.image(
        color: IconTheme.of(context).color,
        height: iconSize,
        width: iconSize,
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
    final selectedHat =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.hat);
    return _PropsGridView(
      itemBuilder: (context, index) {
        final item = Hats.values[index];
        return _PropSelectionElement(
          key: Key('hat_selection_${item.name}'),
          onTap: () {
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionHatSelected(item));
          },
          name: item.name,
          isSelected: item == selectedHat,
        );
      },
      itemCount: Hats.values.length,
    );
  }
}

class GlassesSelectionTabBarView extends StatelessWidget {
  const GlassesSelectionTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedGlasses =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.glasses);
    const items = Glasses.values;
    return _PropsGridView(
      itemBuilder: (context, index) {
        final item = items[index];
        return _PropSelectionElement(
          key: Key('glasses_selection_${item.name}'),
          onTap: () {
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionGlassesSelected(item));
          },
          name: item.name,
          isSelected: item == selectedGlasses,
        );
      },
      itemCount: items.length,
    );
  }
}

class ClothesSelectionTabBarView extends StatelessWidget {
  const ClothesSelectionTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedClothes =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.clothes);
    const items = Clothes.values;
    return _PropsGridView(
      itemBuilder: (context, index) {
        final item = items[index];
        return _PropSelectionElement(
          key: Key('clothes_selection_${item.name}'),
          onTap: () {
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionClothesSelected(item));
          },
          name: item.name,
          isSelected: item == selectedClothes,
        );
      },
      itemCount: items.length,
    );
  }
}

class OthersSelectionTabBarView extends StatelessWidget {
  const OthersSelectionTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedHandheldlLeft = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.handheldlLeft);
    const items = HandheldlLeft.values;
    return _PropsGridView(
      itemBuilder: (context, index) {
        final item = items[index];
        return _PropSelectionElement(
          key: Key('handheldlLeft_selection_${item.name}'),
          onTap: () {
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionHandleheldLeftSelected(item));
          },
          name: item.name,
          isSelected: item == selectedHandheldlLeft,
        );
      },
      itemCount: items.length,
    );
  }
}

class _PropsGridView extends StatelessWidget {
  const _PropsGridView({
    required this.itemBuilder,
    required this.itemCount,
  });

  final Widget? Function(BuildContext context, int index) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

class _PropSelectionElement extends StatelessWidget {
  const _PropSelectionElement({
    required this.name,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      focusable: true,
      button: true,
      label: name,
      child: InkWell(
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
      ),
    );
  }
}
