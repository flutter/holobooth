import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class FullFooter extends StatelessWidget {
  const FullFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final small = size.width <= PhotoboothBreakpoints.small;

    const gap = SizedBox(width: 32);

    return Container(
      alignment: Alignment.bottomCenter,
      margin: small
          ? const EdgeInsets.symmetric(
              horizontal: 8,
            ).copyWith(
              bottom: 8,
            )
          : null,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 12,
      ),
      decoration: small
          ? BoxDecoration(
              color: const Color(0xFF1D1D1D).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: Row(
        children: [
          if (!small) ...const [
            FlutterIconLink(),
            gap,
            FirebaseIconLink(),
            gap,
            TensorflowIconLink(),
          ],
          Expanded(
            child: Align(
              alignment: small ? Alignment.center : Alignment.centerRight,
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
          )
        ],
      ),
    );
  }
}
