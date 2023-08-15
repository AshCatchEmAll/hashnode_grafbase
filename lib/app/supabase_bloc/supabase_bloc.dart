import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

  part 'supabase_event.dart';
  part 'supabase_state.dart';

class SupabaseBloc extends Bloc<SupabaseEvent, SupabaseState> {
  SupabaseBloc() : super(SupabaseInitial()) {
    on<PictureUploadCompleteEvent>(_onPictureUploadCompleteEvent);
    on<ScheduleUploadCompleteEvent>(_onScheduleUploadCompleteEvent);
  }

  void _onPictureUploadCompleteEvent(
      PictureUploadCompleteEvent event, Emitter<SupabaseState> emit) async {
    emit(PictureUploadCompleteState(event.pictureUrl));
  }

  void _onScheduleUploadCompleteEvent(
      ScheduleUploadCompleteEvent event, Emitter<SupabaseState> emit) async {
    emit(ScheduleUploadCompleteState());
  }
}
