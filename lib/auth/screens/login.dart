import 'dart:developer';

import 'package:app/app/bottom_bar.dart';
import 'package:app/app/grafbase_cubit/grafbase_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void goToHome(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return BottomBar();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return // Create a Email sign-in/sign-up form
        Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SupaEmailAuth(
          
            redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
            onSignInComplete: (response) {
              goToHome(context);
            },
            onSignUpComplete: (response) async {
              // if( response.session ==null || response.user == null){
              //   log("response.session ==null || response.user == null");
              //   return;
              // }
              // final accessToken = response.session!.accessToken;

              // final email = response.user!.email!;

              // final sub = response.user!.id;

              // await GrafbaseRepo().createUser(accessToken, sub, email);
              goToHome(context);
            },
            metadataFields: [
              MetaDataField(
                prefixIcon: const Icon(Icons.person),
                label: 'Username',
                key: 'username',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
            ]),
      ),
    );
  }
}
