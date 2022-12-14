import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class FullFooter extends StatelessWidget {
  const FullFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: 32);

    return SizedBox(
      height: 100,
      child: ResponsiveLayoutBuilder(
        small: (context, child) {
          return Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
            ).copyWith(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1D1D).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: child,
            ),
          );
        },
        large: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 24,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const FlutterIconLink(),
                gap,
                const FirebaseIconLink(),
                gap,
                const TensorflowIconLink(),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: child,
                  ),
                )
              ],
            ),
          );
        },
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: const [
            FlutterFooterLink(),
            gap,
            FirebaseFooterLink(),
            gap,
            TensorFlowFooterLink(),
            gap,
            MediapipeFooterLink(),
            gap,
            FooterTermsOfServiceLink(),
            gap,
            FooterPrivacyPolicyLink(),
          ],
        ),
      ),
    );
  }
}
