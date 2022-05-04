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


class Song with ChangeNotifier {
  Future<dynamic> getAllSongs() async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + "song/getall/");
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getSong(int song_id) async {
    Response response;

    var dio = Dio();
    //dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      final tempDir = await getTemporaryDirectory();
      tempDir.deleteSync(recursive: true);
      tempDir.create();
      File file = await File('${tempDir.path}/audio.mp3').create();
      response = await dio.get(urlKey + "song/get/" + song_id.toString());

      List<int> list = response.data.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);

      file.writeAsBytesSync(bytes);
      response.data = bytes;
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getSongInfo(int song_id) async {
    Response response;

    var dio = Dio();
    //dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + "song/getinfo/" + song_id.toString());
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }

  uploadSong(Uint8List bytes,) async {
    var dio = Dio();

    final mime = lookupMimeType('', headerBytes: bytes);
    String filetype = mime.toString().split("/")[1];
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/audio.mpeg').create();
    file.writeAsBytesSync(bytes);

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,
          filename: 'audio.mpeg',
          contentType: MediaType('audio',filetype)),
    });

    dio.options.headers['content-Type'] = 'audio/mpeg';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;
    dio.options.headers['responseType'] = ResponseType.plain;

    try {
      var response = await dio.post(urlKey + 'song/upload/', data: formData);
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }


}