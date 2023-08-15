import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/app/grafbase_cubit/grafbase_repo.dart';
import 'package:app/app/supabase_bloc/supabase_auth_repo.dart';
import 'package:app/capsules/widgets/capsule_card.dart';
import 'package:flutter/material.dart';

class CapsuleScreen extends StatefulWidget {
  const CapsuleScreen({super.key});

  @override
  State<CapsuleScreen> createState() => _CapsuleScreenState();
}

class _CapsuleScreenState extends State<CapsuleScreen> {
  final List<Capsule> capsules = [];
  @override
  void initState() {
    super.initState();
    final accessToken = SupabaseAuth().getJWT();
    final sub = SupabaseAuth().getSub();
    Future.delayed(Duration.zero, () async {
      final resCapsules = await GrafbaseRepo().getCapsules(accessToken, sub);
      print(resCapsules);
      setState(() {
        capsules.addAll(resCapsules);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // back button

        title: const Text('Capsules'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            capsules.isEmpty
                ? const Padding(
                    padding:  EdgeInsets.only(top: 18.0),
                    child:  Center(
                      child: Text(
                        "No capsules yet",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            ...capsules
                .map((capsule) => CapsuleCard(
                      capsule: capsule,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class TagCard extends StatelessWidget {
  const TagCard({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color(0xff1B272F),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
