part of 'add_capsule_bloc.dart';

@immutable
sealed class AddCapsuleState {}

final class AddCapsuleInitial extends AddCapsuleState {}





class AddCapsuleUpdateMediaIconBtnState extends AddCapsuleState {
  final CapsuleMedia media;

  AddCapsuleUpdateMediaIconBtnState(this.media);

}


class ClearCapsuleMediaIconBtnState extends AddCapsuleState {}

class AddCapsuleAddPersonState extends AddCapsuleState {
  final CapsuleMember member;

  AddCapsuleAddPersonState(this.member);
}

class AddCapsuleRemovePersonState extends AddCapsuleState {
  final CapsuleMember member;

  AddCapsuleRemovePersonState(this.member);
}

class AddCapsuleUpdateLocationState extends AddCapsuleState {
  final CapsuleLocation location;

  AddCapsuleUpdateLocationState(this.location);
}

class AddCapsuleClearLocationState extends AddCapsuleState {}