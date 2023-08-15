import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/add_capsule/screens/select_people_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CapsuleMemberButton extends StatelessWidget {
  const CapsuleMemberButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AddCapsuleBloc addCapsuleBloc = context.read<AddCapsuleBloc>();
    List<CapsuleMember> members = context.watch<AddCapsuleBloc>().members;
    return CircleAvatar(
      radius: 23,
      backgroundColor: Color(0xff293138),
      child: IconButton(
        icon: members.isEmpty
            ? Icon(Icons.group_add, color: Colors.blueGrey)
            : Text(members.length.toString(),
                style: TextStyle(color: Color.fromARGB(255, 99, 108, 235) , fontSize: 18,)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider.value(
              value: addCapsuleBloc,
              child: SelectPeopleScreen(),
            );
          }));
        },
      ),
    );
  }
}
