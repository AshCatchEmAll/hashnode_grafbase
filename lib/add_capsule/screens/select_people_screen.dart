import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';

import 'package:app/add_capsule/widgets/display_media.dart';
import 'package:app/add_capsule/widgets/radio_container.dart';
import 'package:app/app/grafbase_cubit/grafbase_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/supabase_bloc/supabase_auth_repo.dart';

class SelectPeopleScreen extends StatefulWidget {
  SelectPeopleScreen({super.key});

  @override
  State<SelectPeopleScreen> createState() => _SelectPeopleScreenState();
}

class _SelectPeopleScreenState extends State<SelectPeopleScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<CapsuleMember> members = context.watch<AddCapsuleBloc>().members;
    print(members.length);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xff126EAB)),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text("Done", style: TextStyle(color: Colors.white)),
          )
        ],
        // back button

        title: const Text('Add People'),
      ),
      body: BlocListener<AddCapsuleBloc, AddCapsuleState>(
        listener: (context, state) {
          if (state is AddCapsuleAddPersonState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Added ${state.member.email}"),
                duration: Duration(seconds: 1),
              ),
            );
          } else if (state is AddCapsuleRemovePersonState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Removed ${state.member.email}"),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Color(0xffD1E4F2)),
                  decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white),
                      fillColor: Color(0xff252C32),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: SearchPeopleIcon(_controller)),
                ),
              ),
              SizedBox(height: 20),
              ...members.map((e) => Padding(
                    key: Key(e.email),
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Color(0xff6D7C89))),
                      title:
                          Text(e.email, style: TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<AddCapsuleBloc>()
                              .add(AddCapsuleRemovePerson(e));
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPeopleIcon extends StatefulWidget {
  SearchPeopleIcon(this.controller, {super.key});
  TextEditingController controller;
  @override
  State<SearchPeopleIcon> createState() => _SearchPeopleIconState();
}

class _SearchPeopleIconState extends State<SearchPeopleIcon> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : Icon(Icons.search, color: Color(0xff6D7C89)),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });

       
        try {
          final accessToken = SupabaseAuth().getJWT();
          final sub = SupabaseAuth().getSub();
          final res = await GrafbaseRepo()
              .fetchUserByEmail(accessToken, sub, widget.controller.text);
          final subFromRes = res["node"]["sub"];

          context.read<AddCapsuleBloc>().add(AddCapsuleAddPerson(
              CapsuleMember(email: widget.controller.text, sub: subFromRes)));
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          //show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("User not found"),
              ),
              duration: Duration(seconds: 1),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}
