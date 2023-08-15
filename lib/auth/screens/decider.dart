import 'package:app/app/bottom_bar.dart';
import 'package:app/auth/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Decider extends StatelessWidget {
  const Decider({super.key});

  @override
  Widget build(BuildContext context) {
    if (Supabase.instance.client.auth.currentUser != null) {
      return BottomBar();
    } else {
      return const Login();
    }
  }
}
