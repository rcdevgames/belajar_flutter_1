import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' show Client, Response;

const API_URL = "http://unitycode.site/flutter/api/";

class ApiHelper {
  ApiHelper._constructor();
  static final ApiHelper instance = ApiHelper._constructor();

  Client client = new Client();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<Response> get(String endpoint) async {
    return client.get("$API_URL$endpoint", headers: requestHeaders);
  }
  
  Future<Response> post(String endpoint, Map<String, dynamic> body) async {
    return client.post("$API_URL$endpoint", headers: requestHeaders, body: jsonEncode(body));
  }
  
  Future<Response> put(String endpoint, Map<String, dynamic> body) async {
    return client.put("$API_URL$endpoint", headers: requestHeaders, body: jsonEncode(body));
  }
  
  Future<Response> delete(String endpoint) async {
    return client.delete("$API_URL$endpoint", headers: requestHeaders);
  }
}

