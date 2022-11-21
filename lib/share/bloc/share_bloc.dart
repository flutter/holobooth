import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(const ShareState());
}
