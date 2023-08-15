import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/add_capsule/screens/select_media_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaIconButton extends StatefulWidget {
  MediaIconButton({
    super.key,
  });

  @override
  State<MediaIconButton> createState() => _MediaIconButtonState();
}

class _MediaIconButtonState extends State<MediaIconButton> {
  @override
  Widget build(BuildContext context) {
    CapsuleMedia media = context.watch<AddCapsuleBloc>().media;
    IconData mediaIcon = context.watch<AddCapsuleBloc>().mediaIcon;

    print("Tye");
    print(media.type);

    return CircleAvatar(
      radius: 23,
      backgroundColor: const Color(0xff293138),
      child: IconButton(
        icon: Icon(
          mediaIcon,
          color: media.type == ""
              ? Colors.blueGrey
              : Color.fromARGB(255, 99, 108, 235),
          size: 20,
        ),
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return BlocProvider.value(
              value: context.read<AddCapsuleBloc>(),
              child: SelectMediaScreen(),
            );
          }));
        },
      ),
    );
  }
}
