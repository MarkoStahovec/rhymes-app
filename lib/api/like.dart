import 'dart:io';
import 'dart:typed_data';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../key.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';


class Like with ChangeNotifier {
  Future<dynamic> likeSong(int song_id) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.post(urlKey + "likes/", queryParameters: {
        "song_id": song_id
      });
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> unlikeSong(int song_id) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.delete(urlKey + "likes/unlike", queryParameters: {
        "song_id": song_id
      });
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllLikes() async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + "likes/getall/");
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }
}