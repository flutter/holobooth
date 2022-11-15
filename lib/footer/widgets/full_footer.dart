import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';

class FullFooter extends StatelessWidget {
  const FullFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: 32);

    return Container(
      height: 100,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 48, left: 32, right: 32),
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
    );
  }
}
