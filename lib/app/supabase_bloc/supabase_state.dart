part of 'supabase_bloc.dart';

@immutable
abstract class SupabaseState {}

class SupabaseInitial extends SupabaseState {}


class SupabaseLoading extends SupabaseState {}

// add staet for picture upload
class PictureUploadCompleteState extends SupabaseState {
  final String pictureUrl;
  PictureUploadCompleteState(this.pictureUrl);
}

// add state for schedule upload
class ScheduleUploadCompleteState extends SupabaseState {
  ScheduleUploadCompleteState();
}