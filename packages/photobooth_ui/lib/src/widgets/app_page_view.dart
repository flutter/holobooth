import 'package:flutter/material.dart';

/// {@template app_page_view}
/// A widget that constructs a page view consisting of a [background]
/// [body], [footer] pinned to the bottom of the page and an optional
/// list of overlay widgets displayed on top of the [body].
/// {@endtemplate}
class AppPageView extends StatelessWidget {
  /// {@macro app_page_view}
  const AppPageView({
    super.key,
    required this.body,
    required this.footer,
    this.overlays = const <Widget>[],
    this.backgrounds,
  });

  /// A body of the [AppPageView]
  final Widget body;

  /// Sticky footer displayed at the bottom of the [AppPageView]
  final Widget footer;

  final List<Widget>? backgrounds;

  /// An optional list of overlays displayed on top of the [body]
  final List<Widget> overlays;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (backgrounds != null)
          for (final background in backgrounds!) background,
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: body),
            SliverFillRemaining(
              hasScrollBody: false,
              child: footer,
            )
          ],
        ),
        ...overlays,
      ],
    );
  }
}
