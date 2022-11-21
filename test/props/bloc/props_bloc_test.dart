import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/props/props.dart';

void main() {
  group('PropsBloc', () {
    group('PropsSelected', () {
      blocTest<PropsBloc, PropsState>(
        'emits state with prop selected.',
        build: PropsBloc.new,
        act: (bloc) => bloc.add(PropsSelected(Prop.helmet)),
        expect: () => const <PropsState>[
          PropsState(selectedProps: [Prop.helmet])
        ],
      );

      blocTest<PropsBloc, PropsState>(
        'emits state with prop unselected.',
        build: PropsBloc.new,
        seed: () => PropsState(selectedProps: const [Prop.helmet]),
        act: (bloc) => bloc.add(PropsSelected(Prop.helmet)),
        expect: () => const <PropsState>[PropsState()],
      );
    });
  });
}
