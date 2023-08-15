import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  // ignore: non_constant_identifier_names
  final SupabaseAuthClient = Supabase.instance.client.auth;

 

  String getJWT()  {
    final res = SupabaseAuthClient.currentSession?.accessToken;
    if (res != null) {
      return res;
    } else {
      throw Exception('Error getting JWT. Please sign in again');
    }
  }

  String getSub(){
    final res = SupabaseAuthClient.currentSession?.user?.id;
    if (res != null) {
      return res;
    } else {
      throw Exception('Error getting sub. Please sign in again');
    }
  }

  Future<void> signOut() async {
    await SupabaseAuthClient.signOut();
  }
}
