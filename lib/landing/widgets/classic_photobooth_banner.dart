import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _width = 170.0;
const _height = 72.0;

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
      width: _width,
      height: _height,
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
                    color: PhotoboothColors.black20,
                  ),
                  //width: 48,
                  width: _width,
                  height: _height,
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/classic_photobooth.png',
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
                              style: PhotoboothTextStyle.bodySmall.copyWith(
                                color: PhotoboothColors.white,
                              ),
                            ),
                            Text(
                              l10n.classicPhotoboothLabel,
                              style: PhotoboothTextStyle.bodyLarge.copyWith(
                                color: PhotoboothColors.white,
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
