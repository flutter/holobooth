import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:uuid/uuid.dart';

part 'photobooth_event.dart';
part 'photobooth_state.dart';

typedef UuidGetter = String Function();

class PhotoboothBloc extends Bloc<PhotoboothEvent, PhotoboothState> {
  PhotoboothBloc([UuidGetter? uuid])
      : uuid = uuid ?? const Uuid().v4,
        super(const PhotoboothState()) {
    on<PhotoCaptured>(_onPhotoCaptured);
    on<PhotoCharacterToggled>(_onCharacterToggled);
    on<PhotoCharacterDragged>(_onCharacterDragged);
    on<PhotoStickerTapped>(_onStickerTapped);
    on<PhotoStickerDragged>(_onStickerDragged);
    on<PhotoClearStickersTapped>(_onPhotoClearStickersTapped);
    on<PhotoClearAllTapped>(_onPhotoClearAllTapped);
    on<PhotoDeleteSelectedStickerTapped>(_onSelectedStickerTapped);
    on<PhotoTapped>(_onPhotoTapped);
  }

  final UuidGetter uuid;

  void _onPhotoCaptured(PhotoCaptured event, Emitter<PhotoboothState> emit) {
    emit(
      state.copyWith(
        aspectRatio: event.aspectRatio,
        image: event.image,
        imageId: uuid(),
        selectedAssetId: emptyAssetId,
      ),
    );
  }

  void _onCharacterToggled(
    PhotoCharacterToggled event,
    Emitter<PhotoboothState> emit,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters);
    final index = characters.indexWhere((c) => c.asset.name == asset.name);
    final characterExists = index != -1;

    if (characterExists) {
      characters.removeAt(index);
      return emit(state.copyWith(characters: characters));
    }

    final newCharacter = PhotoAsset(id: uuid(), asset: asset);
    characters.add(newCharacter);
    emit(
      state.copyWith(
        characters: characters,
        selectedAssetId: newCharacter.id,
      ),
    );
  }

  void _onCharacterDragged(
    PhotoCharacterDragged event,
    Emitter<PhotoboothState> emit,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters);
    final index = characters.indexWhere((element) => element.id == asset.id);
    final character = characters.removeAt(index);
    characters.add(
      character.copyWith(
        angle: event.update.angle,
        position: PhotoAssetPosition(
          dx: event.update.position.dx,
          dy: event.update.position.dy,
        ),
        size: PhotoAssetSize(
          width: event.update.size.width,
          height: event.update.size.height,
        ),
        constraint: PhotoConstraint(
          width: event.update.constraints.width,
          height: event.update.constraints.height,
        ),
      ),
    );
    emit(
      state.copyWith(characters: characters, selectedAssetId: asset.id),
    );
  }

  void _onStickerTapped(
    PhotoStickerTapped event,
    Emitter<PhotoboothState> emit,
  ) {
    final asset = event.sticker;
    final newSticker = PhotoAsset(id: uuid(), asset: asset);
    emit(
      state.copyWith(
        stickers: List.of(state.stickers)..add(newSticker),
        selectedAssetId: newSticker.id,
      ),
    );
  }

  void _onStickerDragged(
    PhotoStickerDragged event,
    Emitter<PhotoboothState> emit,
  ) {
    final asset = event.sticker;
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere((element) => element.id == asset.id);
    final sticker = stickers.removeAt(index);
    stickers.add(
      sticker.copyWith(
        angle: event.update.angle,
        position: PhotoAssetPosition(
          dx: event.update.position.dx,
          dy: event.update.position.dy,
        ),
        size: PhotoAssetSize(
          width: event.update.size.width,
          height: event.update.size.height,
        ),
        constraint: PhotoConstraint(
          width: event.update.constraints.width,
          height: event.update.constraints.height,
        ),
      ),
    );
    emit(state.copyWith(stickers: stickers, selectedAssetId: asset.id));
  }

  void _onPhotoClearStickersTapped(
    PhotoClearStickersTapped _,
    Emitter<PhotoboothState> emit,
  ) {
    emit(
      state.copyWith(
        stickers: const <PhotoAsset>[],
        selectedAssetId: emptyAssetId,
      ),
    );
  }

  void _onPhotoClearAllTapped(
    PhotoClearAllTapped _,
    Emitter<PhotoboothState> emit,
  ) {
    emit(
      state.copyWith(
        characters: const <PhotoAsset>[],
        stickers: const <PhotoAsset>[],
        selectedAssetId: emptyAssetId,
      ),
    );
  }

  void _onSelectedStickerTapped(
    PhotoDeleteSelectedStickerTapped _,
    Emitter<PhotoboothState> emit,
  ) {
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere(
      (element) => element.id == state.selectedAssetId,
    );
    final stickerExists = index != -1;

    if (stickerExists) {
      stickers.removeAt(index);
    }

    emit(
      state.copyWith(
        stickers: stickers,
        selectedAssetId: emptyAssetId,
      ),
    );
  }

  void _onPhotoTapped(PhotoTapped event, Emitter<PhotoboothState> emit) {
    emit(state.copyWith(selectedAssetId: emptyAssetId));
  }
}
