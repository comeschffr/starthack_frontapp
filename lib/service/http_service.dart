import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:starthack_frontapp/views/dashboard.dart';

class HttpService {
  static final _client = http.Client();

  static var _loginUrl =
      Uri.parse('https://tinder-starthack-backend.herokuapp.com/login');

  static var _registerUrl =
      Uri.parse('https://tinder-starthack-backend.herokuapp.com/register');

  static var _getMovie = Uri.parse(
      'https://tinder-starthack-backend.herokuapp.com/get_next_movies');

  static login(email, password, context) async {
    http.Response response = await _client.post(_loginUrl, body: {
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      var json = jsonDecode(response.body);

      if (json[0] == 'success') {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        EasyLoading.showError(json[0]);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static register(email, password, context) async {
    http.Response response = await _client.post(_registerUrl, body: {
      "email": email,
      "password": password,
    });
    print(response.body);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json[0] == 'username already exist') {
        await EasyLoading.showError(json[0]);
      } else {
        await EasyLoading.showSuccess(json[0]);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  Future<String> getnextcards() async {
    final response = await http.get(_getMovie);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}
