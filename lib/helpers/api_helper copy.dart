import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web_etiquetas/models/etiqueta.dart';
import 'package:http/http.dart' as http;
import 'package:web_etiquetas/models/response.dart';
import 'package:web_etiquetas/helpers/constants.dart';

class ApiHelper {
  static Future<Response2> getEtiqueta(String fecini, String fecfin) async {
    Map<String, dynamic> request = {'fecini': fecini, 'fecfin': fecfin};
    var url = Uri.parse('${Constans.apiUrl}/etiquetas');
    var client = http.Client();
    http.Response response;
    try {
      response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json;charset=UTF-8',
              'Charset': 'utf-8',
              'accept': 'application/json',
            },
            body: jsonEncode(request),
          )
          .timeout(const Duration(seconds: 30));
    } on TimeoutException catch (_) {
      //throw ('Tiempo de espera alcanzado')
      client.close;
      return Response2(isSuccess: false, message: 'Tiempo de espera alcanzado');
    } on SocketException {
      client.close;
      throw ('Sin internet  o falla de servidor ');
    } on HttpException {
      client.close;
      throw ("No se encontro esa peticion");
    } on FormatException {
      client.close;
      throw ("Formato erroneo ");
    }
    var body = response.body;
    //print(body);
    List<Etiqueta> list = [];
    //var decodedJson = jsonDecode(body);
    var decodedJson = json.decode(utf8.decode(response.bodyBytes));
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Etiqueta.fromJson(item));
      }
    }
    return Response2(isSuccess: true, result: list);
  }
}
