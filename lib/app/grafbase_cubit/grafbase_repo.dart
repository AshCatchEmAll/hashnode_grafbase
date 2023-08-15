import 'dart:developer';

import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/app/grafbase_cubit/grafbase_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GrafbaseRepo {
  Future sendRequest(String query, Map variables, String accessToken) async {
    print("accessToken: $accessToken");

    final String grafbase_key =
        dotenv.env['grafbase_key']!; // Replace this with your API key

    final String url =
        dotenv.env['grafbase_url']!; // Replace this with your GraphQL API URL
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-api-key": grafbase_key,
        "Authorization": "Bearer $accessToken"
        // Add any other headers if necessary
      },
      body: jsonEncode({
        "query": query,
        "variables": variables,
      }),
    );

    if (response.statusCode == 200) {
      log("Response:");
      log(response.body);
      final jsonBody = json.decode(response.body);
      if (json.decode(response.body)['errors'] != null) {
        log("Error! Status Code:");
        log(response.statusCode.toString());
        throw Exception(
            "Errors while calling Grafbase!: ${jsonBody['errors']}");
      }
      return response.body;
    } else {
      log("Error! Status Code:");
      log(response.statusCode.toString());
      log("Response:");
      log(response.body);
    }
  }

  Future<void> scheduleCapsule({
    required String accessToken,
    required AddCapsuleBloc bloc,
    String mediaURL = "",
    String caption = "",
  }) async {
    final String timezone = await FlutterTimezone.getLocalTimezone();

    const String mutation =
        '''mutation SchedulePost(\$mediaURL: String, \$caption: String, \$cron: String!, \$timezone: String!, \$expiresAt: String ) {
      schedulePost( mediaURL: \$mediaURL, caption: \$caption, cron: \$cron, timezone: \$timezone, expiresAt: \$expiresAt) 
    }
    ''';

    Map<String, dynamic> variables = {
      "mediaURL": mediaURL,
      "caption": caption,
      "cron": bloc.cron,
      "timezone": timezone,
      "expiresAt": bloc.expiresAt,
    };

    await sendRequest(mutation, variables, accessToken);
  }

  Future getFeed(String accessToken, String sub) async {
    String query = '''query PostSearch(\$sub: String!) {
  postSearch(filter: {
    sub : {
      eq : \$sub
    },
  
  }, first: 50) {
    edges {
      node {
        caption      
        content
        sub      
        id
        createdAt
      }
    }
  }
}
    ''';

    Map<String, dynamic> variables = {
      "sub": sub,
    };

    final posts = await sendRequest(query, variables, accessToken);

    final Map<String, dynamic> parsedJson = json.decode(posts);

    List<dynamic> edges = parsedJson['data']['postSearch']['edges'];

    List<Post> postList =
        edges.map((edge) => Post.fromJson(edge['node'])).toList();

    return postList;
  }

  Future createUser(String accessToken, String sub, String email) async {
    try {
      String mutation = '''mutation UserCreate {
          userCreate(input: {
            email:"$email",
            sub : "$sub"
          }) {
            user {
              sub
              email
            }
          }
        }
    ''';

      Map<String, dynamic> variables = {
        "sub": sub,
        "email": email,
      };

      await sendRequest(mutation, variables, accessToken);
    } catch (e) {
      log(e.toString());
    }
  }

  Future getUser(String accessToken, String email) async {
    try {
      String query = '''query UserSearch {
          userSearch(filter: {
            email:{
              eq: "$email"
            }
          }, first: 1) {
            edges {
              node {
                sub
                email
                id
                createdAt
              }
            }
            
          }
        }
    ''';

      Map<String, dynamic> variables = {
        "email": email,
      };

      final user = await sendRequest(query, variables, accessToken);

      final Map<String, dynamic> parsedJson = json.decode(user);

      List<dynamic> edges = parsedJson['data']['userSearch']['edges'];

      List<GrafBaseUser> userList =
          edges.map((edge) => GrafBaseUser.fromJson(edge['node'])).toList();

      return userList;
    } catch (e) {
      log(e.toString());
    }
  }

  //Create a capsuleCreate mutation to create a capsule refering to above query
  Future createCapsule(String accessToken, String sub, Capsule capsule) async {
    try {
      String locationMutationPart(Capsule capsule) {
        if (capsule.location != null) {
          return '''
            location: {
              create: {
                address: \$address,
                lat: \$lat,
                lng: \$lng
              }
            }
    ''';
        }
        return '';
      }

      String mutation = '''mutation CapsuleCreate(
     
      \$caption: String!,
      \$content: String!,
      \$cron: String!,
      \$members: [String!]!,
     \$availableAt: String!,
      \$address: String!,
      \$lat: Float!,
      \$lng: Float!
  ) {
      capsuleCreate(input: {
        caption: \$caption,
        content: \$content,
        cron: \$cron,
        members: \$members,
        availableAt: \$availableAt,
        ${locationMutationPart(capsule)}
      }) {
        capsule {
          caption
          content
          members
          location {
            address
            lat
            lng
            id
          }
         
          tapCount
          id
          createdAt
        }
      }
    }
''';

      Map<String, dynamic> variables = {
        "cron": capsule.cron,
        "caption": capsule.caption,
        "content": capsule.content,
        "members": capsule.members,
        "availableAt": capsule.availableAt.toIso8601String(),
        if (capsule.location != null) ...{
          "address": capsule.location!.address,
          "lat": capsule.location!.latLng.latitude,
          "lng": capsule.location!.latLng.longitude,
        }
      };

      await sendRequest(mutation, variables, accessToken);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Capsule>> getCapsules(String accessToken, String sub,
      {int first = 10}) async {
    try {
      print("Sub is : $sub");
      String query = '''query CapsuleSearch(
            \$sub: String!,
            \$first: Int!,
           ) {
            capsuleSearch(first: \$first,filter: {
              members:{
                includes:{
                  eq:\$sub
                }
              }
            }) {
              edges {
                node {
                  caption
                  content
                  id
                  createdAt
                  members
                  tapCount
                  availableAt
                  cron
                  location {
                    address
                    lat
                    lng
                  }
                }
              }
            }
          }
    ''';

      Map<String, dynamic> variables = {
        "sub": sub,
        "first": first,
      };

      final capsules = await sendRequest(query, variables, accessToken);

      final Map<String, dynamic> parsedJson = json.decode(capsules);

      List<dynamic> edges = parsedJson['data']['capsuleSearch']['edges'];

      List<Capsule> capsuleList =
          edges.map((edge) => Capsule.fromJson(edge['node'])).toList();

      return capsuleList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future unlockCapsule(
      String capsuleID, String accessToken, double userLat, double userLng) {
    try {
      String mutation = """
            mutation UnlockCapsule(
          \$capsuleID : ID!
          \$userLat : Float!
          \$userLng : Float!
        ) {
          unlockCapsule(capsuleID: \$capsuleID, userLat: \$userLat, userLng: \$userLng)
        }
      """;

      Map<String, dynamic> variables = {
        "capsuleID": capsuleID,
        "userLat": userLat,
        "userLng": userLng,
      };

      return sendRequest(mutation, variables, accessToken);
    } catch (e) {
      log("Error in unlocking capsule | ${e.toString()}");
      rethrow;
    }
  }

  Future fetchUserByEmail(String accessToken, String sub, String email) async{
    
    try {
      String query = """
            query UserSearch(\$email:Email!) {
              userSearch(first: 1, filter: {
                email:{
                  eq:\$email
                }
              }) {
                edges {
                  node {
                    sub
                    email
                    id
                  }
                }
              }
            }
      """;

      Map<String, dynamic> variables = {
        "email": email,
      };

      final res = await sendRequest(query, variables, accessToken);
      final Map<String, dynamic> parsedJson = json.decode(res);
      if(parsedJson["data"]["userSearch"]["edges"].isEmpty){
        throw Exception("User not found");
      }
      return parsedJson["data"]["userSearch"]["edges"][0];
    } catch (e) {
      log("Error in fetching user by email | ${e.toString()}");
      rethrow;
    }
  }
}
