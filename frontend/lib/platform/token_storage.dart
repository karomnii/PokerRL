import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const _tokenKey = 'token';
  static const _userKey = 'user';

  static Future<void> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_tokenKey, token);
  }

  static Future<String?> readToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_tokenKey);
  }

  static Future<void> saveUserJson(String json) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_userKey, json);
  }

  static Future<String?> readUserJson() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_userKey);
  }

  static Future<void> clearUser() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_userKey);
  }
}
