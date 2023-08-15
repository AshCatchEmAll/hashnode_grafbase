part of 'add_capsule_bloc.dart';

@immutable
sealed class AddCapsuleEvent {}

// update Media Icon Button
class AddCapsuleUpdateMediaIconBtnEvent extends AddCapsuleEvent {
  final CapsuleMedia media;

  AddCapsuleUpdateMediaIconBtnEvent(this.media);
}

class ClearCapsuleMediaIconBtnEvent extends AddCapsuleEvent {}

class AddCapsuleAddPerson extends AddCapsuleEvent {
  final CapsuleMember member;

  AddCapsuleAddPerson(this.member);
}


class AddCapsuleRemovePerson extends AddCapsuleEvent {
  final CapsuleMember member;

  AddCapsuleRemovePerson(this.member);
}

class AddCapsuleUpdateVisibility extends AddCapsuleEvent {
  final String visibility;

  AddCapsuleUpdateVisibility(this.visibility);
}



class AddCapsuleUpdateLocationEvent extends AddCapsuleEvent {
  final CapsuleLocation location;

  AddCapsuleUpdateLocationEvent(this.location);
}

class AddCapsuleClearLocationEvent extends AddCapsuleEvent {}