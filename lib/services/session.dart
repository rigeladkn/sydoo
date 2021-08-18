// Session
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  String accessToken = "";
  String eventId = "";

  // Get Session access Token
  Future<String> getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("access_token")) {
      accessToken = prefs.getString("access_token");
    } else {
      accessToken = "";
    }
    return accessToken;
  }



  // Update Session access_token
  void updateSessionAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("access_token", token);
  }

  void deleteAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}