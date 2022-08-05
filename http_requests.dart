import 'package:async/async.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_exercise/services/app_config.dart';
import 'dart:developer' as dev;

enum Exceptions { socketErr, formatErr, serverErr, err }

class HttpReq {
  static final HttpReq _instance = HttpReq._internal();

  factory HttpReq() => _instance;

  HttpReq._internal();

  static const String _appJson = 'application/json';

  static String get token => AppConfig.accessToken ?? '';

  static String _fetchUrl(String endPoint) {
    dev.log(AppConfig.baseUrl + endPoint, name: 'URL');
    return AppConfig.baseUrl + endPoint;
  }

  static Future<Result> postRequest(String endpoint, {Map? parameters}) async {
    try {
      var response = await http
          .post(
            Uri.parse(_fetchUrl(endpoint)),
            headers: {
              HttpHeaders.acceptHeader: _appJson,
              HttpHeaders.contentTypeHeader: _appJson,
              HttpHeaders.authorizationHeader: token
            },
            body: parameters != null ? json.encode(parameters) : null,
          )
          .timeout(const Duration(seconds: 60));
      return _returnResponse(response);
    } on SocketException {
      return Result.error(Exceptions.socketErr);
    } on ServerSocket {
      return Result.error(Exceptions.serverErr);
    } on FormatException {
      return Result.error(Exceptions.formatErr);
    } on HandshakeException {
      return Result.error(Exceptions.serverErr);
    }
  }

  static Future<Result> getRequest(String endpoint) async {
    try {
      var response = await http.get(
        Uri.parse(_fetchUrl(endpoint)),
        headers: <String, String>{
          HttpHeaders.acceptHeader: _appJson,
          HttpHeaders.contentTypeHeader: _appJson,
          HttpHeaders.authorizationHeader: token
        },
      ).timeout(const Duration(seconds: 60));
      return _returnResponse(response);
    } on SocketException {
      return Result.error(Exceptions.socketErr);
    } on ServerSocket {
      return Result.error(Exceptions.serverErr);
    } on FormatException {
      return Result.error(Exceptions.formatErr);
    } on HandshakeException {
      return Result.error(Exceptions.serverErr);
    }
  }

  static Result _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dev.log(jsonDecode(response.body).toString(), name: 'Error: 200');
        return Result.value(jsonDecode(response.body));
      case 400:
        dev.log(jsonDecode(response.body).toString(), name: 'Error: 400');
        return Result.error(Exceptions.err);
      case 401:
        dev.log(jsonDecode(response.body).toString(), name: 'Error: 401');
        return Result.error(Exceptions.err);
      case 403:
        dev.log(jsonDecode(response.body).toString(), name: 'Error: 403');
        return Result.error(Exceptions.err);
      case 500:
        dev.log(jsonDecode(response.body).toString(), name: 'Error: 500');
        return Result.error(Exceptions.err);
      default:
        dev.log(jsonDecode(response.body).toString(),
            name: 'Error: ${response.statusCode}');
        return Result.error(Exceptions.err);
    }
  }
}

/*Future<http.Response> getRequest(String endpoint) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url + $endpoint");
  dynamic response;
  try {
    String token =
        AppData.accessToken ?? await SharedPreferencesHelper.getHeaderToken();
    response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: token
      },
    ).timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}*/

/*Future<http.Response> putRequest(String endpoint, Map parameters, String token) async {
  final url = "http://15.206.169.147/" + endpoint;
  print("URL :: $url + $endpoint + $parameters");
  var response;
  try {
    response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token '+ token,
      },
      body: json.encode(parameters),
    );
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  //print(json.decode(response.body));
  updateReqTime();
  return response;
}

Future<http.Response> deleteRequest(String endpoint, String token) async {
  final url = "http://15.206.169.147/" + endpoint;
  print("URL :: $url + $endpoint + $token");
  var response;
  try {
    response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token '+ token,
      },
    );
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  //print(json.decode(response.body));
  updateReqTime();
  return response;
}*/
