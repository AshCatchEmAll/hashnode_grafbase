import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunc {
  String localTimeZone() {
    //Get time zone like America/New_York
    final timeZone = DateTime.now().timeZoneName;
    print(timeZone);
    return timeZone;
  }

  // DateTime localToGMT(DateTime time) {
  //   var now = DateTime.now();
  //   var local = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  //   print('Local time: $local');

  //   var gmtTime = now.toUtc();
  //   var gmtFormat = DateFormat('yyyy-MM-dd – kk:mm').format(gmtTime);
  //   print('GMT time: $gmtFormat');

  //   return gmtTime;
  // }

  ///Converts day of week to cron format
  ///Monday is 1 and Sunday is 0
  int dayOfWeekForCron(int number) {
    if (number == 7) {
      return 0;
    } else {
      return number;
    }
  }

  ///Converts DateTime to cron format
  ///Example: 2021-09-30 12:00:00.000Z to 0 12 30 9 4
  String toCron(DateTime time) {
    final minute = time.minute;
    final hour = time.hour;
    final dayOfMonth = time.day;
    final month = time.month;
    final dayOfWeek = dayOfWeekForCron(time.weekday);

    return "$minute $hour $dayOfMonth $month $dayOfWeek";
  }

  ///Converts DateTime to expiry time format required by cron job
  ///Example: 2021-09-30 12:00:00.000Z to 20210930130000
 

 
  Future<String> uploadImage(dynamic file, String fileExtension) async {
    try {
      final response =
          await Supabase.instance.client.storage.from('capsules').upload(
          
                '${DateTime.now().toIso8601String()}.${fileExtension}',
                file,
                
               
              );
      return response;
    } catch (e) {
      log("Error uploading image: $e");
      rethrow;
    }
  }


  Future<String> getPublicUrl (String fileName) async {
    try {
      final response =  Supabase.instance.client.storage
          .from('capsules')
          .getPublicUrl(fileName);
      log("Public url: $response");
      return response;
    } catch (e) {
      log("Error getting public url: $e");
      rethrow;
    }
  }

  
}
