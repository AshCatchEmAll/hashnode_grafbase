part of 'supabase_bloc.dart';

@immutable
abstract class SupabaseEvent {}




// image upload process is two part , uploading picture and then scheudling it
// this event is for uploading picture
class PictureUploadCompleteEvent extends SupabaseEvent {
  final String pictureUrl;
  PictureUploadCompleteEvent(this.pictureUrl);
}


// this event is for scheduling picture
class ScheduleUploadCompleteEvent extends SupabaseEvent {

  ScheduleUploadCompleteEvent();
  
}