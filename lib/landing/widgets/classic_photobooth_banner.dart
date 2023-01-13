import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _bannerSize = Size(170, 72);

class ClassicPhotoboothBanner extends StatefulWidget {
  const ClassicPhotoboothBanner({super.key});

  @override
  State<ClassicPhotoboothBanner> createState() =>
      _ClassicPhotoboothBannerState();
}

class _ClassicPhotoboothBannerState extends State<ClassicPhotoboothBanner> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: _bannerSize.width,
      height: _bannerSize.height,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            right: _open ? 0 : -122,
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _open = true);
              },
              onExit: (_) {
                setState(() => _open = false);
              },
              child: Clickable(
                onPressed: () => openLink(classicPhotoboothLink),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: HoloBoothColors.black20,
                  ),
                  width: _bannerSize.width,
                  height: _bannerSize.height,
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.icons.classicPhotobooth.path,
                          width: 32,
                          height: 44,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.classicPhotoboothHeading,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: HoloBoothColors.white,
                                  ),
                            ),
                            Text(
                              l10n.classicPhotoboothLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: HoloBoothColors.white,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
