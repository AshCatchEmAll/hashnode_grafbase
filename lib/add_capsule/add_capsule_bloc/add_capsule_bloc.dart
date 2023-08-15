import 'dart:developer';
import 'dart:io';

import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/app/supabase_bloc/supabase_auth_repo.dart';
import 'package:app/app/supabase_bloc/supabase_func_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'add_capsule_event.dart';
part 'add_capsule_state.dart';

class AddCapsuleBloc extends Bloc<AddCapsuleEvent, AddCapsuleState> {
  ///Cron expression for capsule
  String cron = "";

  ///Cron in date time format for capsule
  DateTime cronDateTime = DateTime.now();

  ///Expires at date for capsule cron job
  String expiresAt = "";

  ///Captionf or the capsule
  String caption = "";

  ///Content public URL after uploading to supabase
  String content = "";

  ///Media file for the capsule (Audio,Video,Image)
  CapsuleMedia media = CapsuleMedia.zero();

  ///Location for the capsule
  CapsuleLocation location = CapsuleLocation.zero();

  ///Members for the capsule , Must have current user
  List<CapsuleMember> members = [];

  ///Current media icon depending on what media the user has chosen
  IconData mediaIcon = Icons.perm_media_rounded;

  ///List of media types supported by capsule
  List<String> get mediaType => ["Image", "Video", "Audio"];

  AddCapsuleBloc() : super(AddCapsuleInitial()) {
    on<AddCapsuleUpdateMediaIconBtnEvent>(_onUpdateMediaIconBtn);
    on<ClearCapsuleMediaIconBtnEvent>(_onClearMediaIconBtn);
    on<AddCapsuleAddPerson>(_onAddPerson);
    on<AddCapsuleRemovePerson>(_onRemovePerson);

    on<AddCapsuleUpdateLocationEvent>(_onUpdateLocation);
    on<AddCapsuleClearLocationEvent>(_onClearLocation);
  }

  @override
  void onChange(Change<AddCapsuleState> change) {
    log(change.toString());
    super.onChange(change);
  }

  _onUpdateMediaIconBtn(
      AddCapsuleUpdateMediaIconBtnEvent event, Emitter<AddCapsuleState> emit) {
    print("Fasjdhj");

    updateCapsuleMedia(event.media);
    emit(AddCapsuleUpdateMediaIconBtnState(event.media));
  }

  _onClearMediaIconBtn(
      ClearCapsuleMediaIconBtnEvent event, Emitter<AddCapsuleState> emit) {
    clearCapsuleMedia();
    emit(ClearCapsuleMediaIconBtnState());
  }

  _onAddPerson(AddCapsuleAddPerson event, Emitter<AddCapsuleState> emit) {
    updateCapsulePeople(event.member);
    emit(AddCapsuleAddPersonState(event.member));
  }

  _onRemovePerson(AddCapsuleRemovePerson event, Emitter<AddCapsuleState> emit) {
    removeCapsulePeople(event.member);
    emit(AddCapsuleRemovePersonState(event.member));
  }

  _onUpdateLocation(
      AddCapsuleUpdateLocationEvent event, Emitter<AddCapsuleState> emit) {
    updateCapsuleLocation(event.location);
    emit(AddCapsuleUpdateLocationState(event.location));
  }

  _onClearLocation(
      AddCapsuleClearLocationEvent event, Emitter<AddCapsuleState> emit) {
    clearCapsuleLocation();
    emit(AddCapsuleClearLocationState());
  }

  void updateCapsuleLocation(CapsuleLocation l) {
    location = l;
  }

  void clearCapsuleLocation() {
    location = CapsuleLocation.zero();
  }

  void updateCapsuleMedia(CapsuleMedia m) {
    media = m;
    String type = media.type;
    if (type == "Image") {
      mediaIcon = Icons.image_rounded;
    } else if (type == "Video") {
      mediaIcon = Icons.video_collection_rounded;
    } else if (type == "Audio") {
      mediaIcon = Icons.music_note_rounded;
    } else {
      mediaIcon = Icons.perm_media_rounded;
      print("YUOu kidding");
    }
  }

  void clearCapsuleMedia() {
    media = CapsuleMedia.zero();
  }


  void updateCapsulePeople(CapsuleMember p) {
    members.add(p);
  }

  void removeCapsulePeople(CapsuleMember p) {
    members.remove(p);
  }

  void clearCapsulePeople() {
    members = [];
  }

  ///Adds one hour to the time and converts it to the required format
  ///This way we ensures that cron job on Cron.org runs only one time as intended
  expiryTime(DateTime time) {
    var formatter = DateFormat('yyyyMMddHHmmss');

    time = time.add(const Duration(hours: 1));
    String formatted = formatter.format(time);
    print(formatted);
    return formatted;
  }

  dayOfWeekForCron(int number) {
    if (number == 7) {
      return 0;
    } else {
      return number;
    }
  }

  ///Converts DateTime to cron format
  String toCron(DateTime time) {
    final minute = time.minute;
    final hour = time.hour;
    final dayOfMonth = time.day;
    final month = time.month;
    final dayOfWeek = dayOfWeekForCron(time.weekday);

    return "$minute $hour $dayOfMonth $month $dayOfWeek";
  }

  ///Converts the DateTime string to a cron string
  void updateCron(DateTime schedule) {
    //Get timestamp
    cronDateTime = schedule;
    final newCron = toCron(schedule);
    cron = newCron;
    expiresAt = expiryTime(schedule);
  }

  ///Updates the visibility of the capsule
  ///Default is private
  ///If public, the capsule will be visible to everyone
  ///If private, the capsule will be visible only to the creator
  void updateVisibility(String visibility) {
    visibility = visibility;
  }

  uploadImageToSupabase(String path) async {

    print("Uploading image to supabase $path");
    if(path.isEmpty){
      return "";
    }

    final File imageFile = File(path);

    final String fileExtension = imageFile.path.split('.').last;

    final uploadedFileKey =
        await SupabaseFunc().uploadImage(imageFile, fileExtension);

    final uploadedName = uploadedFileKey.split('/').last;

    content = await SupabaseFunc().getPublicUrl(uploadedName);

    return content;
  }

  generateCapsule() {

    final sub = SupabaseAuth().getSub();

    

    List<String> subList = members.map((e) => e.sub).toList();

    // check is subList has current user
    if (!subList.contains(sub)) {
      subList.add(sub);
    }

    Capsule capsule = Capsule(
      caption: caption,
      content: content,
      location: location,
      members: subList,
      cron: cron,
     
      availableAt:  cronDateTime,
      createdAt: DateTime.now(),
    );

    return capsule;
  }
}
