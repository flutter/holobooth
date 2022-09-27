import 'package:flutter/material.dart';

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const CharacterSelectionPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a character')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CharacterSelections(),
            ActionChip(
              label: const Text('To the Photobooth!'),
              backgroundColor: const Color.fromARGB(255, 129, 147, 231),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class CharacterSelections extends StatelessWidget {
  const CharacterSelections({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Character $index',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
