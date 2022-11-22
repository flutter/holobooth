import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/props/props.dart';

void main() {
  group('InExperienceSelectionBloc', () {
    group('InExperienceSelectionPropSelected', () {
      blocTest<InExperienceSelectionBloc, PropsState>(
        'emits state with prop selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(propsSelected(Prop.helmet)),
        expect: () => const <PropsState>[
          PropsState(selectedProps: [Prop.helmet])
        ],
      );

      blocTest<InExperienceSelectionBloc, PropsState>(
        'emits state with prop unselected.',
        build: InExperienceSelectionBloc.new,
        seed: () => PropsState(selectedProps: const [Prop.helmet]),
        act: (bloc) => bloc.add(propsSelected(Prop.helmet)),
        expect: () => const <PropsState>[PropsState()],
      );
    });
  });
}
