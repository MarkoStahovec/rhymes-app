import 'dart:io';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../key.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {
  register(String email, String nickname, String password) async {
    var response;
    var dio = Dio();

    try {
      response = await dio.post(urlRegister + apiKey, data: {
        'email': email,
        'nickname': nickname,
        'password': password
      });
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }



  login(String nickname, String password)async{
    var response;
    var dio = Dio();
    dio.options.headers['content-Type'] = "application/x-www-form-urlencoded";
    try {
      FormData formData = FormData.fromMap({
        'grant_type': 'password',
        'client_id': null,
        'client_secret': null,
        'username': nickname,
        'password': password,
      });
      response = await dio.post(urlLogin + apiKey, data: formData);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response.data["access_token"]);
        Map<String, dynamic> payload = Jwt.parseJwt(response.data["access_token"]);
        prefs.setInt('user_id', payload["user_id"]);
      }

      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }
}